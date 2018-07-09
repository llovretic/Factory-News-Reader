//
//  ViewController.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 08/06/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit
import RxSwift


class NewsListViewController: UITableViewController {
    //MARK: varijable
    var refresher: UIRefreshControl!
    let disposeBag = DisposeBag()
    let cellID = "CellID"
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    var newsListViewModel = NewsListViewModel(newsService: APIService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Factory"
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: cellID)
        initializeLoaderObservable()
        newsListViewModel.initializeObservableDataAPI().disposed(by: disposeBag)
        initializeDataObservable()
        initializeRefreshControl()
        initializeErrorObservable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        newsListViewModel.checkingHowOldIsData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isMovingToParentViewController {
            
        }
        
    }
    
    //MARK: Funkcije za posatavljanje tableViewa
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsListViewModel.newsData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        let dataForDisplay = newsListViewModel.newsData[indexPath.row]
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
        let newsDeatilViewController = NewsDetailViewController()
        let newsDetailViewModel = NewsDetailViewModel()
        let data = newsListViewModel.newsData[indexPath.row]
        newsDetailViewModel.newsDetailData = data
        newsDeatilViewController.newsDetailViewModel = newsDetailViewModel
        navigationController?.pushViewController(newsDeatilViewController, animated: true)
    }
    
    //MARK: Funkcija za postavljanje indikatora
    func initializeLoaderObservable() {
        let loadingObserver = newsListViewModel.loaderControll
        loadingObserver
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                if (event) {
                    self.indicator.center = self.view.center
                    self.indicator.color = UIColor.red
                    self.view.addSubview(self.indicator)
                    self.view.bringSubview(toFront: self.indicator)
                    self.indicator.startAnimating()
                }
                else {
                    self.indicator.stopAnimating()
                    self.indicator.removeFromSuperview()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func initializeDataObservable(){
        let dataObserver = newsListViewModel.dataIsReady
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
        let errorObserver = newsListViewModel.errorOccure
            errorObserver
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (event) in
                if event {
                   ErrorController.alert(viewToPresent: self, title: "Greška!", message: "Ups, došlo je do pogreške")
                    self.refresher.endRefreshing()
                    self.indicator.stopAnimating()
                    self.indicator.hidesWhenStopped = true
                    self.refresher.isHidden = true
                }
            })
        .disposed(by: disposeBag)
    }
    
    @objc func refreshAction(){
        newsListViewModel.downloadTrigger.onNext(true)
    }

    func initializeRefreshControl() {
        refresher = UIRefreshControl()
        tableView.addSubview(refresher)
        refresher.tintColor = UIColor.red
        refresher.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
    }
}
