//
//  VideoViewController.swift
//  BilliardsUSA
//
//  Created by Tommy Bartocci on 4/21/21.
//

import UIKit
import youtube_ios_player_helper

class VideoViewController: UIViewController {
    @IBOutlet weak var firstVideo: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    func setVideos() {
        firstVideo.load(withVideoId: <#T##String#>)
    }
    
    
}
