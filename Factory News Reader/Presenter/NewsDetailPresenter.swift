//
//  NewsDetailPresenter.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 29/06/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import Foundation

protocol NewsDetailView {
    func setDetailNews(_ news: [NewsViewData])
}

class NewsDetailPresenter {
    
    fileprivate var newsDetailView: NewsDetailView?
    
    var newsData: [NewsViewData] = []

    
    func attachView(_ view: NewsDetailView){
        newsDetailView = view
        print(newsData)
    }
    
//    func getDetailData(){
//        newsData = data
//    }
//    

}

