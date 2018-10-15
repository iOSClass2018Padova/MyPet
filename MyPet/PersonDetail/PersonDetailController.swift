//
//  PersonDetailController.swift
//  MyPet
//
//  Created by stefano vecchiati on 09/10/2018.
//  Copyright © 2018 com.stefanovecchiati. All rights reserved.
//

import UIKit

protocol DetailPersonEditDelegate: class {
    func editedPerson(person: Person)
    func addingPet(pet: Pet)
}

class PersonDetailController: UIViewController {
    
    private let PERSON_INFO = 0
    private let ADD_PET = 1
    private let PET_INFO = 2
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var editingBarButtonItem: UIBarButtonItem!
    
    private var pickerController:UIImagePickerController?
    
    private var addingPet : Bool = false
    
    var person : Person = Person()
    weak var delegate : ListPeopleDelegate?
    
    var editingProfile : Bool = false
    private var editedPerson: Person!
    private var pets : [Pet] = []
    
    private lazy var addingNewElement : Bool = false
    
    private var cancelBarButtonItem : UIBarButtonItem!
    
    private var addingPictureOnProfile : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        
        editingBarButtonItem.title = editingProfile ? "Add" : "Edit"
        addingNewElement = editingProfile
        
        editedPerson = Person(value: person)
        
        pets = editedPerson.getPets()
        
        
    }
    
    
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        
        if editingProfile {
            
            person.changeData(person : editedPerson)
            
            guard (person.name != nil && !person.name!.isEmpty) || (person.surname != nil && !person.surname!.isEmpty) else {
                
                let alert = UIAlertController(title: "Attenzione", message: "O il Nome o il Cognome sono obbligatori", preferredStyle: .alert)
                let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                alert.addAction(okay)
                self.present(alert, animated: true, completion: nil)
                
                return }
            
            if addingNewElement {
                delegate?.addPerson(person: editedPerson)
            } else {
                delegate?.reloadContactCell()
            }
            
            if addingNewElement {
                navigationController?.popViewController(animated: true)
            }
        }
        
        dismissEditing()
        
    }
    
    @objc func cancelAction(_ sender: UIBarButtonItem) {
        editedPerson = Person(value: person)
        dismissEditing()
    }
    
    func dismissEditing() {
        editingProfile = !editingProfile
        
        editingBarButtonItem.title = editingProfile ? "Save" : "Edit"
        
        self.navigationItem.leftBarButtonItem = editingProfile ? cancelBarButtonItem : nil
        
        tableView.reloadData()
    }
    
    @IBAction func addPictureProfile(_ sender: UIButton) {
        
        self.pickerController = UIImagePickerController()
        self.pickerController!.delegate = self
        self.pickerController!.allowsEditing = true
        
        addingPictureOnProfile = sender.tag == 0 ? true : false
        
        let alert = UIAlertController(title: nil, message: "Foto profilo", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Annulla", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        #if !targetEnvironment(simulator)
        let photo = UIAlertAction(title: "Scatta foto", style: .default) { action in
            self.pickerController!.sourceType = .camera
            self.present(self.pickerController!, animated: true, completion: nil)
        }
        alert.addAction(photo)
        #endif
        
        let camera = UIAlertAction(title: "Carica foto", style: .default) { alert in
            self.pickerController!.sourceType = .photoLibrary
            self.present(self.pickerController!, animated: true, completion: nil)
        }
        alert.addAction(camera)
        
        present(alert, animated: true, completion: nil)
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

extension PersonDetailController: DetailPersonEditDelegate {
    
    func editedPerson(person: Person) {
        editedPerson = Person(value: person)
    }
    
    func addingPet(pet: Pet) {
        pet.add()
        person.addingPet(pet: pet)
        reloadTableForAddingPet(completion: { success in
            self.pets.insert(pet, at: 0)
            self.tableView.insertRows(at: [IndexPath(item: 0, section: 2)], with: .automatic)
        })
        
    }
    
    
}

extension PersonDetailController : UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == PET_INFO {
            return pets.count
        }
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case PERSON_INFO:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailPersonInfoCell.kIdentifier, for: indexPath) as! DetailPersonInfoCell
            
            cell.delegate = self
            cell.setup(withObject: editedPerson, withEditingMode: editingProfile)
            
            return cell
        case ADD_PET:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailPersonAddPet.kIdentifier, for: indexPath) as! DetailPersonAddPet
            
            cell.setup(add: !addingPet)
            
            return cell
        case PET_INFO:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailPersonPetInfo.kIdentifier, for: indexPath) as! DetailPersonPetInfo
            
            cell.delegate = self
            cell.setup(adding: indexPath.row == 0 && addingPet ? true : false, withObject: indexPath.row == 0 && addingPet ? nil : pets[indexPath.row])
            
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case PERSON_INFO:
            return 140
        case ADD_PET:
            return 70
        case PET_INFO:
            if indexPath.row == 0 && addingPet {
                return 187
            }
            return 120
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == ADD_PET {
            reloadTableForAddingPet(completion: { succes in
                
            })
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            
            person.removePet(index: indexPath.row)
            pets[indexPath.row].remove()
            pets.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func reloadTableForAddingPet(completion : @escaping (Bool) -> Void) {
        addingPet = !addingPet
        if addingPet { pets.insert(Pet(), at: 0) } else { pets.remove(at: 0) }
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(item: 0, section: 1)], with: .automatic)
        }
        tableView.performBatchUpdates({
            addingPet ? tableView.insertRows(at: [IndexPath(item: 0, section: 2)], with: .automatic) : tableView.deleteRows(at: [IndexPath(item: 0, section: 2)], with: .automatic)
        }, completion: { succes in
            completion(true)
        })
        
    }
}

// MARK: - ImagePicker Delegate
extension PersonDetailController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {
            debugPrint("No image found")
            return
        }
        
        let img = checkImageSizeAndResize(image: image)
        
        if addingPictureOnProfile {
            
            editedPerson?.changeData(image: img.pngData())
            tableView.reloadRows(at: [IndexPath(item: 0, section: 0)], with: .automatic)
            
        } else {
            
            let indexpathForPet = IndexPath(item: 0, section: 2)
            let petCell = tableView.cellForRow(at: indexpathForPet) as! DetailPersonPetInfo
            
            petCell.imageProfile.setImage(img, for: .normal)
            petCell.pet.image = img.pngData()
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    private func checkImageSizeAndResize(image : UIImage) -> UIImage {
        
        let imageSize: Int = image.pngData()!.count
        let imageDimension = Double(imageSize) / 1024.0 / 1024.0
        print("size of image in MB: ", imageDimension)
        
        if imageDimension > 15 {
            
            let img = image.resized(withPercentage: 0.5) ?? UIImage()
            
            return checkImageSizeAndResize(image: img)
            
        }
        
        return image
        
        
    }
    
}
