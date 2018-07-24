//
//  FavouriteNewsViewController.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 11/07/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit
import RxSwift

class FavouriteNewsViewController: UITableViewController {
    //MARK: Varijable
    let cellIndetifier = "CellID"
    var favouriteNewsViewModel: FavouriteNewsViewModel!
    let disposeBag = DisposeBag()
    weak var newsViewCellDelegate: NewsViewCellDelegate?
    
    override func viewDidLoad() {
        tableView.register(NewsViewCell.self, forCellReuseIdentifier: cellIndetifier)
        favouriteNewsViewModel.getFavouriteNewsData().disposed(by: disposeBag)
        initializeDataObservable()
        initializeErrorObservable()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        triggerFavouritesData()
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
        favouriteNewsViewModel.newsSelected(selectedNews: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func initializeDataObservable(){
        let dataObserver = favouriteNewsViewModel.dataIsReady
        dataObserver
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                if event {
                    self.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func triggerFavouritesData(){
        favouriteNewsViewModel.favouriteNewsTrigger.onNext(true)
    }
    
    func initializeErrorObservable(){
        let errorObserver = favouriteNewsViewModel.errorOccured
            errorObserver
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (event) in
                if event {
                    ErrorController.alert(viewToPresent: self, title: "Greška!", message: "Ups, došlo je do pogreške")
                }
            })
            .disposed(by: disposeBag)
    }
}

extension FavouriteNewsViewController: NewsViewCellDelegate {
    func favouriteButtonTapped(sender: NewsViewCell) {
        guard let buttonTappedAtIndexPath = tableView.indexPath(for: sender) else {return}
        favouriteNewsViewModel.removeDataFromFavourites(selectedFavouriteNews: buttonTappedAtIndexPath.row)
    }
}
