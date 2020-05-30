//
//  Model.swift
//  DataZoomDemo
//
//  Created by Momcilo Stankovic on 14/05/2020.
//  Copyright © 2020 Momcilo Stankovic. All rights reserved.
//

import UIKit

struct Video: Decodable {
    
    var thumbnailImageName: String?
    var title: String?
    var numberOfViews: Int?
    var uploadDate: Date?
    var videoURL: String?
    var isAdEnabled: Bool?
    var channel: Channel?
    
}

struct Channel: Decodable {
    var name: String?
    var profileImageName: String?
}
