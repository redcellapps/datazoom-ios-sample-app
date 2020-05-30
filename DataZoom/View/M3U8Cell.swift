//
//  M3U8Cell.swift
//  DataZoomDemo
//
//  Created by Momcilo Stankovic on 16/05/2020.
//  Copyright © 2020 Momcilo Stankovic. All rights reserved.
//

import UIKit

class M3U8Cell: FeedCell {
    
    override func fetchVideos() {
        ApiService.sharedInstance.fetchM3U8 { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
    
}
