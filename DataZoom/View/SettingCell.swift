//
//  SettingCell.swift
//  DataZoomDemo
//
//  Created by Momcilo Stankovic on 15/05/2020.
//  Copyright © 2020 Momcilo Stankovic. All rights reserved.
//

import UIKit

class SettingCell: BaseCell {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .darkGray : .white
            
            nameLabel.textColor = isHighlighted ? .white : .black
            
            iconImageView.tintColor = isHighlighted ? .white : .darkGray
        }
    }
    
    var setting: Setting? {
        didSet {
            nameLabel.text = setting?.name.rawValue
            
            if let imageName = setting?.imageName.rawValue {
                iconImageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
                iconImageView.tintColor = .darkGray
            }
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Setting"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "settings")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(nameLabel)
        addSubview(iconImageView)
        
        addConstraintWithFormat(format: "H:|-8-[v0(30)]-8-[v1]|", view: iconImageView, nameLabel)

        addConstraintWithFormat(format: "V:|[v0]|", view: nameLabel)

        addConstraintWithFormat(format: "V:[v0(30)]", view: iconImageView)
        
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
