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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Factory"
        tableView.register(VijestTableViewCell.self, forCellReuseIdentifier: cellID)
       
        getData()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clanci.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? VijestTableViewCell else {
            return UITableViewCell()
        }
//        cell.vijestSlika.image = clanci[indexPath.row].urlToImage
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
    
    func getData() {
        guard let downloadURL = url else { return }
        URLSession.shared.dataTask(with: downloadURL) { data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else {
                print("something is wrong")
                return
            }
            print("downloaded")
            do
            {
                let decoder = JSONDecoder()
                let podaci = try decoder.decode(Stranica.self, from: data)
                self.clanci = podaci.articles
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    print(self.clanci)
                }
            } catch {
                print("something wrong after downloaded")
            }
            }.resume()
    }

}

