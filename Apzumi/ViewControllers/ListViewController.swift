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
    
    lazy var repoViewModel: RepoViewModel = {
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
        cell.update(repoName: cellData.repoName, ownerName: cellData.ownerName, avatarUrl: cellData.avatarUrl)
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    
}
