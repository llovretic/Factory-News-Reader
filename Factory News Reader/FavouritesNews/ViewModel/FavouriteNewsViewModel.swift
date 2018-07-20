//
//  FavouriteNewsViewModel.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 11/07/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import Foundation

class FavouriteNewsViewModel {
    //MARK: Varijable
    var favouriteNewsData: [NewsData] = []
    var realmService = RealmSerivce()
    var favouriteNewsCoordinatorDelegate: ListNewsCoordinatorDelegate?
    
    func getFavouriteNewsData(){
        favouriteNewsData.removeAll()
        let favouriteNews = self.realmService.realm.objects(NewsData.self)
        for item in favouriteNews{
            favouriteNewsData += [item]
        }
    }
    
    func newsSelected(selectedNews: Int) {
        print("VM")
        let newData = NewsData(value: favouriteNewsData[selectedNews])
        favouriteNewsCoordinatorDelegate?.openSingleNews(selectedNews: newData)
    }
    
    func favouriteButtonPressed(selectedFavouriteNews: Int){
        let savedNews = NewsData(value: favouriteNewsData[selectedFavouriteNews])
        self.realmService.delete(object: savedNews)
        self.favouriteNewsData.remove(at: selectedFavouriteNews)
    }
    
}
