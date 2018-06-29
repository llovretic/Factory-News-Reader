//
//  VijestiPresenter.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 19/06/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import Foundation
import UIKit

struct NewsViewData{
    let title: String
    let description: String
    let urlToImage: String
}

protocol NewsView: NSObjectProtocol{
    func startLoading()
    func finishLoading()
    func setNews(_ news: [NewsViewData])
    func setEmptyUsers()
}


class NewsListPresenter {
    
    fileprivate let newsService: APIService
    weak fileprivate var newsView: NewsView?
    
    var newsData: [NewsViewData] = []
    var time = Date()
    var newsImage = UIImage()
    var newsTitle = UILabel()
    var newsDescrtipiton = UITextView()
    
    init(newsService: APIService){
        self.newsService = newsService
    }
    
    func attachView(_ view: NewsView){
        newsView = view
    }
    
    func parsingData(news: [Article] ) -> [NewsViewData]{
        let mappedNews = news.map { (news) -> NewsViewData in
            return NewsViewData(title: news.title, description: news.description, urlToImage: news.urlToImage)
        }
        return(mappedNews)
    }

    
    func getData(){
        self.newsView?.startLoading()
        newsService.getData{ news in
            self.newsView?.finishLoading()
            self.newsData = self.parsingData(news: news!)
            self.newsView?.setNews(self.newsData)
            let timeSuccess = Date()
            self.time = timeSuccess
        }
    

    }
    
    func inspectNews() {
        let date = Date()
        let compareTime = time.addingTimeInterval((5*60))
        if compareTime > date  {
            return
        } else {
            getData()
            let newViewController = NewsTableViewController()
            newViewController.tableView.reloadData()
            
        }
    }

}

