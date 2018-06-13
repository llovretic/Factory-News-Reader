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
    
//    let loader = CAShapeLayer()
//    let shapeLayer = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Factory"
        tableView.register(VijestTableViewCell.self, forCellReuseIdentifier: cellID)
        createActivityIndicator()
//        setUpLoader()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detaljniViewController = DetaljniPrikazViewController  ()
        let podaci = clanci[indexPath.row]
        detaljniViewController.podaci = podaci
        navigationController?.pushViewController(detaljniViewController, animated: true)
        
    }
    
    func getData() {
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
                DispatchQueue.main.async {
                    self.indikator.stopAnimating()
//                    self.shapeLayer.strokeEnd = 
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
    
//    func setUpLoader(){
//        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
//        loader.path = circularPath.cgPath
//        loader.strokeColor = UIColor.lightGray.cgColor
//        loader.lineWidth = 10
//        loader.fillColor = UIColor.clear.cgColor
//        loader.lineCap = kCALineCapRound
//        loader.position = view.center
//        view.layer.addSublayer(loader)
//
//        shapeLayer.path = circularPath.cgPath
//        shapeLayer.strokeColor = UIColor.white.cgColor
//        shapeLayer.lineWidth = 10
//        shapeLayer.fillColor = UIColor.clear.cgColor
//        shapeLayer.lineCap = kCALineCapRound
//        shapeLayer.position = view.center
//        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
//        shapeLayer.strokeEnd = 0
//        shapeLayer.position = view.center
//        view.layer.addSublayer(shapeLayer)
//    }
}
   



