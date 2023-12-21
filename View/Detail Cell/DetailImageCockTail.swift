//
//  DetailImageCockTail.swift
//  CocktailBook
//
//  Created by Muthu-BB on 21/12/23.
//

import UIKit

class DetailImageCockTail: UITableViewCell {
    
    
    @IBOutlet weak var lblCockTailName:UILabel!
    @IBOutlet weak var  imageViewFavourite:UIImageView!
    @IBOutlet weak var lblPreparationMinute:UILabel!
    @IBOutlet weak var imageViewCockTail:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
