//
//  VideoPlayerViewController.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 1/27/17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation

class VideoPlayerViewController: UIViewController {
    
    var fileUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let videoURL = fileUrl else {
            return
        }
        
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}
