//
//  MPDCell.swift
//  DataZoomDemo
//
//  Created by Momcilo Stankovic on 16/05/2020.
//  Copyright © 2020 Momcilo Stankovic. All rights reserved.
//

import UIKit

class MPDCell: FeedCell {
    
    override func fetchVideos() {
        ApiService.sharedInstance.fetchMPD { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
    
}
