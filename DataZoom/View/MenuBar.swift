//
//  MenuBar.swift
//  DataZoomDemo
//
//  Created by Momcilo Stankovic on 14/05/2020.
//  Copyright © 2020 Momcilo Stankovic. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .rgb(red: 50, green: 50, blue: 50)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "cellId"
    let imageNames = ["subscriptions", "subscriptions", "subscriptions", "subscriptions"]
    
    var homeController: HomeController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        addConstraintWithFormat(format: "H:|[v0]|", view: collectionView)
        addConstraintWithFormat(format: "V:|[v0]|", view: collectionView)
        
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .bottom)
        
        setupHorizontalBar()
    }
    
    var horizontalBArLeftAncorConstraint: NSLayoutConstraint?
    
    func setupHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        addSubview(horizontalBarView)
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        
        horizontalBArLeftAncorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBArLeftAncorConstraint?.isActive = true
        
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/4).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let x = CGFloat(indexPath.item) * frame.width / 4
//        horizontalBArLeftAncorConstraint?.constant = x
//        
//        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            self.layoutIfNeeded()
//        }, completion: nil)
        
        homeController?.scrollToMenuIndex(menuIndex: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        
        cell.imageView.image = UIImage(named: imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        cell.tintColor = UIColor.rgb(red: 128, green: 128, blue: 128)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4, height: frame.height )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class MenuCell: BaseCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal)
        iv.tintColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        return iv
    }()

    override var isHighlighted: Bool {
        didSet {
            imageView.tintColor = isHighlighted ? UIColor.white : UIColor.rgb(red: 80, green: 80, blue: 80)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? UIColor.white : UIColor.rgb(red: 80, green: 80, blue: 80)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(imageView)
        addConstraintWithFormat(format: "H:[v0(28)]", view: imageView)
        addConstraintWithFormat(format: "V:[v0(28)]", view: imageView)
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
    }
}
