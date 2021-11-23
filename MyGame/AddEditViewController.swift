//
//  AddEditViewController.swift
//  MyGame
//
//  Created by Luana Martinez de La Flor on 14/10/21.
//

import UIKit

class AddEditViewController: UIViewController {

    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfConsole: UITextField!
    @IBOutlet weak var dpReleaseDate: UIDatePicker!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var btCover: UIButton!
    @IBOutlet weak var ivCover: UIImageView!
    
    
    var game: Game!
    
    lazy var pickerView: UIPickerView = { // estancia e implementa o pickeview alem de colocar o delegate
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white
        return pickerView
    }()
    
    var consoleManager = ConsoleManager.shared // cria o console manager nessa tela e
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if game != nil {
            title = "Editar Jogoo"
            btAddEdit.setTitle("ALterar", for: .normal)
            tfTitle.text = game.title
            if let console = game.console, let index = consoleManager.consoles.firstIndex(of: console){
                tfConsole.text = console.name
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
            ivCover.image = game.cover as? UIImage
            if let realeseData = game.releaseDate{
                dpReleaseDate.date = realeseData
            }
            if game.cover != nil {
                btCover.setTitle(nil, for: .normal)
            }
            
        }
        
        prepareConsoleTextField()
        
     
    }
    
   func prepareConsoleTextField(){
        
        // Configuraca de uma toolbar que sera usada no pickerView
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width , height: 44))// cria a toolbar
        toolbar.tintColor = UIColor(named: "main")// muda a cor
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))// criar um botao
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))// cria o botao de done
        let btFlexibeLabel = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) // cria o espcpo ente os botoes
        
        toolbar.items = [btDone,btFlexibeLabel, btCancel]// adiciona os botes na tool bar
        
        
        tfConsole.inputView = pickerView // adiciona o pincker view no textfield bar
        tfConsole.inputAccessoryView = toolbar // adiciona a toolbar na picje
    }
    
    @objc func cancel(){ // configura o botao cancel da tool bar
        tfConsole.resignFirstResponder()
        
    }
    @objc func done(){ // configura o botao done
        
        tfConsole.text = consoleManager.consoles [ pickerView.selectedRow(inComponent: 0)].name // seta o nome escolhido na textfiel mas náo faz a persistencia
        
        cancel() // chama a func cancel para tirar o pinckview
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        consoleManager.loadConsoles(with: context)
    }
    
     
    @IBAction func addEditCover(_ sender: Any) {
        
        let alert = UIAlertController(title: "Selecionar Poster", message: "De onde voce quer escolher o poster ?", preferredStyle: .actionSheet)
            
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
                    self.selectPicture(souceType: .camera)
            })
            alert.addAction(cameraAction)
        }
       
        let librayAction = UIAlertAction(title: "Biblioteca de Fotos", style: .default)  { (action: UIAlertAction) in
            self.selectPicture(souceType: .photoLibrary )
    }
            alert.addAction(librayAction)
        
        let photoAction = UIAlertAction(title: "Album de fotos", style: .default) { (action:UIAlertAction) in
            self.selectPicture(souceType: .savedPhotosAlbum)
        }
        alert.addAction(photoAction)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
}
    func selectPicture (souceType: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = souceType
        imagePicker.delegate = self
        imagePicker.navigationBar.tintColor = UIColor(named: "main")
        present(imagePicker, animated: true, completion: nil)
        }
    
    
    @IBAction func addEditgame(_ sender: Any) { // botao de adicionar jogo
       
        
        
        if game == nil { // se no banco nao houver adiciona um novo jogo
            game = Game(context: context) // AQUI precisa recuperar o context do appDelegate mas foi feito por extensao
        }
            game.title = tfTitle.text // seta oq user escreveu com o game.title do banco
            game.releaseDate = dpReleaseDate.date // "   "    "   "  game.releaseDate do banco
            
            if !tfConsole.text!.isEmpty{ // AQUI faz a persistenia do Consoles/ se o textfield n estiver s\vazio ele salva
                let console = consoleManager.consoles[pickerView.selectedRow(inComponent: 0)]
                game.console = console
                }
            game.cover = ivCover.image
            
            
            
            
            
            do {  try context.save() // Aqui é onde salva todoas das info no banco é necessario um try catch para erro
            }catch{
                print(error.localizedDescription)
            }
            navigationController?.popViewController(animated: true) // sai da tela, retornando para anterior
        }
        
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



extension AddEditViewController: UIPickerViewDelegate, UIPickerViewDataSource { // pelo delegate cponfigra o pinkervir
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { // seta o numeor de colunas
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return consoleManager.consoles.count // seta o numero de linhas nessa caso o numero de consoloes cadastrados
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    
        let console = consoleManager.consoles[row]
        return console.name // mostra p nome ja salvo na pinkeview
    }
}

extension AddEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    
   
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
      
        
        let image = info [.originalImage] as? UIImage
        ivCover.image =  image
        btCover.setTitle(nil, for: .normal)
        dismiss(animated: true, completion: nil)
        
        
        
        
    }
    
    
}
