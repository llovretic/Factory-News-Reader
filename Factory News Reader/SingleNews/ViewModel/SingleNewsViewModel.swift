//
//  NewsDetailPresenter.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 29/06/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import Foundation

class SingleNewsViewModel {
    
    weak var listNewsCoordinatorDelegate: ListNewsCoordinatorDelegate?
    var newsDetailData: NewsData!
    let realmService = RealmSerivce()

    func addOrRemoveFavouritesData() -> Bool{
        let savedNews = NewsData(value: newsDetailData)
        
        if (savedNews.isNewsFavourite == true) {
            self.realmService.delete(object: savedNews)
            newsDetailData.isNewsFavourite = false
        }
        else{
            savedNews.isNewsFavourite = true
            self.realmService.create(object: savedNews)
            newsDetailData.isNewsFavourite = true
        }
        return newsDetailData.isNewsFavourite
    }
}

