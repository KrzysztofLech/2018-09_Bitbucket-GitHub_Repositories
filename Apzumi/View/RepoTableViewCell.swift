//
//  RepoTableViewCell.swift
//  Apzumi
//
//  Created by Krzysztof Lech on 11.09.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var avatarImageView:   UIImageView!
    @IBOutlet weak var repoNameLabel:     UILabel!
    @IBOutlet weak var ownerNameLabel:    UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        resetCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
    }
    
    private func resetCell() {
        activityIndicator.startAnimating()
        avatarImageView.image = nil
        repoNameLabel.text = ""
        ownerNameLabel.text = ""
    }
}
