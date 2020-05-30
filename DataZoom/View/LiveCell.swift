//
//  LiveCell.swift
//  DataZoom
//
//  Created by Momcilo Stankovic on 19/05/2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit

class LiveCell: FeedCell {
    
    override func fetchVideos() {
        ApiService.sharedInstance.fetchLive { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
    
}
