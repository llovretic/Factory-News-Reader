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
    let newsIsFavourited = PublishSubject<Bool>()
    
    var realm = try! Realm()
    
    func create<T: NewsData>(object: T) {
        do {
            try realm.write {
                realm.add(object)
                self.newsIsFavourited.onNext(true)
            }
        } catch let error{
                print(error.localizedDescription)
        }
    }
    
    func delete<T: NewsData>(object: T){
        do{
            try realm.write {
                realm.delete(object)
                self.newsIsFavourited.onNext(false)
            }
        }catch let error {
            print(error.localizedDescription)
        }
    }
}
