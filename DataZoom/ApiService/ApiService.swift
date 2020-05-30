//
//  ApiService.swift
//  DataZoomDemo
//
//  Created by Momcilo Stankovic on 16/05/2020.
//  Copyright © 2020 Momcilo Stankovic. All rights reserved.
//

import UIKit

class ApiService: NSObject {
    
    static let sharedInstance = ApiService()
    
    //TODO: ADD SOME API URL THAT WILL CONTAIN EXAMPLE DATA IN FUTURE
    
    func fetchMP4(completion: @escaping ([Video]) -> ()) {let videos = [DataZoomDemo.Video(thumbnailImageName: nil, title: ("DZ EXAMPLE: VOD - MP4"), numberOfViews: Optional(1), uploadDate: nil, videoURL: ("https://storage.googleapis.com/media-session/sintel/trailer.mp4"), isAdEnabled: true, channel: nil), DataZoomDemo.Video(thumbnailImageName: nil, title: ("DZ EXAMPLE VOD: MP4/2"), numberOfViews: Optional(1), uploadDate: nil, videoURL: ("https://demo.datazoomlabs.com/vod/example.mp4"),isAdEnabled: false, channel: nil)]
        DispatchQueue.main.async {
            completion(videos)
        }
    }
    
    func fetchM3U8(completion: @escaping ([Video]) -> ()) {let videos = [DataZoomDemo.Video(thumbnailImageName: nil, title: ("DZ EXAMPLE: VOD - m3u8/HLS"), numberOfViews: Optional(1), uploadDate: nil, videoURL: ("https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8"),isAdEnabled: true, channel: nil),  DataZoomDemo.Video(thumbnailImageName: nil, title: ("DZ EXAMPLE: VOD - m3u8/HLS - Linear"), numberOfViews: Optional(1), uploadDate: nil, videoURL: ("https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8"),isAdEnabled: false, channel: nil)]
        DispatchQueue.main.async {
            completion(videos)
        }
    }
    
    func fetchMPD(completion: @escaping ([Video]) -> ()) {let videos = [DataZoomDemo.Video(thumbnailImageName: nil, title: ("DZ EXAMPLE: VOD / MPD"), numberOfViews: Optional(1), uploadDate: nil,videoURL: ("https://s3.amazonaws.com/_bc_dml/example-content/sintel_dash/sintel_vod.mpd"),isAdEnabled: true, channel: nil), DataZoomDemo.Video(thumbnailImageName: nil, title: ("DZ EXAMPLE: VOD / MPD Dash - 2"), numberOfViews: Optional(1), uploadDate: nil, videoURL: ("https://demo.datazoomlabs.com/vod/DASH/example.mpd"),isAdEnabled: false, channel: nil)]
        DispatchQueue.main.async {
            completion(videos)
        }
    }
    
    func fetchLive(completion: @escaping ([Video]) -> ()) {let videos = [DataZoomDemo.Video(thumbnailImageName: nil, title: ("DZ EXAMPLE: Live Stream"), numberOfViews: Optional(1), uploadDate: nil,videoURL: ("https://dwstream4-lh.akamaihd.net/i/dwstream4_live@131329/master.m3u8"),isAdEnabled: true, channel: nil), DataZoomDemo.Video(thumbnailImageName: nil, title: ("DZ EXAMPLE: Live Stream Playlist"), numberOfViews: Optional(1), uploadDate: nil, videoURL: ("https://wowzaec2demo.streamlock.net/live/bigbuckbunny/playlist.m3u8"),isAdEnabled: false, channel: nil)]
        DispatchQueue.main.async {
            completion(videos)
        }
    }
}
    
    func fetchFeedForUrlString(urlString: String, completion: @escaping ([Video]) -> ()) {
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, responce, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            
            do {
                guard let data = data else { return }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let videos = try decoder.decode([Video].self, from: data)
                DispatchQueue.main.async {
                    completion(videos)
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            
            
            
            }.resume()
}

