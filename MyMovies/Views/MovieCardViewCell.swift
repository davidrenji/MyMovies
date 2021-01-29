//
//  MovieCardViewCell.swift
//  MyMovies
//
//  Created by David on 1/29/21.
//

import UIKit

class MovieCardViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIStackView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        //Functions added by extension
        cardView.addRoundCorners(radius: 10)
        cardView.addBoxShadow(opacity: 1, radius: 10, color: UIColor.white)
        
        posterImage.layer.cornerRadius = 15
    }
    
}
