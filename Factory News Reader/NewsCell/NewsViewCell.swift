//
//  VijestTableViewCell.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 08/06/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit


class NewsViewCell: UITableViewCell {
    //MARK: varijable
    weak var newsViewCellDelegate: NewsViewCellDelegate?

    
    var newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var newsTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var favouritesButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "favouritesList"), for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "favouriteSelected"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(newsImageView)
        self.contentView.addSubview(newsTitleLabel)
        self.contentView.addSubview(favouritesButton)
        
        newsImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        newsImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        newsImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        newsTitleLabel.leftAnchor.constraint(equalTo: newsImageView.rightAnchor, constant: 8).isActive = true
        newsTitleLabel.rightAnchor.constraint(equalTo: favouritesButton.leftAnchor, constant: -8).isActive = true
        newsTitleLabel.centerYAnchor.constraint(equalTo: newsImageView.centerYAnchor).isActive = true
        
        favouritesButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -8).isActive = true
        favouritesButton.centerYAnchor.constraint(equalTo: newsImageView.centerYAnchor).isActive = true
        favouritesButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        favouritesButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        favouritesButton.addTarget(self, action: #selector(favouriteButtonTapped(sender:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func favouriteButtonTapped(sender: UIButton){
        newsViewCellDelegate?.favouriteButtonTapped(sender: self)
    }
}

