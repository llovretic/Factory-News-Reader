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
    let errorOccure = PublishSubject<Bool>()
    var newsData: [NewsViewData] = []
    var successDownloadTime: Date?
    weak var listDelegate: ListDelegate?
    
    init(newsService: APIService){
        self.newsService = newsService
    }
    
    func initializeObservableDataAPI() -> Disposable{
        let downloadObserver = downloadTrigger.flatMap { [unowned self] (_) -> Observable<[Article]> in
            self.loaderControll.onNext(true)
            return self.newsService.observableFetchData()
        }
        return downloadObserver
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .map({ (articles)  -> DataAndErrorWrapper in
                let data =  articles.map { (news) -> NewsViewData in
                    return NewsViewData(title: news.title, description: news.description, urlToImage: news.urlToImage)
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
                    self.errorOccure.onNext(true)
                }
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

