//
//  VideoGalleryViewController.swift
//  NewsApp
//
//  Created by Raf Aghayan on 23.01.21.
//

import UIKit
import youtube_ios_player_helper

class VideoGalleryViewController: UIViewController, YTPlayerViewDelegate {

    @IBOutlet weak var playerView: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerView.delegate = self
        playerView.load(withVideoId: selectedVideo, playerVars: ["playsinline": "1"])
    }
  
    func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor {
        return UIColor.black
    }

}
