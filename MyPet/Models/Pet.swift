//
//  Pet.swift
//  MyPet
//
//  Created by stefano vecchiati on 09/10/2018.
//  Copyright © 2018 com.stefanovecchiati. All rights reserved.
//

import UIKit
import RealmSwift

@objcMembers class Pet: Object {
    
    dynamic var image : Data?
    
    dynamic var name : String?
    dynamic var type : String?
    dynamic var gender : String?
    
    dynamic var id : String!
    
    convenience init(name : String? = nil, type: String? = nil, gender: String? = nil, image: Data? = nil) {
        self.init()
        
        self.name = name
        self.type = type
        self.gender = gender
        
        self.image = image
        
        self.id = UUID().uuidString
        
        
    }
    
    func changeData(in realm: Realm = try! Realm(configuration: RealmUtils.config), name : String? = nil, type: String? = nil, gender: String? = nil, image: Data? = nil, pet: Pet? = nil) {
        do {
            try realm.write {
                
                self.name = name ?? pet?.name ?? self.name
                self.type = type ?? pet?.type ?? self.type
                self.gender = gender ?? pet?.gender ?? self.gender
                
                self.image = image ?? pet?.image ?? self.image
                
            }
        }catch {}
        
    }
    
    
    func add(in realm: Realm = try! Realm(configuration: RealmUtils.config)) {
        do {
            try realm.write {
                realm.add(self)
            }
        } catch {}
    }
    
    static func all(in realm: Realm = try! Realm(configuration: RealmUtils.config)) -> [Person] {
        return Array(realm.objects(Person.self))
    }
    
    func remove(in realm: Realm = try! Realm(configuration: RealmUtils.config)) {
        do {
            try realm.write {
                realm.delete(self)
            }
        } catch {}
    }

}
