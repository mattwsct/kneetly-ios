//
//  TutorialsViewController.swift
//  KneetlyCommon
//
//  Created by Matt Westcott on 1/26/17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

public class TutorialsViewController: UIViewController {

    public  var tutorialsDataSource: DataSource<[VideoItem]>!
    
    public  var watchedVideoTracker: WatchedVideoTracker?
    
    public var canUserControlVideo = true
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet weak var continueButton: KneetlyButton!
    
    fileprivate var cellInfo = [VideoItemCellInfo]()
    
    private var currentVideo: VideoItem?
    
    public var allVideoIsWatchedHandler: (()->())?
    
    private var videoPlayerNavigationController: UINavigationController?
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        if canUserControlVideo {
            tableView.tableFooterView = nil
        }
        
        setupDataSource()
        tutorialsDataSource.reload()
        
        reload()
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        guard let handler = allVideoIsWatchedHandler else {
            return
        }
        
        handler()
    }

    private func setupDataSource() {
        tutorialsDataSource.onStateUpdated = { [weak self] (dataSource, state) in
            self?.handleDataLoading(withDataSource: dataSource, state: state, contentReloadHandler: { [weak self] in
                self?.reload()
            })
        }
    }
    
    private func reload() {
        guard let items = tutorialsDataSource.items else {
            return
        }
        cellInfo = items.map({VideoItemCellInfo.makeInfo(withVideoItem: $0)})
        
        tableView.reloadData()
    }
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let playerVC = segue.destination as? VideoPlayerViewController else {
            return
        }
    }
    
    fileprivate func playVideo(atIndexPath path: IndexPath) {
        guard let video = tutorialsDataSource.items?[path.row] else {
            return
        }
        
        guard let url = URL(string: video.url) else {
            return
        }
        
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.showsPlaybackControls = canUserControlVideo
        playerViewController.player = player
        
        if canUserControlVideo {
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
        else {
            let nc = UINavigationController(rootViewController: playerViewController)
            nc.navigationBar.barStyle = .blackTranslucent
            nc.navigationBar.isTranslucent = true
            playerViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDoneButtonTap))
            playerViewController.navigationItem.leftBarButtonItem?.tintColor = UIColor.lightGray
            self.present(nc, animated: true, completion: { 
                playerViewController.player!.play()
            })
            
            videoPlayerNavigationController = nc
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        currentVideo = video
        
    }
    
     @objc func playerDidFinishPlaying(note: NSNotification) {
        guard let video = currentVideo else {
            return
        }
        DispatchQueue.main.async {
            self.watchedVideoTracker?.markVideoAsWatched(videoId: video.id, completion: { [weak self] (isSuccess) in
                self?.currentVideo?.isWatched = true
                self?.currentVideo = nil
                self?.reload()
                
                guard let items = self?.tutorialsDataSource.items else {
                    return
                }
                
                if items.filter({$0.isWatched != nil && !$0.isWatched!}).count == 0 {
                    self?.continueButton.isEnabled = true
                }
            })
        }
    }
    
    @objc func onDoneButtonTap() {
        videoPlayerNavigationController?.dismiss(animated: true, completion: { [unowned self] in
            self.videoPlayerNavigationController = nil
        })
    }
}

extension TutorialsViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.videoCell)!
        cell.info = cellInfo[indexPath.row]
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tutorialsDataSource.items?.count ?? 0
    }
}

extension TutorialsViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playVideo(atIndexPath: indexPath)
    }
}
