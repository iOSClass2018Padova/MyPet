//
//  Pet.swift
//  MyPet
//
//  Created by stefano vecchiati on 09/10/2018.
//  Copyright © 2018 com.stefanovecchiati. All rights reserved.
//

import UIKit
import RealmSwift

enum Gender : Int {
    case male = 0
    case female
}

@objcMembers class Pet: Object {
    
    dynamic var image : Data?
    
    dynamic var name : String?
    dynamic var type : String?
    dynamic var gender : Int?
    
    dynamic var id : String!
    
    convenience init(name : String? = nil, type: String? = nil, gender: Gender? = nil, image: Data? = nil) {
        self.init()
        
        self.name = name
        self.type = type
        self.gender = gender?.rawValue
        
        self.image = image
        
        self.id = UUID().uuidString
        
        
    }
    
    func changeData(in realm: Realm = try! Realm(), name : String? = nil, type: String? = nil, gender: Int? = nil, image: Data? = nil, pet: Pet? = nil) {
        do {
            try realm.write {
                
                self.name = name ?? pet?.name ?? self.name
                self.type = type ?? pet?.type ?? self.type
                self.gender = gender ?? pet?.gender ?? self.gender
                
                self.image = image ?? pet?.image ?? self.image
                
            }
        }catch {}
        
    }
    
    
    func add(in realm: Realm = try! Realm()) {
        do {
            try realm.write {
                realm.add(self)
            }
        } catch {}
    }
    
    static func all(in realm: Realm = try! Realm()) -> [Person] {
        return Array(realm.objects(Person.self))
    }
    
    func remove(in realm: Realm = try! Realm()) {
        do {
            try realm.write {
                realm.delete(self)
            }
        } catch {}
    }

}
