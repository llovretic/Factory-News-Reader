//
//  ErrorModel.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 06/07/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import Foundation

struct DataAndErrorWrapper<T> {
    var data: [T]
    var error: String?
}
