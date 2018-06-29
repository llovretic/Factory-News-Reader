//
//  ViewController.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 08/06/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit


class NewsTableViewController: UITableViewController {
    //MARK: varijable
    let cellID = "CellID"
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    fileprivate let newsPresenter = NewsListPresenter(newsService: APIService())
    fileprivate var newsForDisplay = [NewsViewData]()
    
//    lazy var refresher: UIRefreshControl = {
//        let refreshControl = UIRefreshControl()
//        refreshControl.tintColor = UIColor.red
//        refreshControl.addTarget(self, action: #selector(APIService.getData), for: .valueChanged)
//        return refreshControl
//    }()
    
    var time = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Factory"
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: cellID)
        createActivityIndicator()
        newsPresenter.attachView(self)
        newsPresenter.getData()
        
//        tableView.refreshControl = refresher
    }
    
    override func viewDidAppear(_ animated: Bool) {
        newsPresenter.inspectNews()
    }
    
    //MARK: Funkcije za posatavljanje tableViewa
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsForDisplay.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        cell.newsTitle.text = newsForDisplay[indexPath.row].title
        cell.newsDescription.text = newsForDisplay[indexPath.row].description
        
        if let imageURL = URL(string: newsForDisplay[indexPath.row].urlToImage) {
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
        let data = newsForDisplay[indexPath.row]
        newsDetailPresneter.newsData = [data]
        print(newsDetailPresneter.newsData)
        navigationController?.pushViewController(newsDeatilViewController, animated: true)
        
    }
    
    //MARK: Funkcija za postavljanje indikatora
    func createActivityIndicator() {
        indicator.center = view.center
        indicator.color = UIColor.red
        indicator.startAnimating()
        view.addSubview(indicator)
    }
    
 
    
}
//MARK: extensions

extension NewsTableViewController: NewsView {
    func setEmptyUsers() {
        tableView.isHidden = true
    }
    
    func startLoading() {
        indicator.startAnimating()
    }
    
    func finishLoading() {
        indicator.stopAnimating()
    }
    
    func setNews(_ news: [NewsViewData]) {
        newsForDisplay = news
        self.tableView.reloadData()
    }
    

    
    
}
