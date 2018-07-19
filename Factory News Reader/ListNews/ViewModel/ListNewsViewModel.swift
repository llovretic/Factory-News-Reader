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
    var favouritesNewsData: [NewsData] = []
    
    init(newsService: APIRepository){
        self.newsService = newsService
    }
    
    //MARK: funkcija koja prati podatke i obrađuje ih za view
    func initializeObservableDataAPI() -> Disposable{
        
        let combineObserver = downloadTrigger.flatMap { [unowned self] (_) -> Observable<([Article], [NewsData])> in
            self.loaderControll.onNext(true)
             let downloadObserver = self.newsService.observableFetchData()
             let databaseObserver = self.realmService.favouriteNewsDataObservable()
           
           
            
            return Observable.combineLatest(downloadObserver,databaseObserver)
        }
            return combineObserver
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .observeOn(MainScheduler.instance)
            .map{ (wrapper, favourite) -> ([NewsData],[NewsData]) in
                let data = wrapper.map { (news) -> NewsData in
                    return NewsData(value: ["title": news.title , "descriptionNews": news.description , "urlToImage": news.urlToImage])
                }
                return (data, favourite)
            }
            .subscribe(onNext: { [unowned self] (newsData, favouritesData) in
                for (localData) in favouritesData{
                    for(apiData) in newsData {
                        if localData.title == apiData.title {
                            apiData.isNewsFavourite = true
                        }
                    }
                }
                self.listNewsData = newsData
                self.favouritesNewsData = favouritesData
                self.dataIsReady.onNext(true)
                self.loaderControll.onNext(false)
                self.successDownloadTime = Date()
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
            return
        } else {
            self.downloadTrigger.onNext(true)
        }
    }
    
    func newsIsSelected(selectedNews: Int){
        self.listNewsCoordinatorDelegate?.openSingleNews(selectedNews: listNewsData[selectedNews])
    }
    
    //MARK: Funkcija koja govori što se radi na favourite Button akciju
    func favouriteButtonPressed(selectedNews: Int){
        let savedNews = listNewsData[selectedNews]
        if savedNews.isNewsFavourite{
            let newsToDelete = realmService.realm.object(ofType: NewsData.self, forPrimaryKey: savedNews.title)
            self.realmService.delete(object: newsToDelete!)
            savedNews.isNewsFavourite = false
        }
        else {
            savedNews.isNewsFavourite = true
            self.realmService.create(object: savedNews)
        }
    }
}

