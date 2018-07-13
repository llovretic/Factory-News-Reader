//
//  NewsModel.swift
//  Factory News Reader
//
//  Created by Luka Lovretić on 05/07/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class NewsData: Object {
    @objc dynamic var title: String? = nil
    @objc dynamic var descriptionNews: String? = nil
    @objc dynamic var urlToImage: String? = nil
    @objc dynamic var isNewsFavourite: Bool = false
}
