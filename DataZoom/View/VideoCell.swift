//
//  VideoCell.swift
//  DataZoomDemo
//
//  Created by Momcilo Stankovic on 14/05/2020.
//  Copyright © 2020 Momcilo Stankovic. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VideoCell: BaseCell {
    
    var video: Video? {
        didSet {
            titleLabel.text = video?.title
            
            setupThumbnailImage()
            
            setupProfileImage()
            //if let channelName = video?.channel?.name, let numberOfVievs = video?.numberOfViews {
            let channelName = "DataZoomDemo by RedCellApps"
            let numberOfVievs = 1
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                let subtitleText = "\(channelName) - \(numberFormatter.string(from: NSNumber(value: numberOfVievs))!) — Last Week"
                subtitleTextView.text = subtitleText
            
            
            //measure title text
                let title = "DataZoomDemo"
                let size = CGSize(width: frame.width - 16 - 44 - 8 - 16, height: 1000)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimatedRect = NSString(string: title).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)

                if estimatedRect.size.height > 20 {
                    titleLabelHeightConstraint?.constant = 44
                } else {
                    titleLabelHeightConstraint?.constant = 20
                }

            
            
        }
    }
    
    func setupProfileImage() {
        if let profileImageUrl = video?.channel?.profileImageName {
            userProfileImageView.loadImageUsingUrl(urlString: profileImageUrl)
        }
    }
    
    func setupThumbnailImage() {
        if let thumbnailImageUrl = video?.thumbnailImageName {
            thumbnailImageView.loadImageUsingUrl(urlString: thumbnailImageUrl)
        }
    }
    
    let thumbnailImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = UIImage(named: "DZLOGO")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userProfileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = UIImage(named: "RCALogo")
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 50, green: 50, blue: 50)
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Default Title"
        label.textColor = .lightText
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subtitleTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .rgb(red: 50, green: 50, blue: 50)
        textView.text = "Default Subtitle"
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -0, bottom: 0, right: 0)
        textView.textColor = .lightText
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var titleLabelHeightConstraint: NSLayoutConstraint?
    
    override func setupViews() {
        addSubview(thumbnailImageView)
        addSubview(separatorView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
        
        addConstraintWithFormat(format: "H:|-16-[v0]-16-|", view: thumbnailImageView)
        
        addConstraintWithFormat(format: "H:|-16-[v0(44)]", view: userProfileImageView)
        
        //vertical constraints
        addConstraintWithFormat(format: "V:|-16-[v0]-8-[v1(44)]-36-[v2(1)]|", view: thumbnailImageView, userProfileImageView, separatorView)
        
        addConstraintWithFormat(format: "H:|[v0]|", view: separatorView)
        
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: thumbnailImageView, attribute: .bottom, multiplier: 1, constant: 8))
        //left constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        //right constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        
        //height constraint
        titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 44)
        addConstraint(titleLabelHeightConstraint!)
        
        //top constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 4))
        //left constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        //right constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        //height constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30))
        
    }
    

}

