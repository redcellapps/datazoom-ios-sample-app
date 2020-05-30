//
//  ViewController.swift
//  DataZoomDemo
//
//  Created by Momcilo Stankovic on 13/05/2020.
//  Copyright © 2020 Momcilo Stankovic. All rights reserved.
//

import UIKit
import AmpCore
import AmpIMA
import DZAkamaiCollector

struct dataZoom {
    static var id: String = ""
    static var url: String = ""
}

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    let cellId = "cellId"
    let m3u8CellId = "m3u8CellId"
    let mpdCellId = "mpdCellId"
    let liveCellId = "liveCellId"
    var dzUrl = String()
    var dzId = String()
    
    let titles = ["VOD/MP4", "VOD m3u8 HLS", "VOD MPD Dash", "Live m3u8 HLS" ]

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "DataZoomDemo"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        dataZoom.id = dzId
        dataZoom.url = dzUrl
        setupMenuBar()
        setupNavBarbuttons()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        collectionView.backgroundColor = .rgb(red: 50, green: 50, blue: 50)
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(M3U8Cell.self, forCellWithReuseIdentifier: m3u8CellId)
        collectionView.register(MPDCell.self, forCellWithReuseIdentifier: mpdCellId)
        collectionView.register(LiveCell.self, forCellWithReuseIdentifier: liveCellId)
        
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        collectionView.isPagingEnabled = true
    }
    
    func setupNavBarbuttons() {
        let searchImage = UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handSearch))
        
        let moreImage = UIImage(named: "nav_more_icon")?.withRenderingMode(.alwaysOriginal)
        let moreButton = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(handleMore))
        
        navigationItem.rightBarButtonItems = [moreButton, searchBarButtonItem]
        
    }
    
    lazy var settingsLauncher: SettingLauncher = {
        let launcher = SettingLauncher()
        launcher.homeController = self
        return launcher
    }()
    
    @objc func handleMore() {
        settingsLauncher.showSettings()
    }
    
    func showControllerForSetting(setting: Setting) {
        let dummySettingViewController = UIViewController()
        dummySettingViewController.view.backgroundColor = .rgb(red: 50, green: 50, blue: 50)
        dummySettingViewController.navigationItem.title = setting.name.rawValue
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.pushViewController(dummySettingViewController, animated: true)
    }
    
    @objc func handSearch() {

    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

        setTitleForIndex(index: menuIndex)
    }
    
    private func setTitleForIndex(index: Int) {
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "  \(titles[index])"
        }
    }
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()

    private func setupMenuBar() {
        navigationController?.hidesBarsOnSwipe = false
        
        let redView = UIView()
        redView.backgroundColor = UIColor.rgb(red: 50, green: 50, blue: 50)
        view.addSubview(redView)
        view.addConstraintWithFormat(format: "H:|[v0]|", view: redView)
        view.addConstraintWithFormat(format: "V:[v0(50)]", view: redView)
        
        view.addSubview(menuBar)
        view.addConstraintWithFormat(format: "H:|[v0]|", view: menuBar)
        view.addConstraintWithFormat(format: "V:[v0(50)]", view: menuBar)
        
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBArLeftAncorConstraint?.constant = scrollView.contentOffset.x / 4
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = Int(targetContentOffset.pointee.x / view.frame.width)
        
        let indexPath = IndexPath(item: index, section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)

        setTitleForIndex(index: indexPath.item)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let identifier: String
        switch indexPath.item {
        case 1:
            identifier = m3u8CellId
        case 2:
            identifier = mpdCellId
        case 3:
            identifier = liveCellId
        default:
            identifier = cellId
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    }    
}
