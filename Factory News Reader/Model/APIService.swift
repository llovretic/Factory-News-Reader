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
//    func getData(completed:@escaping ([Clanak]?) -> (Void)) {
//        guard let downloadURL = url else { return }
//        URLSession.shared.dataTask(with: downloadURL) { data, urlResponse, error in
//            guard let data = data, error == nil, urlResponse != nil else {
//                Greska.alert(title:"Greška", message: "Ups, došlo je do pogreške prilikom prikupljanja podataka.")
//                completed(nil)
//                return
//            }
//            do
//            {
//                let time = NSDate()
//                let decoder = JSONDecoder()
//                let podaci = try decoder.decode(Stranica.self, from: data)
//                self.clanci = podaci.articles
//                self.vrijeme = time as Date
//                DispatchQueue.main.async() {
//                    completed(self.clanci)
////                    VijestiController.refresher.endRefreshing()
////                    VijestiController.indikator.stopAnimating()
////                    self.tableView.reloadData()
//                }
//            } catch {
//                Greska.alert(title:"Greška", message: "Ups, došlo je do pogreške s podacima.")
//                completed(nil)
//            }
//            }.resume()
//    }
    
    func getData(completed:@escaping ([Article]?) -> (Void)){
        Alamofire.request(url).responseJSON{ response in
            switch response.result
            {
            case .success:
                // Parsing data
                let json = response.result.value as! [String: Any]
                let jsonArticles = json["articles"] as! NSArray
                for articles in jsonArticles
                {
                    // Saving important values
                    var values = articles as! [String: String]
                    let author = (values["author"] as String?) ?? ""
                    let title = (values["title"] as String?) ?? ""
                    let description = (values["description"] as String?) ?? ""
                    let url = (values["url"] as String?) ?? ""
                    let urlToImage = (values["urlToImage"] as String?) ?? ""
                    let publishedAt = (values["publishedAt"] as String?) ?? ""
                    
                    let data = Article(author: author, title: title, description: description, url: url,urlToImage: urlToImage, publishedAt: publishedAt )
                    self.news += [data]
                    
                }
                
            case .failure(let error):
                ErrorController.alert(title: "Greška!", message: "Ups, došlo je do pogreške!")
                print(error)
            }
            completed(self.news)
        }
    }
}
