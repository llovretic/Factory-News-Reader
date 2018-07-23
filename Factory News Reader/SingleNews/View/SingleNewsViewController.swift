//
//  DetaljniPrikazViewController.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 09/06/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit

class SingleNewsViewController: UIViewController {
    //MARK: varijable
    weak var newsViewCellDelegate: NewsViewCellDelegate?
    var singlelNewsViewModel: SingleNewsViewModel!
    
    var newsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var newsTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    
    var newsDescription: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.font = .italicSystemFont(ofSize: 18)
        return textView
    }()
    
    var favouriteButton: UIButton = {
        let barButton = UIButton()
        barButton.setBackgroundImage(#imageLiteral(resourceName: "favouriteUnselected"), for: .normal)
        barButton.setBackgroundImage(#imageLiteral(resourceName: "favouriteSelected"), for: .selected)
        return barButton
    }()
    
    var scrollContentView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        view.backgroundColor = UIColor.white
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if self.isMovingFromParentViewController {
            singlelNewsViewModel.listNewsCoordinatorDelegate?.viewControllerHasFinished()
        }
    }
    
    deinit {
        print("Single News deinit")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: layout postavke
    func addSubViews() {
        view.addSubview(scrollContentView)
        scrollContentView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        scrollContentView.addSubview(newsImage)
        if let imageURL = URL(string: singlelNewsViewModel.newsDetailData.urlToImage!) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.newsImage.image = image
                    }
                }
            }
        }
        newsImage.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor).isActive = true
        newsImage.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor).isActive = true
        newsImage.topAnchor.constraint(equalTo: scrollContentView.topAnchor).isActive = true
        newsImage.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor).isActive = true
        newsImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        scrollContentView.addSubview(newsTitle)
        newsTitle.text = singlelNewsViewModel.newsDetailData.title
        newsTitle.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 8).isActive = true
        newsTitle.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -8).isActive = true
        newsTitle.topAnchor.constraint(equalTo: newsImage.bottomAnchor, constant: 8).isActive = true
        
        scrollContentView.addSubview(newsDescription)
        newsDescription.text = singlelNewsViewModel.newsDetailData.descriptionNews
        newsDescription.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 8).isActive = true
        newsDescription.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -8).isActive = true
        newsDescription.topAnchor.constraint(equalTo: newsTitle.bottomAnchor, constant: 8).isActive = true
        newsDescription.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor).isActive = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favouriteButton)
        favouriteButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        favouriteButton.isSelected = singlelNewsViewModel.newsDetailData.isNewsFavourite
        
        navigationItem.title = singlelNewsViewModel.newsDetailData.title
    }
    
    @objc func favouriteButtonTapped() {
        favouriteButton.isSelected = singlelNewsViewModel.addOrRemoveFavouritesData()
    }
    
}



