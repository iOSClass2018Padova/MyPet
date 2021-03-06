//
//  PersonDetailCells.swift
//  MyPet
//
//  Created by stefano vecchiati on 09/10/2018.
//  Copyright © 2018 com.stefanovecchiati. All rights reserved.
//

import UIKit


class DetailPersonInfoCell: UITableViewCell {
    
    enum TextFieldType : Int {
        case name = 0
        case surname
        case mobile
    }
    
    static let kIdentifier = "DetailPersonInfoCell"
    
    private var editingPerson : Person!
    
    weak var delegate: DetailPersonEditDelegate?
    
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet var lineViews: [UIView]!
    
    @IBOutlet weak var imageProfile: UIButton! {
        didSet {
            imageProfile.layer.cornerRadius = imageProfile.frame.width / 2
            imageProfile.imageView?.contentMode = .scaleAspectFill
            imageProfile.clipsToBounds = true
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setup(withObject object : Person, withEditingMode edit : Bool) {
        
        editingPerson = Person(value: object)
        
        for textField in textFields {
            switch textField.tag {
            case TextFieldType.name.rawValue:
                textField.text = object.name
            case TextFieldType.surname.rawValue:
                textField.text = object.surname
            case TextFieldType.mobile.rawValue:
                textField.text = object.mobile
            default:
                break
            }
        }
        
        if let imageProfile = object.image {
            self.imageProfile.setImage(UIImage(data: imageProfile), for: .normal)
        } else {
            self.imageProfile.setImage(UIImage(named: "Placeholder-image"), for: .normal)
        }
        
        self.imageProfile.isUserInteractionEnabled = edit
        
        for lineView in lineViews {
            lineView.isHidden = !edit
        }
        
        for textField in textFields {
            textField.isEnabled = edit
            textField.delegate = edit ? self : nil
        }
        
    }
    @IBAction func editingTextAction(_ sender: UITextField) {
        switch sender.tag {
        case TextFieldType.name.rawValue:
            editingPerson.changeData(name: sender.text)
        case TextFieldType.surname.rawValue:
            editingPerson.changeData(surname : sender.text)
        case TextFieldType.mobile.rawValue:
            editingPerson.changeData(mobile : sender.text)
        default:
            break
        }
        
        delegate?.editedPerson(person: editingPerson)
        
    }
    
    
}

extension DetailPersonInfoCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
}

class DetailPersonAddPet: UITableViewCell {
    
    static let kIdentifier = "DetailPersonAddPet"
    
    
    @IBOutlet weak var buttonAdd: UIButton!
    
    func setup(add: Bool) {
        switch add {
        case true:
            buttonAdd.setImage(UIImage(named: "add"), for: .normal)
        case false:
            buttonAdd.setImage(UIImage(named: "close"), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}


class DetailPersonPetInfo: UITableViewCell {
    
    enum TextFieldType : Int {
        case name = 0
        case type
        case gender
    }
    
    weak var delegate: DetailPersonEditDelegate?
    
    static let kIdentifier = "DetailPersonPetInfo"
    
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet weak var saveButton: UIButton! {
        didSet {
            saveButton.layer.cornerRadius = 5
            saveButton.clipsToBounds = true
        }
    }
    @IBOutlet var lineViews: [UIView]!
    
    @IBOutlet weak var imageProfile: UIButton! {
        didSet {
            imageProfile.layer.cornerRadius = imageProfile.frame.width / 2
            imageProfile.imageView?.contentMode = .scaleAspectFill
            imageProfile.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var pet : Pet = Pet()
    
    func setup(adding : Bool, withObject object : Pet?) {
        
        adding ? (saveButton.isHidden = false) : (saveButton.isHidden = true)
        
        if let obj = object {
            
            for textField in textFields {
                switch textField.tag {
                case TextFieldType.name.rawValue:
                    textField.text = obj.name
                case TextFieldType.type.rawValue:
                    textField.text = obj.type
                case TextFieldType.gender.rawValue:
                    textField.text = obj.gender
                default:
                    break
                }
            }
            
        } else {
            for textField in textFields {
                textField.text = ""
            }
        }
        
        if let imageProfile = object?.image {
            self.imageProfile.setImage(UIImage(data: imageProfile), for: .normal)
        } else {
            self.imageProfile.setImage(UIImage(named: "Placeholder-image"), for: .normal)
        }
        
        self.imageProfile.isUserInteractionEnabled = adding
        
        for lineView in lineViews {
            lineView.isHidden = !adding
        }
        
        for textField in textFields {
            textField.isEnabled = adding
            textField.delegate = adding ? self : nil
        }
        
    }
    
    @IBAction func editingTextAction(_ sender: UITextField) {
        switch sender.tag {
        case TextFieldType.name.rawValue:
            pet.changeData(name: sender.text)
        case TextFieldType.type.rawValue:
            pet.changeData(type : sender.text)
        case TextFieldType.gender.rawValue:
            pet.changeData(gender : sender.text)
        default:
            break
        }
        
    }
    @IBAction func savePet(_ sender: Any) {
        delegate?.addingPet(pet: pet)
    }
    
}

extension DetailPersonPetInfo: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
}
