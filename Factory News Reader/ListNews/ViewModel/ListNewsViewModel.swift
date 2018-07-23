//
//  VijestiPresenter.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 19/06/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RealmSwift

class ListNewsViewModel {
    
    fileprivate let newsService: APIRepository
    let dataIsReady = PublishSubject<Bool>()
    let loaderControll = PublishSubject<Bool>()
    let downloadTrigger = PublishSubject<Bool>()
    let errorOccured = PublishSubject<Bool>()
    var listNewsData: [NewsData] = []
    var successDownloadTime: Date?
    var listNewsCoordinatorDelegate: ListNewsCoordinatorDelegate?
    var realmService = RealmSerivce()
    var results: Results<NewsData>!
    
    init(newsService: APIRepository){
        self.newsService = newsService
    }
    
    //MARK: funkcija koja prati podatke i obrađuje ih za view
    func initializeObservableDataAPI() -> Disposable{
     
        let combineObserver = downloadTrigger.flatMap { [unowned self] (_) -> Observable<(DataAndErrorWrapper<NewsData>, DataAndErrorWrapper<NewsData>)> in
            self.loaderControll.onNext(true)
            let downloadObserver = self.newsService.observableFetchData()
            let databaseObserver = self.realmService.favouriteNewsDataObservable()
            
            let unwrappedDownloadObserver = downloadObserver.map({ (wrapperArticleData) -> DataAndErrorWrapper<NewsData> in
                let data = wrapperArticleData.map({ (article) -> NewsData in
                    return NewsData(value: ["title": article.title, "descriptionNews": article.description, "urlToImage": article.urlToImage])
                })
                return DataAndErrorWrapper(data: data, error: nil)
            })
            return Observable.combineLatest(unwrappedDownloadObserver,databaseObserver)
        }
        return combineObserver
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .map({ (newsData, favouriteData) -> (DataAndErrorWrapper<NewsData>, DataAndErrorWrapper<NewsData>) in
                for localData in favouriteData.data{
                    for apiData in newsData.data{
                        if localData.title == apiData.title{
                            apiData.isNewsFavourite = true
                        }
                    }
                }
                return (newsData, favouriteData)
            })
            .subscribe(onNext: { [unowned self] (newsData, favouritesData) in
                if newsData.error == nil{
                self.listNewsData = newsData.data
                self.dataIsReady.onNext(true)
                self.loaderControll.onNext(false)
                self.successDownloadTime = Date()
                }
                else {
                    self.errorOccured.onNext(true)
                }

            })
    }
    
    //MARK: Funkcija koja provjerava koliko su podaci stari, te jel potrebno triggerat novi download
    func checkingHowOldIsData() {
        let currentTime = Date()
        if (successDownloadTime == nil) {
            self.downloadTrigger.onNext(true)
            return
        }
        let compareTime = successDownloadTime?.addingTimeInterval((5*60))
        if compareTime! > currentTime  {
            compareAPIWithRealm()
            return
        } else {
            self.downloadTrigger.onNext(true)
        }
    }
    
    func newsIsSelected(selectedNews: Int){
        self.listNewsCoordinatorDelegate?.openSingleNews(selectedNews: listNewsData[selectedNews])
    }
    
    //MARK: Funkcija koja govori što se radi na favourite Button akciju
    func addOrRemoveDataFromFavourites(selectedNews: Int){
        let savedNews = NewsData(value: listNewsData[selectedNews])
        if savedNews.isNewsFavourite{
            self.realmService.delete(object: savedNews)
            listNewsData[selectedNews].isNewsFavourite = false
        }
        else {
            listNewsData[selectedNews].isNewsFavourite = true
            savedNews.isNewsFavourite = true
            self.realmService.create(object: savedNews)
        }
        self.dataIsReady.onNext(true)
    }
    
    func compareAPIWithRealm() {
        for apiData in listNewsData {
            apiData.isNewsFavourite = false
        }
        
        let favoriteNewsData = self.realmService.realm.objects(NewsData.self)
        for data in favoriteNewsData{
            for(apiData) in listNewsData {
                if data.title == apiData.title {
                    apiData.isNewsFavourite = true
                }
            }
        }
          self.dataIsReady.onNext(true)
    }
}

