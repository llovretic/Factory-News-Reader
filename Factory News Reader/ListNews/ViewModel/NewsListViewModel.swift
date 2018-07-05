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

struct NewsViewData{
    let title: String
    let description: String
    let urlToImage: String
}

class NewsListViewModel {
    
    fileprivate let newsService: APIService
    let dataIsReady = PublishSubject<Bool>()
    let loaderControll = PublishSubject<Bool>()
    var newsData: [NewsViewData] = []
    var successDownloadTime = Date()
    
    init(newsService: APIService){
        self.newsService = newsService
    }
    
    func getDataFromTheService(){
        self.loaderControll.onNext(true)
        let newsObserver = newsService.observableFetchData()
        _ = newsObserver
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map({ (news) -> [NewsViewData] in
                return news.map { (news) -> NewsViewData in
                    return NewsViewData(title: news.title, description: news.description, urlToImage: news.urlToImage)
                }
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (articles) in
                self.newsData = articles
                self.loaderControll.onNext(true)
                self.dataIsReady.onNext(true)
                self.loaderControll.onNext(false)
                let timeOfSuccess = Date()
                self.successDownloadTime = timeOfSuccess
            })
    }
    
    
    func inspectNews() {
        let currentTime = Date()
        let compareTime = successDownloadTime.addingTimeInterval((5*60))
        if compareTime > currentTime  {
            return
        } else {
            getDataFromTheService()
        }
    }
}

