//
//  ViewController+CoreData.swift
//  MyGame
//
//  Created by Luana Martinez de La Flor on 15/10/21.
//

import UIKit
import CoreData

// extensao para ajudar a extraior o context(para o coredate) do delegate
//evita ficar acessando o delegate toda hora
// Coredata metodo para salvar as persistencia, "ja dado" pelo coredata
extension UIViewController { // uma entensao para todas as Viewcontrollers
   
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate // trata um delegate comum como o Appdelate do app
        return appDelegate.persistentContainer.viewContext // extrai n o meu appdelate o presistente contain
        
    }
}
