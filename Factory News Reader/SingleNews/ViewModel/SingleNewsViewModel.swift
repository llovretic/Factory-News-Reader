//
//  NewsDetailPresenter.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 29/06/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import Foundation
import RxSwift

class SingleNewsViewModel {
    
    weak var listNewsCoordinatorDelegate: ListNewsCoordinatorDelegate?
    var newsDetailData: NewsData!
    let realmService = RealmSerivce()
    var errorOccured = PublishSubject<Bool>()
    

    func addOrRemoveFavouritesData() -> Bool{
        let savedNews = NewsData(value: newsDetailData)
        
        if (savedNews.isNewsFavourite == true) {
            if self.realmService.delete(object: savedNews){
                newsDetailData.isNewsFavourite = false
            }
            else{
                self.errorOccured.onNext(true)
            }
        }
        else{
            savedNews.isNewsFavourite = true
            if self.realmService.create(object: savedNews){
                newsDetailData.isNewsFavourite = true
            }
            else {
                self.errorOccured.onNext(true)
            }
            
        }
        return newsDetailData.isNewsFavourite
    }
}

