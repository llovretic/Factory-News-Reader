//
//  VijestiPresenter.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 19/06/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import Foundation

struct VijestiViewData{
    let title: String
    let description: String
    let urlToImage: String
}

protocol VijestiView: NSObjectProtocol{
    func startLoading()
    func finishLoading()
    func setVijesti(_ vijesti: [VijestiViewData])
}

class VijestiPresenter {
    
    fileprivate let vijestiService: APIService
    weak fileprivate var vijestiView: VijestiView?
    
    init(vijestiService: APIService){
        self.vijestiService = vijestiService
    }
    
    func attachView(_ view: VijestiView){
        vijestiView = view
    }
    
    func getData(){
        
        }
    }

