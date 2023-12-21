//
//  CockTailMainCell.swift
//  CocktailBook
//
//  Created by Muthu on 18/12/23.
//

import UIKit

class CockTailMainCell: UITableViewCell {

    
    @IBOutlet weak var lblCockTailName:UILabel!
    @IBOutlet weak var lblCockTailShotDescription:UILabel!
    @IBOutlet weak var imageViewFavourite: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
