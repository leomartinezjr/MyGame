//
//  ConsoleTableViewController.swift
//  MyGame
//
//  Created by Luana Martinez de La Flor on 14/10/21.
//

import UIKit

class ConsoleTableViewController: UITableViewController {

    
    var consoleManager = ConsoleManager.shared
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadConsole()
        

    }

    func loadConsole(){
        consoleManager.loadConsoles(with: context)
        tableView.reloadData()
    }
    
    
    
    @IBAction func addConsole(_ sender: Any) {
        showAlert(with: nil)
    }
  
    //MARK:- botao de alerta
    
    func showAlert(with console: Console?) {// funcao q rece um consoloe
        
        let title = console == nil ? "Adiciona" : "Editar" // aqui configura os textos
        let alert = UIAlertController(title: title + " Plataforma", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Nome da Plataforma"
            if let name = console?.name{
                textField.text = name
            }
        }
       // aqui é a configuracao do botato em si
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action) in
            let console = console ?? Console(context: self.context)
            console.name = alert.textFields?.first?.text
            do{
                try self.context.save()
                self.loadConsole()
            }catch{
                print(error.localizedDescription)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.view.tintColor = UIColor(named: "second")
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source

  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consoleManager.consoles.count
    }
    
    
    
    // ao clicar aparecera o show alerte aonde podemos editar
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let console = consoleManager.consoles[indexPath.row]
        showAlert(with: console)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let console = consoleManager.consoles[indexPath.row]
        cell.textLabel?.text = console.name

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
        if editingStyle == .delete {
            consoleManager.deleteConsole(index: indexPath.row, context: context)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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


