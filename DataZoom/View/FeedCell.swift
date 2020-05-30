//
//  FeedCell.swift
//  DataZoomDemo
//
//  Created by Momcilo Stankovic on 16/05/2020.
//  Copyright © 2020 Momcilo Stankovic. All rights reserved.
//

import UIKit

class FeedCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .rgb(red: 50, green: 50, blue: 50)
        var dzId = ""
        var dzUrl = ""
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    var videos: [Video]?
    let cellId = "cellId"
    var dzId = dataZoom.id
    var dzUrl = dataZoom.url
    func fetchVideos() {
        ApiService.sharedInstance.fetchMP4 { (videos: [Video]) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        fetchVideos()
        
        backgroundColor = .brown
        
        addSubview(collectionView)
        addConstraintWithFormat(format: "H:|[v0]|", view: collectionView)
        addConstraintWithFormat(format: "V:|[v0]|", view: collectionView)

        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! VideoCell
        
        cell.video = videos?[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (frame.width - 16 - 16) * 9 / 16
        return CGSize(width: frame.width, height: height + 16 + 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let akamaiPlayer = AkamaiPlayer()
        akamaiPlayer.showVideoPlayer(video: videos![indexPath.item], dzId: dataZoom.id, dzUrl: dataZoom.url)
    }

}
