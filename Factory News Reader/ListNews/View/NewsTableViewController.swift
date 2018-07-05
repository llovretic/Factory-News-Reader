//
//  ViewController.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 08/06/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit
import RxSwift


class NewsTableViewController: UITableViewController {
    //MARK: varijable
    var refresher: UIRefreshControl!
    let disposeBag = DisposeBag()
    let cellID = "CellID"
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    fileprivate let newsListViewModel = NewsListViewModel(newsService: APIService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Factory"
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: cellID)
        initialzeLoaderObservable()
        newsListViewModel.initialzeObservableDataAPI().disposed(by: disposeBag)
        initialzeDataObservable()
        intializeRefreshControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        newsListViewModel.checkingHowOldIsData()
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
    func initialzeLoaderObservable() {
        let loadingObserver = newsListViewModel.loaderControll
        loadingObserver
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                if (event) {
                    self.indicator.center = self.view.center
                    self.indicator.color = UIColor.red
                    self.view.addSubview(self.indicator)
                    self.indicator.startAnimating()
                }
                else {
                    self.indicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func initialzeDataObservable(){
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
    @objc func refreshAction(){
        newsListViewModel.downloadTrigger.onNext(true)
    }

    func intializeRefreshControl() {
        refresher = UIRefreshControl()
        tableView.addSubview(refresher)
        refresher.tintColor = UIColor.red
        refresher.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
    }
}
