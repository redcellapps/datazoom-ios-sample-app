//
//  AkamaiPlayer.swift
//  DataZoomDemo
//
//  Created by Momcilo Stankovic on 18/05/2020.
//  Copyright © 2020 Momcilo Stankovic. All rights reserved.
//


import UIKit
import AmpCore
import AmpIMA
import DZAkamaiCollector
import UIKit
import AVFoundation

var player: AmpPlayer!
var imaAds: AmpIMAManager!

class AkamaiPlayer: NSObject {
    var view = UIView()
    var videoPlayerView = UIView()
    
    var player: AmpPlayer!
    var configId: String = ""
    var connectionURL: String = ""
    var adRequested = false
    
    var sendDataButton: UIButton!
    var closeButton: UIButton!
    
    var dataZoomConfigId = "632b0e15-a91e-4d68-bf24-01a23cefc872"
    var dataZoomUrl = "https://platform.datazoom.io/beacon/v1/"
    
    let imaAdsUrl = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpost&cmsid=496&vid=short_onecue&correlator="
    
    let playerLicense = "AwFpmDCJ/WibjemUizmNuZ8Py1wMQJCYW2obLT8pThp9Kvp+PIRSOYbj8DcYn/PLAPD+XomDoeE/kkYoJO8JImHulUmnmgs2bGqkrI92cK5NrBrk5/3mxFWVNCDCzzv+vDCQh6Pj33vVHOmHUmPpHT3g/uV2ZzZqvG0pj531FIIfsQtGsxBQjrh59lYL+LuNM1R+AL3bmG64mCnaSK1YGV78M7Bom//GlYuD62c3tUuqWQ=="

    func showVideoPlayer(video: Video, dzId: String, dzUrl: String) {
        
 
        if let keyWindow = UIApplication.shared.keyWindow {
            view = UIView(frame: keyWindow.frame)
            view.backgroundColor = UIColor.rgb(red: 50, green: 50, blue: 50)
            keyWindow.addSubview(view)
            view.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: keyWindow.frame.height)
            
            
            
            let height = keyWindow.frame.width * 9 / 16
            let videoPlayerFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
            view.addSubview(videoPlayerView)
            
            let gai = GAI.sharedInstance()
                    gai?.tracker(withTrackingId: "UA-167198240-1")
                    let tracker = gai?.defaultTracker
                    var gaClientId = "";
                    if (tracker != nil) {
                        gaClientId = tracker!.get("&cid")!
                    }
                    print("GAClientId: \(gaClientId)")
            
            let poster = UIImage(named: "DZLOGO")
            player = AmpPlayer(parentView: videoPlayerView)
            player.setLicense(playerLicense)
            player.registerObserver(self)
            
            dataZoomConfigId = dzId
            dataZoomUrl = dzUrl

            print ("INIT AKAMAI PLAYER WITH DZId and DZURL NOW",dataZoomUrl, dataZoomConfigId)
            DZAmpCollector.dzSharedManager.flagForAutomationOnly = false
            DZAmpCollector.dzSharedManager.initAkamaiPlayerWith(configID: dataZoomConfigId, url: dataZoomUrl, playerInstance: player)
            
            DZAmpCollector.dzSharedManager.customMetaData(["googleAnalyticsClientId": gaClientId])
                    
            imaAds = AmpIMAManager(ampPlayer: player, videoView: player.playerView!)
            
            player.title = video.title
            player.logsEnabled = true
            player.play(url: video.videoURL!)
            player.setPoster(poster!)
            adRequested = video.isAdEnabled ?? false
            
            closeButton = UIButton.init(type: .roundedRect)
            closeButton.layer.cornerRadius = 10.0
            closeButton.frame = CGRect(x: 50, y: 230, width: 100, height: 30)
            closeButton.backgroundColor = UIColor.rgb(red: 30, green: 30, blue: 30)
            closeButton.setTitle("Close Video", for: .normal)
            closeButton.setTitleColor(UIColor.white, for: .normal)
            closeButton.addTarget(self, action: #selector(closeButtonTap), for: .touchUpInside)
            view.addSubview(closeButton)
            view.bringSubviewToFront(closeButton)
            
            sendDataButton = UIButton.init(type: .roundedRect)
            sendDataButton.layer.cornerRadius = 10.0
            sendDataButton.frame = CGRect(x: keyWindow.frame.width - 150, y: 230, width: 100, height: 30)
            sendDataButton.backgroundColor = UIColor.rgb(red: 30, green: 30, blue: 30)
            sendDataButton.setTitle("Send Data", for: .normal)
            sendDataButton.setTitleColor(UIColor.white, for: .normal)
            sendDataButton.addTarget(self, action: #selector(sendDataButtonTap), for: .touchUpInside)
            sendDataButton.setTitle("Data Sent", for: .selected)
            view.addSubview(sendDataButton)
            view.bringSubviewToFront(sendDataButton)
            
            let videoNameTitle = UILabel.init(frame: CGRect(x: 10, y:  closeButton.frame.maxY + 30, width: 100, height: 30))
            videoNameTitle.text = "Video Title:"
            videoNameTitle.textColor = .gray
            view.addSubview(videoNameTitle)

            let videoNameLabel = UILabel.init(frame: CGRect(x: videoNameTitle.frame.maxX + 5, y:  videoNameTitle.frame.minY, width: view.frame.width, height: 30))
            videoNameLabel.text = video.title
            videoNameLabel.textColor = .lightGray
            view.addSubview(videoNameLabel)
            
            let videoUrlTitle = UILabel.init(frame: CGRect(x: videoNameTitle.frame.minX, y:  videoNameTitle.frame.maxY + 5, width: 100, height: 30))
            videoUrlTitle.text = "Video URL:"
            videoUrlTitle.textColor = .gray
            view.addSubview(videoUrlTitle)

            let videoUrlLabel = UILabel.init(frame: CGRect(x: videoUrlTitle.frame.maxX + 5, y:  videoUrlTitle.frame.minY, width: view.frame.width - 120, height: 50))
            videoUrlLabel.numberOfLines = 2
            videoUrlLabel.lineBreakMode = .byCharWrapping
            videoUrlLabel.textAlignment = .left
            videoUrlLabel.adjustsFontSizeToFitWidth = true
            videoUrlLabel.text = video.videoURL
            videoUrlLabel.textColor = .lightGray
            view.addSubview(videoUrlLabel)
            
            let adsEnabledTitle = UILabel.init(frame: CGRect(x: videoUrlTitle.frame.minX, y:  videoUrlTitle.frame.maxY + 10, width: 100, height: 30))
            adsEnabledTitle.text = "Ads enabled:"
            adsEnabledTitle.textColor = .gray
            view.addSubview(adsEnabledTitle)

            let adsEnabledlLabel = UILabel.init(frame: CGRect(x: adsEnabledTitle.frame.maxX + 5, y:  adsEnabledTitle.frame.minY, width: view.frame.width - 120, height: 30))
            adsEnabledlLabel.text = video.isAdEnabled?.description
            adsEnabledlLabel.textColor = .lightGray
            view.addSubview(adsEnabledlLabel)
            
            let playerVerisonTitle = UILabel.init(frame: CGRect(x: adsEnabledTitle.frame.minX, y:  adsEnabledTitle.frame.maxY + 10, width: 100, height: 30))
            playerVerisonTitle.text = "Player ver.:"
            playerVerisonTitle.textColor = .gray
            view.addSubview(playerVerisonTitle)

            let playerVersionLabel = UILabel.init(frame: CGRect(x: playerVerisonTitle.frame.maxX + 5, y:  playerVerisonTitle.frame.minY, width: view.frame.width, height: 30))
            playerVersionLabel.text = player.version.description
            playerVersionLabel.textColor = .lightGray
            view.addSubview(playerVersionLabel)
            
            let dataZoomIdTitle = UILabel.init(frame: CGRect(x: playerVerisonTitle.frame.minX, y:  playerVerisonTitle.frame.maxY + 10, width: 100, height: 30))
            dataZoomIdTitle.text = "DZ ConfigId:"
            dataZoomIdTitle.textColor = .gray
            view.addSubview(dataZoomIdTitle)

            let dataZoomIdLabel = UILabel.init(frame: CGRect(x: dataZoomIdTitle.frame.maxX + 5, y:  dataZoomIdTitle.frame.minY, width: view.frame.width - 120, height: 30))
            dataZoomIdLabel.text = dataZoomConfigId
            dataZoomIdLabel.adjustsFontSizeToFitWidth = true
            dataZoomIdLabel.textColor = .lightGray
            view.addSubview(dataZoomIdLabel)
            
            let dataZoomUrlTitle = UILabel.init(frame: CGRect(x: dataZoomIdTitle.frame.minX, y:  dataZoomIdTitle.frame.maxY + 10, width: 100, height: 30))
            dataZoomUrlTitle.text = "DZ Beacon:"
            dataZoomUrlTitle.textColor = .gray
            view.addSubview(dataZoomUrlTitle)

            let dataZoomUrlLabel = UILabel.init(frame: CGRect(x: dataZoomUrlTitle.frame.maxX + 5, y:  dataZoomUrlTitle.frame.minY, width: view.frame.width - 120, height: 30))
            dataZoomUrlLabel.text = dataZoomUrl
            dataZoomUrlLabel.adjustsFontSizeToFitWidth = true
            dataZoomUrlLabel.textColor = .lightGray
            view.addSubview(dataZoomUrlLabel)
            
            let gaiIdTitle = UILabel.init(frame: CGRect(x: dataZoomUrlTitle.frame.minX, y:  dataZoomUrlTitle.frame.maxY + 10, width: 100, height: 30))
            gaiIdTitle.text = "GA ClientId:"
            gaiIdTitle.textColor = .gray
            view.addSubview(gaiIdTitle)

            let gaiIdLabel = UILabel.init(frame: CGRect(x: gaiIdTitle.frame.maxX + 5, y:  gaiIdTitle.frame.minY, width: view.frame.width - 120, height: 30))
            gaiIdLabel.text = gaClientId
            gaiIdLabel.adjustsFontSizeToFitWidth = true
            gaiIdLabel.textColor = .lightGray
            view.addSubview(gaiIdLabel)
        }
    }
    
    @objc func closeButtonTap() {
       self.player.destroy()
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
       self.videoPlayerView.removeFromSuperview()
       self.view.removeFromSuperview()
    }
    @objc func sendDataButtonTap() {
        sendDataButton.setTitle("Data Sent", for: .normal)
                   DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    let DZURL = NSURL(string: self.dataZoomUrl)
                               let domain = (DZURL?.host)!
                               DZAmpCollector.dzSharedManager.customMetaData(["customPlayerName": "Akamai Player", "customDomain": domain])
                               DZAmpCollector.dzSharedManager.customEvents("SDKLoaded", metadata: nil)
                           }
    }
}

class VideoPlayerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.rgb(red: 50, green: 50, blue: 50)
        UIApplication.shared.setStatusBarHidden(true, with: .fade)
    }
    required init?(coder: NSCoder) {
        fatalError("CODER ERROR")
    }
}

extension AkamaiPlayer: PlayerEventObserver, IMAEventObserver {
    func onBufferingStateChanged(_ player: AmpPlayer) {
        if player.bufferingState == .ready {
            player.autoplay = true
            
            if(adRequested) {
                imaAds.requestAds(adsUrl: imaAdsUrl)
            }
        }
    }
}


