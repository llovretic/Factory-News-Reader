//
//  ViewController.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 08/06/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit
import RxSwift


class ListNewsViewController: UITableViewController {
    //MARK: varijable
    var refresher: UIRefreshControl!
    let disposeBag = DisposeBag()
    let cellIdentifier = "CellID"
    let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    var listNewsViewModel: ListNewsViewModel!
    weak var newsViewCellDelegate: NewsViewCellDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(NewsViewCell.self, forCellReuseIdentifier: cellIdentifier)
        initializeLoaderObservable()
        listNewsViewModel.initializeObservableDataAPI().disposed(by: disposeBag)
        initializeDataObservable()
        initializeRefreshControl()
        initializeErrorObservable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        listNewsViewModel.checkingHowOldIsData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isMovingFromParentViewController {
            print("Moving Back to ParentViewController! list")
            listNewsViewModel.listNewsCoordinatorDelegate?.viewControllerHasFinished()
        }
    
    }
    
    deinit {
        print("Single News deinit")
    }
    
    //MARK: Funkcije za posatavljanje tableViewa
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNewsViewModel.listNewsData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? NewsViewCell else {
            return UITableViewCell()
        }
        
        cell.newsViewCellDelegate = self
        
        let dataForDisplay = listNewsViewModel.listNewsData[indexPath.row]
        
        cell.newsTitleLabel.text = dataForDisplay.title
        
        if let imageURL = URL(string: dataForDisplay.urlToImage!) {
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
        
        cell.favouritesButton.isSelected = dataForDisplay.isNewsFavourite
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listNewsViewModel.newsIsSelected(selectedNews: indexPath.row)
    }
    
    //MARK: Funkcija za postavljanje indikatora
    func initializeLoaderObservable() {
        let loadingObserver = listNewsViewModel.loaderControll
        loadingObserver
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                if (event) {
                    self.loadingIndicator.center = self.view.center
                    self.loadingIndicator.color = UIColor.red
                    self.view.addSubview(self.loadingIndicator)
                    self.view.bringSubview(toFront: self.loadingIndicator)
                    self.loadingIndicator.startAnimating()
                }
                else {
                    self.loadingIndicator.stopAnimating()
                    self.loadingIndicator.removeFromSuperview()
                }
            })
            .disposed(by: disposeBag)
    }
    //MARK: funkcija koja prati podatke te ukoliko su spremni refresha tablicu
    func initializeDataObservable(){
        let dataObserver = listNewsViewModel.dataIsReady
        dataObserver
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] event in
                if event {
                    self.refresher.endRefreshing()
                    self.tableView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
    //MARK: funkcija koja kontrolira error alert
    func initializeErrorObservable() {
        let errorObserver = listNewsViewModel.errorOccured
            errorObserver
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (event) in
                if event {
                   ErrorController.alert(viewToPresent: self, title: "Greška!", message: "Ups, došlo je do pogreške")
                    self.refresher.endRefreshing()
                    self.loadingIndicator.stopAnimating()
                    self.loadingIndicator.hidesWhenStopped = true
                    self.refresher.isHidden = true
                }
            })
        .disposed(by: disposeBag)
    }
    //MARK: funkcija za pokretanje downloada u pull to refresh
    @objc func refreshAction(){
        listNewsViewModel.downloadTrigger.onNext(true)
    }
    //MARK: incijalizacija za pull to refresh
    func initializeRefreshControl() {
        refresher = UIRefreshControl()
        tableView.addSubview(refresher)
        refresher.tintColor = UIColor.red
        refresher.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
    }
    
    //MARK: funkcija koja govori koji je favourite button kliknut
    func pressedFavouriteButton(sender: NewsViewCell){
       newsViewCellDelegate?.favouriteButtonTapped(sender: sender)
    }
    
}

extension ListNewsViewController: NewsViewCellDelegate{
    func favouriteButtonTapped(sender: NewsViewCell) {
        guard let buttonTappedAtIndexPath = tableView.indexPath(for: sender) else { return }
        listNewsViewModel.favouriteButtonPressed(selectedNews: buttonTappedAtIndexPath.row)
        tableView.reloadRows(at: [buttonTappedAtIndexPath], with: .none)
//        tableView.reloadData()
    }
}
