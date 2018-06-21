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
    func setEmptyUsers()
}


class VijestiPresenter {
    
    fileprivate let vijestiService: APIService
    weak fileprivate var vijestiView: VijestiView?
    var vijestiData: [VijestiViewData] = []
    
    init(vijestiService: APIService){
        self.vijestiService = vijestiService
    }
    
    func attachView(_ view: VijestiView){
        vijestiView = view
    }
    
    func parsiranjeData(vijesti: [Clanak] )-> [VijestiViewData]{
        let mappedvijesti = vijesti.map { (novosti) -> VijestiViewData in
            return VijestiViewData(title: novosti.title, description: novosti.description, urlToImage: novosti.urlToImage)
        }
        
        return(mappedvijesti)
    }

    
    func getData(){
        self.vijestiView?.startLoading()
        vijestiService.getData{ vijesti in
            self.vijestiView?.finishLoading()
            self.vijestiData = self.parsiranjeData(vijesti: vijesti!)
            self.vijestiView?.setVijesti(self.vijestiData)
        }
    

    }
   

}

