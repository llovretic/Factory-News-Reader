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
//
//protocol NewsView: NSObjectProtocol{
//    func startLoading()
//    func finishLoading()
//    func refreshNews()
//    func setEmptyUsers()
//}

class NewsListViewModel {
    
    fileprivate let newsService: APIService
//    weak fileprivate var newsView: NewsView?
    let dataIsReady = PublishSubject<Bool>()
    
    var newsData: [NewsViewData] = []
    var successTime = Date()
    let disposeBag = DisposeBag()
    
    init(newsService: APIService){
        self.newsService = newsService
    }
    
//    func attachView(_ view: NewsView){
//        newsView = view
//    }
    
    func getData(){
//        self.newsView?.startLoading()
        let newsObserver = newsService.getData()
        newsObserver
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map({ (news) -> [NewsViewData] in
                return news.map { (news) -> NewsViewData in
                    return NewsViewData(title: news.title, description: news.description, urlToImage: news.urlToImage)
                }
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (articles) in
                self.newsData = articles
                self.dataIsReady.onNext(true)
                let timeOfSuccess = Date()
                self.successTime = timeOfSuccess
            })
//            .disposed(by: disposeBag)
    }
    
    func inspectNews() {
        let currentTime = Date()
        let compareTime = successTime.addingTimeInterval((5*60))
        if compareTime > currentTime  {
            return
        } else {
            getData()
        }
    }
}

