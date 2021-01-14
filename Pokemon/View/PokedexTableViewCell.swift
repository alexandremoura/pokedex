//
//  PokedexTableViewCell.swift
//  Pokemon
//
//  Created by Alexandre Rasta Moura on 12/01/21.
//

import UIKit
import UrlImageView

class PokedexTableViewCell: UITableViewCell {
    @IBOutlet weak var pokemonImageView : UrlImageView!
    @IBOutlet weak var pokemonNameLabel:UILabel!
    @IBOutlet weak var pokemonFavoriteImage:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
