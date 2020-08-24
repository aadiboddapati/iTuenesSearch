//
//  AlbumsTableCell.swift
//  iTuenesSearch
//
//  Created by chiranjeevi macharla on 23/08/20.
//  Copyright © 2020 Adinarayana. All rights reserved.
//

import UIKit

class AlbumsTableCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var artistNameLbl: UILabel!
    @IBOutlet weak var trackNameLbl: UILabel!
    @IBOutlet weak var collectionNameLbl: UILabel!
    @IBOutlet weak var collectionPriceLbl:UILabel!
    @IBOutlet weak var releaseDateLbl:UILabel!
    @IBOutlet weak var addToCartButton:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 10
        
        artworkImageView.layer.cornerRadius = artworkImageView.bounds.width / 2
        artworkImageView.layer.masksToBounds = true
        artworkImageView.clipsToBounds = true

    }
    
    func configureCell(album:Result)  {
        artworkImageView.sd_setHighlightedImage(with: URL(string: album.artworkUrl100 ?? "")!, options: .continueInBackground) { (image, error, cacheTYPE, url) in
            self.artworkImageView.image = image
        }
        artistNameLbl.text = "Artist Name: " + ( album.artistName ?? "" )
        trackNameLbl.text = "Track Name: " + ( album.trackName ?? "" )
        collectionNameLbl.text = "Collection Name: " + ( album.collectionName ?? "" )
        collectionPriceLbl.text = "Price: " +  "\(album.collectionPrice ?? 0)" + "$"
        
        let (_, dateString) = convertStringToDate(dateString: album.releaseDate ?? "")
        releaseDateLbl.text = "Release: " + dateString
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
