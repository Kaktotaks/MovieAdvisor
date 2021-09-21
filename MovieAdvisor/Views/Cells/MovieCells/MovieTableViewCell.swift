//
//  MovieTableViewCell.swift
//  MovieAdvisor
//
//  Created by Леонід Шевченко on 02.09.2021.
//

import UIKit
import SDWebImage

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var desriptionLabel: UILabel!
    
    //MARK: - Class Life Сycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius = 24
    }
    
    //Privat
    private func setupUI() {
        self.movieNameLabel.textColor = .white
        self.desriptionLabel.textColor = .white
        
        self.selectionStyle = .none
    }

    //Public
    func movieConfigureWith(imageURL: URL?, movieName: String?, desriptionText: String?) {
        self.movieNameLabel.text = movieName
        self.desriptionLabel.text = desriptionText
        self.posterImageView.sd_setImage(with: imageURL, completed: nil)
        self.setupUI()
    }
 
    
}
