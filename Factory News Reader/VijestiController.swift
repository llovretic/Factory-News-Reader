//
//  ViewController.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 08/06/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit


class VijestiController: UITableViewController {

    var clanci: [Clanak] = []
    let url = URL(string: "https://newsapi.org/v1/articles?apiKey=6946d0c07a1c4555a4186bfcade76398&sortBy=top&source=bbc-news")
    
    let cellID = "CellID"
    
    let indikator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.red
        refreshControl.addTarget(self, action: #selector(getData), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Factory"
        tableView.register(VijestTableViewCell.self, forCellReuseIdentifier: cellID)
        createActivityIndicator()
        getData()
        tableView.refreshControl = refresher
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clanci.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? VijestTableViewCell else {
            return UITableViewCell()
        }
        cell.vijestNaslov.text = clanci[indexPath.row].title
        cell.vijestOpis.text = clanci[indexPath.row].description
        
        if let imageURL = URL(string: clanci[indexPath.row].urlToImage) {
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
        let podaci = clanci[indexPath.row]
        detaljniViewController.podaci = podaci
        navigationController?.pushViewController(detaljniViewController, animated: true)
        
    }
    
   @objc func getData() {
        guard let downloadURL = url else { return }
        URLSession.shared.dataTask(with: downloadURL) { data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else {
                Greska.alert(title:"Greška", message: "Ups, došlo je do pogreške prilikom prikupljanja podataka.", viewController: self)
                self.getData()
                return
            }
            do
            {
                let decoder = JSONDecoder()
                let podaci = try decoder.decode(Stranica.self, from: data)
                self.clanci = podaci.articles
                DispatchQueue.main.async() {
                    self.refresher.endRefreshing()
                    self.indikator.stopAnimating()
                    self.tableView.reloadData()
                }
            } catch {
                Greska.alert(title:"Greška", message: "Ups, došlo je do pogreške s podacima.", viewController: self)
                self.getData()
            }
            }.resume()
    }
    
    func createActivityIndicator() {
        indikator.center = view.center
        indikator.color = UIColor.red
        indikator.startAnimating()
        view.addSubview(indikator)
}
 
    
}
   



