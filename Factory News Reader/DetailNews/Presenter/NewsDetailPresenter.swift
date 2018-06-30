//
//  NewsDetailPresenter.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 29/06/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import Foundation

protocol NewsDetailView {
}

class NewsDetailPresenter {
    
    fileprivate var newsDetailView: NewsDetailView?
    
    var newsDetailData: NewsViewData!
    
    func attachView(_ view: NewsDetailView){
        newsDetailView = view
    }
}

