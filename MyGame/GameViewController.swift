//
//  GameViewController.swift
//  MyGame
//
//  Created by Luana Martinez de La Flor on 14/10/21.
//

import UIKit
import CoreData

class GameViewController: UIViewController {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbConsole: UILabel!
    @IBOutlet weak var lbReleaseDate: UILabel!
    @IBOutlet weak var ivCover: UIImageView!
    
    var game: Game!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lbTitle.text = game?.title
        lbConsole.text = game.console?.name
        if let releseDate = game.releaseDate{ // UMcmetodo para formatar uma data
            let formater = DateFormatter()
                formater.dateStyle = .long
                formater.locale = Locale(identifier: "pt-Br")
                lbReleaseDate.text = "Lançamento: " + formater.string(from: releseDate)
            }
        if let image = game.cover as? UIImage { // recupera a capa do jogo
            ivCover.image = image
        }else{
            ivCover.image = UIImage(named: "noCoverFull")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddEditViewController
        vc.game = game
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
}


    
    

