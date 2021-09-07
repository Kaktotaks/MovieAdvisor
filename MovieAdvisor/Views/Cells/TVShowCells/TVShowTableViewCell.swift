//
//  TVTableViewCell.swift
//  MovieAdvisor
//
//  Created by Леонід Шевченко on 03.09.2021.
//

import UIKit
import SDWebImage

class TVShowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var tvNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius = 24
    }
    
    private func setupUI() {
        self.tvNameLabel.textColor = .white
        self.descriptionLabel.textColor = .white
        
        self.selectionStyle = .none
    }
    
    func tvConfigureWith(imageURL: URL?, TVName: String?, desriptionText: String?) {
        self.tvNameLabel.text = TVName
        self.descriptionLabel.text = desriptionText
        self.posterImageView.sd_setImage(with: imageURL, completed: nil)
        self.setupUI()
    }

    
}
