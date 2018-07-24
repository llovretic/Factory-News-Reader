//
//  FavouriteNewsViewModel.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 11/07/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import Foundation
import RxSwift

class FavouriteNewsViewModel {
    //MARK: Varijable
    var favouriteNewsData: [NewsData] = []
    var realmService = RealmSerivce()
    var favouriteNewsCoordinatorDelegate: ListNewsCoordinatorDelegate?
    var dataIsReady = PublishSubject<Bool>()
    var favouriteNewsTrigger = PublishSubject<Bool>()
    var errorOccured = PublishSubject<Bool>()
    
    func getFavouriteNewsData() -> Disposable{
        let observerFavouriteTrigger = favouriteNewsTrigger
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (event) in
                if event {
                    self.favouriteNewsData.removeAll()
                    let favouriteNews = self.realmService.realm.objects(NewsData.self)
                    for item in favouriteNews{
                        self.favouriteNewsData += [NewsData(value: ["title": item.title!, "descrtipition": item.descriptionNews!, "urlToImage": item.urlToImage!, "isNewsFavourite": item.isNewsFavourite])]
                    }
                    self.dataIsReady.onNext(true)
                }
            })
        return observerFavouriteTrigger
    }
    
    
    func newsSelected(selectedNews: Int) {
        let newData = NewsData(value: favouriteNewsData[selectedNews])
        favouriteNewsCoordinatorDelegate?.openSingleNews(selectedNews: newData)
    }
    
    func removeDataFromFavourites(selectedFavouriteNews: Int){
        let savedNews = favouriteNewsData[selectedFavouriteNews]
        if self.realmService.delete(object: savedNews){
            self.favouriteNewsData.remove(at: selectedFavouriteNews)
            self.dataIsReady.onNext(true)
        }
        else {
            self.errorOccured.onNext(true)
        }
    }
    
}
