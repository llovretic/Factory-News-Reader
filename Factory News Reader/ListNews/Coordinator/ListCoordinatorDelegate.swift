//
//  ListCoordinatorDelegate.swift
//  Factory News Reader
//
//  Created by Luka Lovretić on 09/07/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import Foundation

protocol ListCoordinatorDelegate: CoordinatorDelegate {
    func openDetailNews(selectedNews: NewsViewData)
}

