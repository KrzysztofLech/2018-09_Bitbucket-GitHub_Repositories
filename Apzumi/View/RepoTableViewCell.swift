//
//  RepoTableViewCell.swift
//  Apzumi
//
//  Created by Krzysztof Lech on 11.09.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var avatarImageView:   UIImageView!
    @IBOutlet private weak var repoNameLabel:     UILabel!
    @IBOutlet private weak var ownerNameLabel:    UILabel!
    @IBOutlet private weak var dataSourceLabel:   UILabel!
    
    var avatarURL: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCellAppearance()
        resetCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
    }
    
    private func configureCellAppearance() {
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
    }
    
    private func resetCell() {
        activityIndicator.startAnimating()
        avatarImageView.image = nil
        avatarURL             = ""
        repoNameLabel.text    = ""
        ownerNameLabel.text   = ""
        dataSourceLabel.text  = ""
    }
    
    func update(repoName: String, ownerName: String, avatarUrl: String, source: String) {
        self.avatarURL = avatarUrl
        
        repoNameLabel.text = repoName
        ownerNameLabel.text = ownerName
        
        dataSourceLabel.text = source
        dataSourceLabel.textColor = UIColor(named: source)
    }
}
