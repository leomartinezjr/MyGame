//
//  ConsoleManager.swift
//  MyGame
//
//  Created by Luana Martinez de La Flor on 18/10/21.
//

import Foundation
import CoreData

class ConsoleManager { //Ex de singleton .....aonde o share carrega todas as info do class
    
    static let shared = ConsoleManager()
    var consoles : [Console] = []
    
    
    func loadConsoles(with context: NSManagedObjectContext)  {
        
        let fetchRequest: NSFetchRequest<Console> = Console.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do{
            consoles = try context.fetch(fetchRequest)
        }catch{
            print(error.localizedDescription)
        }
        
    
        
    }
    
    func deleteConsole(index: Int, context: NSManagedObjectContext) {
        let console = consoles[index]
        context.delete(console)
        do{
            try context.save()
            consoles.remove(at: index)
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    private init (){
        
    }
    
    
}


