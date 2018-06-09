//
//  VijestTableViewCell.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 08/06/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit


class VijestTableViewCell: UITableViewCell {
    
    var vijestSlika: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var vijestNaslov: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var vijestOpis: UILabel = {
        let label = UILabel()
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
    
    override func layoutSubviews() {
        self.contentView.addSubview(vijestSlika)
        vijestSlika.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        vijestSlika.widthAnchor.constraint(equalToConstant: 80).isActive = true
        vijestSlika.heightAnchor.constraint(equalToConstant: 80).isActive = true
       
        self.contentView.addSubview(vijestNaslov)
        vijestNaslov.leftAnchor.constraint(equalTo: vijestSlika.rightAnchor, constant: 8).isActive = true
        vijestNaslov.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 8).isActive = true
        vijestNaslov.centerYAnchor.constraint(equalTo: vijestSlika.centerYAnchor, constant: -8).isActive = true
        
        self.contentView.addSubview(vijestOpis)
        vijestOpis.leftAnchor.constraint(equalTo: vijestSlika.rightAnchor, constant: 8).isActive = true
        vijestOpis.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 8).isActive = true
        vijestOpis.centerYAnchor.constraint(equalTo: vijestSlika.centerYAnchor, constant: 8).isActive = true
       

    }
    
    
}
