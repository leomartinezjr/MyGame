//
//  GameTableViewCell.swift
//  MyGame
//
//  Created by Luana Martinez de La Flor on 14/10/21.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    
    @IBOutlet weak var ivCover: UIImageView!
    @IBOutlet weak var lbTitile: UILabel!
    @IBOutlet weak var lbConsole: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func prepare(whit game: Game) {
        
        lbTitile.text = game.title ?? " "
        lbConsole.text = game.console?.name ?? " "
        if let image = game.cover as? UIImage{
            ivCover.image = image
        } else{
            ivCover.image = UIImage(named: "noCover")
        }
        
        
        
    }
    
    
}
