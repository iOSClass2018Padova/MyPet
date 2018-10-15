//
//  Person.swift
//  Rubbrica
//
//  Created by stefano vecchiati on 24/09/2018.
//  Copyright © 2018 co.eggon. All rights reserved.
//

import UIKit
import RealmSwift

@objcMembers class Person: Object {
    
    dynamic var image : Data?
    
    dynamic var name : String?
    dynamic var surname : String?
    dynamic var mobile : String?
    dynamic var email : String?

    
    dynamic var id : String!
    
    private let pets : List<Pet> = List<Pet>()
    
    
    convenience init(name : String? = nil, surname: String? = nil, mobile: String? = nil, image: Data? = nil) {
        self.init()
        
        self.name = name
        self.surname = surname
        self.mobile = mobile
        
        self.image = image
        
        self.id = UUID().uuidString
        
        
    }
    
    func fullName() -> String {
        var fullName = ""
        
        fullName += (self.name != nil) ? self.name! + " " : ""
        fullName += self.surname ?? ""
        
        return fullName
    }
    
    func getPets() -> [Pet] {
        return Array(pets)
    }
    
    func addingPet(in realm: Realm = try! Realm(configuration: RealmUtils.config), pet : Pet) {
        do {
            try realm.write {
                pets.insert(pet, at: 0)
            }
        }catch {}
    }
    
    func removePet(in realm: Realm = try! Realm(configuration: RealmUtils.config), index: Int) {
        do {
            try realm.write {
                self.pets.remove(at: index)
            }
        }catch {}
    }
    
    func changeData(in realm: Realm = try! Realm(configuration: RealmUtils.config), name : String? = nil, surname: String? = nil, mobile: String? = nil, image: Data? = nil, person: Person? = nil) {
        do {
            try realm.write {
                
                self.name = name ?? person?.name ?? self.name
                self.surname = surname ?? person?.surname ?? self.surname
                self.mobile = mobile ?? person?.mobile ?? self.mobile
                
                self.image = image ?? person?.image ?? self.image
                
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
