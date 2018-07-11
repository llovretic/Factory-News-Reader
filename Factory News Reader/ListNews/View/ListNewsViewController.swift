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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Factory"
        tableView.register(ListNewsViewCell.self, forCellReuseIdentifier: cellIdentifier)
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
        return listNewsViewModel.newsData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ListNewsViewCell else {
            return UITableViewCell()
        }
        let dataForDisplay = listNewsViewModel.newsData[indexPath.row]
        cell.newsTitle.text = dataForDisplay.title
        cell.newsDescription.text = dataForDisplay.description
        if let imageURL = URL(string: dataForDisplay.urlToImage) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.newsImage.image = image
                    }
                }
            }
        }
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
    
    @objc func refreshAction(){
        listNewsViewModel.downloadTrigger.onNext(true)
    }

    func initializeRefreshControl() {
        refresher = UIRefreshControl()
        tableView.addSubview(refresher)
        refresher.tintColor = UIColor.red
        refresher.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
    }
}

