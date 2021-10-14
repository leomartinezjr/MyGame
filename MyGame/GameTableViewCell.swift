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

}
