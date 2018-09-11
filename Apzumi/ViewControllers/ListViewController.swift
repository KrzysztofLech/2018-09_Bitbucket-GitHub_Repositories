//
//  ListViewController.swift
//  Apzumi
//
//  Created by Krzysztof Lech on 11.09.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var repoViewModel: RepoViewModel = {
        return RepoViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: RepoTableViewCell.toString(), bundle: nil), forCellReuseIdentifier: RepoTableViewCell.toString())
        getData()
    }
    
    private func getData() {
        repoViewModel.getData { [unowned self] in
            self.tableView.reloadData()
        }
    }
}

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
}

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
        }
    }
}
