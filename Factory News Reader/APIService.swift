//
//  APIService.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 19/06/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import Foundation

class APIService {
    
    let url = URL(string: "https://newsapi.org/v1/articles?apiKey=6946d0c07a1c4555a4186bfcade76398&sortBy=top&source=bbc-news")
    
    var vrijeme = Date()
    
    var clanci: [Clanak] = []
    
    //MARK: Funkcija za skidanje podataka
    @objc func getData() {
        guard let downloadURL = url else { return }
        URLSession.shared.dataTask(with: downloadURL) { data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else {
//                Greska.alert(title:"Greška", message: "Ups, došlo je do pogreške prilikom prikupljanja podataka.", viewController: VijestiController)
                self.getData()
                return
            }
            do
            {
                let time = NSDate()
                let decoder = JSONDecoder()
                let podaci = try decoder.decode(Stranica.self, from: data)
                self.clanci = podaci.articles
                self.vrijeme = time as Date
                print(self.clanci)
//                DispatchQueue.main.async() {
//                    VijestiController.refresher.endRefreshing()
//                    VijestiController.indikator.stopAnimating()
//                    self.tableView.reloadData()
//                }
            } catch {
//                Greska.alert(title:"Greška", message: "Ups, došlo je do pogreške s podacima.", viewController: VijestiController)
                self.getData()
            }
            }.resume()
    }
}
