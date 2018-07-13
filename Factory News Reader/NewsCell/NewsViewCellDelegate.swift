//
//  NewsViewCellDelegate.swift
//  Factory News Reader
//
//  Created by Luka Lovretić on 13/07/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import Foundation

protocol NewsViewCellDelegate: class {
    func favouriteButtonTapped(sender: NewsViewCell)
}
