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
    var newsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var newsTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var newsDescription: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: layout postavke
    override func layoutSubviews() {
        self.contentView.addSubview(newsImage)
        newsImage.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        newsImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        newsImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.contentView.addSubview(newsTitle)
        newsTitle.leftAnchor.constraint(equalTo: newsImage.rightAnchor, constant: 8).isActive = true
        newsTitle.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 8).isActive = true
        newsTitle.centerYAnchor.constraint(equalTo: newsImage.centerYAnchor, constant: -8).isActive = true
        
        self.contentView.addSubview(newsDescription)
        newsDescription.leftAnchor.constraint(equalTo: newsImage.rightAnchor, constant: 8).isActive = true
        newsDescription.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 8).isActive = true
        newsDescription.centerYAnchor.constraint(equalTo: newsImage.centerYAnchor, constant: 8).isActive = true
    }
}
