//
//  APIService.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 19/06/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class APIService {
    
    let url = "https://newsapi.org/v1/articles?apiKey=6946d0c07a1c4555a4186bfcade76398&sortBy=top&source=bbc-news"
        
    //MARK: Funkcija za skidanje podataka
    func getDataFromAPI() -> Observable<[Article]> {
        return Observable<[Article]>.create { observer in
            let request = Alamofire.request(self.url)
            request.validate()
                .responseJSON { response in
                    
                    switch response.result
                    {
                    case .success:
                        let decoder = JSONDecoder()
                        let jsonData = response.data
                        // Parsing data
                        do {
                            let data = try decoder.decode(WebPage.self, from: jsonData!)
                            observer.onNext(data.articles)
                            observer.onCompleted()
                        }
                            
                        catch {
                            
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
