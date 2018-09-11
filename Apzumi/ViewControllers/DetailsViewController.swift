//
//  DetailsViewController.swift
//  Apzumi
//
//  Created by Krzysztof Lech on 11.09.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoDescriptionTextView: UITextView!
    
    var avatarURL: String = ""
    var ownerName: String = ""
    var repoName:  String = ""
    var repoDescription: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadAvatarImage()
        
        ownerNameLabel.text = ownerName
        repoNameLabel.text  = repoName
        repoDescriptionTextView.text = repoDescription
    }
    
    private func loadAvatarImage() {
        ImageManager.getImage(withUrl: avatarURL) {[unowned self] image in
            self.activityIndicator.stopAnimating()
            self.avatarImageView.image = image
        }
    }
    
    @IBAction func backButtonAction() {
        dismiss(animated: true, completion: nil)
    }
}
