//
//  VijestTableViewCell.swift
//  Factory News Reader
//
//  Created by Luka Lovretic on 08/06/2018.
//  Copyright © 2018 Luka Lovretic. All rights reserved.
//

import UIKit

class VijestTableViewCell: UITableViewCell {
    
    var clanci: [Clanak]!
    
    var vijestSlika: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var vijestNaslov: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var vijestOpis: UILabel = {
        let label = UILabel()
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
        vijestSlika.frame = CGRect (x:0, y:0, width: 80, height: 80)
        vijestSlika.contentMode = .scaleAspectFill
//        vijestSlika = Clanak.image
        self.contentView.addSubview(vijestSlika)
        
        vijestNaslov.frame = CGRect(x: vijestSlika.frame.maxX + 8, y: vijestSlika.frame.height / 2 + 2, width: self.contentView.frame.width - 5 - vijestSlika.frame.width - 10 - 10, height: 30)
        
        vijestOpis.text = "\(clanci.description)"
        self.contentView.addSubview(vijestNaslov)
        
        vijestOpis.frame = CGRect(x: vijestSlika.frame.maxX + 8, y: vijestNaslov.frame.maxY, width: self.contentView.frame.width - 5 - vijestSlika.frame.width - 10 - 10, height: 30)
        vijestOpis.text = "\(clanci.description)"
        self.contentView.addSubview(vijestOpis)
        

    }
    
    
}
