//
//  ListViewController.swift
//  Apzumi
//
//  Created by Krzysztof Lech on 11.09.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private var noDataView: UIView!
    @IBOutlet private weak var bitbucketCounterLabel: UILabel!
    @IBOutlet private weak var githubCounterLabel: UILabel!
    
    private lazy var repoViewModel: RepoViewModel = {
        return RepoViewModel()
    }()
    private var dataShouldBeFetched = true
    private let transitionController = TransitionController()
    
    
    // MARK: - Init methods
    
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: RepoTableViewCell.toString(), bundle: nil), forCellReuseIdentifier: RepoTableViewCell.toString())
        setupNoDataTablePlaceholder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if dataShouldBeFetched { getData() }
    }
    
    
    // MARK: - Other methods
    
    private func setupNoDataTablePlaceholder() {
        tableView.backgroundView = (repoViewModel.repositoriesCount > 0) ? nil : noDataView
    }
    
    private func getData() {
        dataShouldBeFetched = false
        if ReachabilityManager.shared.isReachable() {
            
            repoViewModel.getData { [unowned self] in
                if self.repoViewModel.repositoriesCount > 0 {
                    self.tableView.backgroundView = nil
                    self.bitbucketCounterLabel.text = self.repoViewModel.bitbucketCounter
                    self.githubCounterLabel.text = self.repoViewModel.githubCounter
                    self.setupNoDataTablePlaceholder()
                    self.tableView.reloadData()
                }
            }
            
        } else {
            
            alertWithTwoButtons(title: "Internet is no available!",
                              message: "What do you want to do?",
                      leftButtonTitle: "Try again",
                     rightButtonTitle: "Use cached data",
                     leftButtonCompletion: { (_) in
                        self.getData()
                        },
                     rightButtonCompletion: { (_) in
                        print("Use cached data!")
                        })
        }
    }
    
    @IBAction func sortButtonAction(_ sender: UIButton) {
        repoViewModel.dataShouldBeSorted = !sender.isSelected
        sender.isSelected = !sender.isSelected
        tableView.reloadData()
    }
}

// MARK: - Table Data Source methods

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repoViewModel.repositoriesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepoTableViewCell.toString(), for: indexPath) as? RepoTableViewCell else { return UITableViewCell() }
        
        let cellData = repoViewModel.getCellData(withIndex: indexPath.row)
        cell.update(repoName: cellData.repoName,
                   ownerName: cellData.ownerName,
                   avatarUrl: cellData.avatarUrl,
                      source: cellData.source)
        
        ImageManager.getImage(withUrl: cellData.avatarUrl) { image in
            if cell.avatarURL == cellData.avatarUrl {
                cell.activityIndicator.stopAnimating()
                cell.avatarImageView.image = image
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isDragging {
            cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
}

// MARK: - Table Delegate methods

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailsVC", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            let vc = segue.destination as? DetailsViewController,
            let index = sender as? Int {
            
            let detailsData = repoViewModel.getDetailsData(withIndex: index)
            vc.avatarURL = detailsData.avatarUrl
            vc.ownerName = detailsData.ownerName
            vc.repoName  = detailsData.repoName
            vc.repoDescription = detailsData.description
            
            vc.transitioningDelegate = transitionController
        }
    }
}
