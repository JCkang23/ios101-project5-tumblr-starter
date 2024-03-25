//
//  PhotoCell.swift
//  ios101-project5-tumblr
//
//  Created by J C’kang on 21/03/2024.
//

import UIKit

class PhotoCell: UITableViewCell {

    @IBOutlet weak var poster: UIImageView!
    
    @IBOutlet weak var zoneText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
