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
    let disposeBag = DisposeBag()
    let cellID = "CellID"
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    fileprivate let newsViewModel = NewsListViewModel(newsService: APIService())

    
//    lazy var refresher: UIRefreshControl = {
//        let refreshControl = UIRefreshControl()
//        refreshControl.tintColor = UIColor.red
//        refreshControl.addTarget(self, action: #selector(newsViewModel.getData), for: .valueChanged)
//        return refreshControl
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Factory"
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: cellID)
        createActivityIndicator()
        newsViewModel.getDataFromTheService()
        isDataReady()
//        newsViewModel.attachView(self)
//        tableView.refreshControl = refresher
    }
    
    override func viewDidAppear(_ animated: Bool) {
        newsViewModel.inspectNews()
    }
    
    //MARK: Funkcije za posatavljanje tableViewa
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsViewModel.newsData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        let dataForDisplay = newsViewModel.newsData[indexPath.row]
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
        let newsDetailPresneter = NewsDetailPresenter()
        let data = newsViewModel.newsData[indexPath.row]
        newsDetailPresneter.newsDetailData = data
        newsDeatilViewController.newsPresenter = newsDetailPresneter
        navigationController?.pushViewController(newsDeatilViewController, animated: true)
        
    }
    
    //MARK: Funkcija za postavljanje indikatora
    func createActivityIndicator() {
        let loadingObserver = newsViewModel.loaderControll
        loadingObserver.asObservable()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                
                if (event) {
                    self.indicator.center = self.view.center
                    self.indicator.color = UIColor.red
                    self.view.addSubview(self.indicator)
                    self.indicator.startAnimating()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func isDataReady(){
        let observer = newsViewModel.dataIsReady
        observer
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] event in
                if event {
                    self.tableView.reloadData()
                    self.indicator.stopAnimating()
                } else {
                    self.indicator.startAnimating()
                }
            })
            .disposed(by: disposeBag)
        }
    }

//MARK: extensions
//extension NewsTableViewController: NewsView {
//    func refreshNews() {
//        tableView.reloadData()
//    }
//    
//    func setEmptyUsers() {
//        tableView.isHidden = true
//    }
//    
//    func startLoading() {
//        indicator.startAnimating()
//    }
//    
//    func finishLoading() {
//        indicator.stopAnimating()
//    }
//}

