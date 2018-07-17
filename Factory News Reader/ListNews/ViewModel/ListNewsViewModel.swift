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
    var newsData: [NewsData] = []
    var successDownloadTime: Date?
    var listNewsCoordinatorDelegate: ListNewsCoordinatorDelegate?
    var realmService: RealmSerivce!
    var results: Results<NewsData>!
    var favouritesNewsData: [NewsData]! = []
    let disposeBag = DisposeBag()
    
    init(newsService: APIRepository){
        self.newsService = newsService
    }
    
    //MARK: funkcija koja prati podatke i obrađuje ih za viewč
    func initializeObservableDataAPI() -> Disposable{
        let downloadObserver = downloadTrigger.flatMap { [unowned self] (_) -> Observable<[Article]> in
            self.loaderControll.onNext(true)
            return self.newsService.observableFetchData()
        }
        return downloadObserver
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .map({ (articles)  -> DataAndErrorWrapper in
                let data =  articles.map { (news) -> NewsData in
                    return NewsData(value: ["title": news.title , "descriptionNews": news.description , "urlToImage": news.urlToImage])
                }
                return DataAndErrorWrapper(data: data, error: nil)
                
            })
            .catchError({ (error) -> Observable<DataAndErrorWrapper> in
                return Observable.just(DataAndErrorWrapper(data: [], error: error.localizedDescription))
            })
            .subscribe(onNext:{ [unowned self]  (wrapper) in
                if wrapper.error == nil {
                    self.dataIsReady.onNext(true)
                    self.loaderControll.onNext(false)
                    self.newsData = wrapper.data
                    self.successDownloadTime = Date()
                }else {
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
            return
        } else {
            self.downloadTrigger.onNext(true)
        }
    }
    
    func newsIsSelected(selectedNews: Int){
        self.listNewsCoordinatorDelegate?.openSingleNews(selectedNews: newsData[selectedNews])
    }
    //MARK: Funkcija koja govori što se radi na favourite Button akciju
    func favouriteButtonPressed(selectedNews: Int){
        let savedNews = newsData[selectedNews]
        self.realmService = RealmSerivce()
        if savedNews.isNewsFavourite {
            print("Birsem iz baze")
//            savedNews.isNewsFavourite = false
            self.realmService.delete(object: savedNews)
            
        } else {
            print("Spremam u bazu")
            savedNews.isNewsFavourite = true
            self.realmService.create(object: savedNews)
            
        }
    }
    
    //MARK: Usporedba podataka s APIa i Realma
    func compareRealmDataWithAPIData(){
        self.realmService = RealmSerivce()
        self.results = self.realmService.realm.objects(NewsData.self)
        let favoriteNews = self.realmService.realm.objects(NewsData.self)
        if favoriteNews.count != 0 {
            for element in favoriteNews {
                favouritesNewsData.append(element)
            }
        } else {
        }

        for (localData) in favouritesNewsData{
            for(apiData) in newsData {
                if localData.title == apiData.title {
                    apiData.isNewsFavourite = true
                }
            }
        }
    }
    
    
}

