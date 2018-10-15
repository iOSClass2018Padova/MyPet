//
//  ListPeopleController.swift
//  MyPet
//
//  Created by stefano vecchiati on 09/10/2018.
//  Copyright © 2018 com.stefanovecchiati. All rights reserved.
//

import UIKit

protocol ListPeopleDelegate: class {
    func reloadContactCell()
    func addPerson(person : Person)
}

class ListPeopleController: UIViewController {
    
    private var listOfPerson : [Person] = []
    
    private var selectedContact : Person?
    private var selectedIndexPath : IndexPath!
    
    private var addNewPerson : Bool = false
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        listOfPerson = Person.all()
    }
    
    @IBAction func addPersonAction(_ sender: UIBarButtonItem) {
        selectedContact = nil
        addNewPerson = true
        self.performSegue(withIdentifier: "showPerson", sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "showPerson":
            if let destinationController = segue.destination as? PersonDetailController {
                destinationController.person = selectedContact ?? Person()
                
                destinationController.editingProfile = addNewPerson
                
                destinationController.delegate = self
            }
        default:
            break
        }
        
    }
    

}

extension ListPeopleController : UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfPerson.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListPeopleCell.kIdentifier, for: indexPath) as! ListPeopleCell
        
        cell.nameProfile.text = listOfPerson[indexPath.row].fullName()
        
        if let imageProfile = listOfPerson[indexPath.row].image {
            cell.imageProfile.image = UIImage(data: imageProfile)
        } else {
            cell.imageProfile.image = UIImage(named: "Placeholder-image")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addNewPerson = false
        selectedIndexPath = indexPath
        selectedContact = listOfPerson[indexPath.row]
        self.performSegue(withIdentifier: "showPerson", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            
            let alert = UIAlertController(title: "Elimina", message: "Sei sicuro di voler rimuovere l'utente?", preferredStyle: .alert)
            let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(no)
            let yes = UIAlertAction(title: "Si", style: .default, handler: { action in
                for pet in self.listOfPerson[indexPath.row].getPets() {
                    pet.remove()
                }
                self.listOfPerson[indexPath.row].remove()
                self.listOfPerson.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            alert.addAction(yes)
            self.present(alert, animated: true, completion: nil)
            
            
        }
    }
    
}

extension ListPeopleController : ListPeopleDelegate {
    
    func addPerson(person : Person) {
        if addNewPerson {
            person.add()
            listOfPerson.append(person)
            tableView.insertRows(at: [IndexPath(item: listOfPerson.count - 1, section: 0)], with: .automatic)
            addNewPerson = false
        }
    }
    
    func reloadContactCell() {
        tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
    }
    
}
