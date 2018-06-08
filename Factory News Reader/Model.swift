//
//  Model.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 08/06/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit

struct Stranica: Decodable {
    
    let status: String
    let source: String
    let sortBy: String
    let articles: [Clanak]
    
}

struct Clanak: Decodable{
    
    let author: String
    let title: String
    let description: String
    let url: String
    let urlToImage: String
    let publishedAt: String
}
