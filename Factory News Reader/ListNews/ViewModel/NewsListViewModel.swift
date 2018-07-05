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

class NewsListViewModel {
    
    fileprivate let newsService: APIService
    let dataIsReady = PublishSubject<Bool>()
    let loaderControll = PublishSubject<Bool>()
    let downloadTrigger = PublishSubject<Bool>()
    var newsData: [NewsViewData] = []
    var successDownloadTime: Date?
    
    init(newsService: APIService){
        self.newsService = newsService
    }
    
    func initializeObservableDataAPI() -> Disposable{
        self.loaderControll.onNext(true)
        let downloadObserver = downloadTrigger.flatMap { [unowned self] (_) -> Observable<[Article]> in
            return self.newsService.observableFetchData()
        }
        return downloadObserver
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .map({ (articles)  -> [NewsViewData] in
                return articles.map { (news) -> NewsViewData in
                    return NewsViewData(title: news.title, description: news.description, urlToImage: news.urlToImage)
                }
            })
            .subscribe(onNext:{ [unowned self]  (articles) in
                self.dataIsReady.onNext(true)
                self.loaderControll.onNext(false)
                self.newsData = articles
                self.successDownloadTime = Date()
            })
       
        
    }
    
    
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
}

