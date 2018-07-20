//
//  FavouriteNewsViewController.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 11/07/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit

class FavouriteNewsViewController: UITableViewController {
    //MARK: Varijable
    let cellIndetifier = "CellID"
    var favouriteNewsViewModel: FavouriteNewsViewModel!
    weak var newsViewCellDelegate: NewsViewCellDelegate?
    
    override func viewDidLoad() {
        tableView.register(NewsViewCell.self, forCellReuseIdentifier: cellIndetifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        favouriteNewsViewModel.getFavouriteNewsData()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favouriteNewsViewModel.favouriteNewsData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIndetifier) as? NewsViewCell else { return UITableViewCell ()  }
        
        let newsToDisplay = favouriteNewsViewModel.favouriteNewsData[indexPath.row]
        
        cell.newsViewCellDelegate = self
        
        cell.newsTitleLabel.text = newsToDisplay.title
        
        if let imageURL = URL(string: newsToDisplay.urlToImage!) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.newsImageView.image = image
                    }
                }
            }
        }
        
        cell.favouritesButton.isSelected = newsToDisplay.isNewsFavourite
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row was selected")
        favouriteNewsViewModel.newsSelected(selectedNews: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension FavouriteNewsViewController: NewsViewCellDelegate {
    func favouriteButtonTapped(sender: NewsViewCell) {
        guard let buttonTappedAtIndexPath = tableView.indexPath(for: sender) else {return}
        favouriteNewsViewModel.favouriteButtonPressed(selectedFavouriteNews: buttonTappedAtIndexPath.row)
        tableView.reloadData()
    }
}
