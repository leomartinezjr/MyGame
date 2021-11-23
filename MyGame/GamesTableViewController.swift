//
//  GamesTableViewController.swift
//  MyGame
//
//  Created by Luana Martinez de La Flor on 14/10/21.
//

import UIKit
import CoreData

class GamesTableViewController: UITableViewController {

    
    
    var fetchedResultController: NSFetchedResultsController<Game>! //classe da acesso para fazer pesquisa
    var label = UILabel()
    let seachController =  UISearchController(searchResultsController: nil)
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "Voce nao tem jogos cadastrados"
        label.textAlignment = .center
       
        seachController.searchResultsUpdater = self
        seachController.dimsBackgroundDuringPresentation = false //tira a cor escura na procura
        seachController.searchBar.tintColor = .white
        seachController.searchBar.barTintColor = .white
        navigationItem.searchController = seachController // colcoar a navigation bar dentro da navigation item
        
        seachController.searchBar.delegate = self
        loadGame()
        
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameSegue"{
            let vc = segue.destination as! GameViewController // trato a as info como sendo uma game view controle
            
            if let games = fetchedResultController.fetchedObjects { //recupero do bd Fetch as info para manda pa a outra telaq
                vc.game = games [tableView.indexPathForSelectedRow!.row]
            }
            
        }
        
    }
    
    
    func loadGame(filtreing: String = "") {
        
        let fetchResquest: NSFetchRequest <Game> = Game.fetchRequest() // faz a requisicao Fetch
        let sortDescritor = NSSortDescriptor(key: "title", ascending: true) //determina como ira organizar o banco pode ter mais d u
        fetchResquest.sortDescriptors = [sortDescritor] //organiza o banco como vc determinou
        
        if !filtreing.isEmpty{
            let predicate = NSPredicate(format: "title contains [c] %@", filtreing) //nspredicate é utilizada para filtar como vc vai procurar no cado pela titulo que contem o nome......%@ é o q sera procurado, [c] minuscula e maisculas
            fetchResquest.predicate = predicate
            
            
        }
        
        
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchResquest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self // habilito o delegate para ter acesso a outras funcoes
        
        do{
        try fetchedResultController.performFetch() //retorna os jogos ordenados pelo o titulo
        }catch{
            print(error.localizedDescription)
        }
        
        
    }
    
    

    // MARK: - Table view data source

  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {



        let count = fetchedResultController.fetchedObjects?.count ?? 0 // fetchObjects devolde oq foi salvo no bano
        
        tableView.backgroundView = count == 0 ? label : nil
        
        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GameTableViewCell //PARTE mais importante para recurar uma cell, tratada a cell como a cell customizada criada
        
        guard let game = fetchedResultController.fetchedObjects?[indexPath.row] else {
            return cell
        }
        cell.prepare(whit: game)

         

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{ // aqui abilita o swao da linha e faz atravez do context a exclusao do arquivo
            
            guard let game = fetchedResultController.fetchedObjects?[indexPath.row] else {return}
            context.delete(game)
            
            do{
                try context.save()
            }catch{
                print(error.localizedDescription)
            }
            
            
        }
        
        
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GamesTableViewController: NSFetchedResultsControllerDelegate{
   
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) { //toda vez que um for altera esse metdo dispara
        
        switch type {
        case .delete: // comando para deletar a linha da tableview
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with:.fade)
                
            }
           
        default:
            tableView.reloadData()
        }
        
        
        }
    }


extension GamesTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
   
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadGame()
        tableView.reloadData()

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadGame(filtreing: searchBar.text!) // recupera a string q user digitou
        tableView.reloadData()
    }
    
    
}
