//
//  APIService.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 19/06/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
//    let url = URL(string: "https://newsapi.org/v1/articles?apiKey=6946d0c07a1c4555a4186bfcade76398&sortBy=top&source=bbc-news")
   
    let url = "https://newsapi.org/v1/articles?apiKey=6946d0c07a1c4555a4186bfcade76398&sortBy=top&source=bbc-news"
    
    var news: [Article] = []
    
    //MARK: Funkcija za skidanje podataka
        func getData(completed:@escaping ([Article]?) -> (Void)){
        Alamofire.request(url).responseJSON{ response in
            switch response.result
            {
            case .success:
                let decoder = JSONDecoder()
                let jsonData = response.data
                // Parsing data
                do {
                    let data = try decoder.decode(WebPage.self, from: jsonData!)
                    self.news = data.articles
                    DispatchQueue.main.async(){
                        completed(self.news)
                    }
                } catch {
                    completed(nil)
                }
            case .failure(let error):
                ErrorController.alert(title: "Greška!", message: "Ups, došlo je do pogreške!")
                print(error)
            }
            completed(self.news)
        }
    }
}
