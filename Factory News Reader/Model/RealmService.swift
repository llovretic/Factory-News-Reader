//
//  RealmService.swift
//  Factory News Reader
//
//  Created by Luka Lovretić on 13/07/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

class RealmSerivce {
    
    var realm = try! Realm()
    
    func create<T: Object>(object: T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch let error{
                print(error.localizedDescription)
        }
    }
    
    func delete<T: Object>(object: T){
        do{
            try realm.write {
                realm.delete(object)
            }
        }catch let error {
            print(error.localizedDescription)
        }
    }
}
