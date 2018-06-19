//
//  ViewController.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 08/06/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit


class VijestiController: UITableViewController {
    //MARK: varijable
    let cellID = "CellID"
    let indikator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    fileprivate let vijestiPresenter = VijestiPresenter(vijestiService: APIService())
    fileprivate var vijestiZaPokazat = [VijestiViewData]()
    
//    lazy var refresher: UIRefreshControl = {
//        let refreshControl = UIRefreshControl()
//        refreshControl.tintColor = UIColor.red
//        refreshControl.addTarget(self, action: #selector(APIService.getData), for: .valueChanged)
//        return refreshControl
//    }()
    
    var vrijeme = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Factory"
        tableView.register(VijestTableViewCell.self, forCellReuseIdentifier: cellID)
        createActivityIndicator()
        vijestiPresenter.attachView(self)
        vijestiPresenter.getData()
        
//        tableView.refreshControl = refresher
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let date = NSDate()
        let usporedbaTime = vrijeme.addingTimeInterval((5*60))
        if usporedbaTime > date as Date {
            return
        } else {
//            getData()
        }
        
    }
    
    //MARK: Funkcije za posatavljanje tableViewa
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vijestiZaPokazat.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? VijestTableViewCell else {
            return UITableViewCell()
        }
        cell.vijestNaslov.text = vijestiZaPokazat[indexPath.row].title
        cell.vijestOpis.text = vijestiZaPokazat[indexPath.row].description
        
        if let imageURL = URL(string: vijestiZaPokazat[indexPath.row].urlToImage) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.vijestSlika.image = image
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
        let detaljniViewController = DetaljniPrikazViewController  ()
        let podaci = vijestiZaPokazat[indexPath.row]
        detaljniViewController.podaci = podaci
        navigationController?.pushViewController(detaljniViewController, animated: true)
        
    }
    
    //MARK: Funkcija za postavljanje indikatora
    func createActivityIndicator() {
        indikator.center = view.center
        indikator.color = UIColor.red
        indikator.startAnimating()
        view.addSubview(indikator)
    }
    
 
    
}
//MARK: extensions

extension VijestiController: VijestiView {
    func startLoading() {
        indikator.startAnimating()
    }
    
    func finishLoading() {
        indikator.stopAnimating()
    }
    
    func setVijesti(_ vijesti: [VijestiViewData]) {
        vijestiZaPokazat = vijesti
        self.tableView.reloadData()
    }
    
    
    
    
    
    
    
    
    
}
