//
//  DetailIngredientCell.swift
//  CocktailBook
//
//  Created by Muthu-BB on 21/12/23.
//

import UIKit

class DetailIngredientCell: UITableViewCell {
    
    @IBOutlet weak var lblIngredients:UILabel!
    @IBOutlet weak var lblIngredientsDisplay: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
