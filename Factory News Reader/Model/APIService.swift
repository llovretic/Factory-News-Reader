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
import RxCocoa

class APIService {
    let url = "https://newsapi.org/v1/articles?apiKey=6946d0c07a1c4555a4186bfcade76398&sortBy=top&source=bbc-news"
//    let url = "https://newsapi.org/v1/articles?apiKey=91f05f55e0e441699553b373b30eea61&sortBy=top&source=bbc-new"
    
    //MARK: Funkcija za skidanje podataka
    func observableFetchData() -> Observable<[Article]> {
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
                            let data = try decoder.decode(WebPageJSON.self, from: jsonData!)
                            observer.onNext(data.articles)
                            observer.onCompleted()
                        }
                            
                        catch let error{
                            observer.onError(error)
                        }
                        
                    case .failure(let error):
                        observer.onError(error)
                    }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
