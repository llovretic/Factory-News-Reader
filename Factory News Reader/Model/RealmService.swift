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
    
    func create<T: NewsData>(object: T) -> Bool {
        do {
            try realm.write {
                realm.add(object)
            }
            
        } catch {
            return false
        }
        return true
    }
    
    func delete<T: NewsData>(object: T) -> Bool{
        do{
            try realm.write {
                realm.delete(realm.objects(NewsData.self).filter("title=%@", object.title!))
            }
        }catch {
            return false
        }
        return true
    }
    
    func favouriteNewsDataObservable() ->(Observable<DataAndErrorWrapper<NewsData>>) {
        var favouriteNews: [NewsData] = []
        let favouriteNewsData = self.realm.objects(NewsData.self)
        for item in favouriteNewsData{
            favouriteNews += [item]
        }
        return Observable.just(DataAndErrorWrapper(data: favouriteNews, error: nil))
    }
}
