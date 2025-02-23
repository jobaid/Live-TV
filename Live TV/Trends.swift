

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage
import WebKit
import AVKit
import AVFoundation
class Trends: UIViewController {
    
    var ID: String?  // Receiving the ID from the previous screen
    var cat: String?
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    @IBOutlet weak var videoview: UIView!
    @IBOutlet weak var name1: UILabel!
    // UIImageView for Play/Pause icon
       var playPauseIcon: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize WKWebView
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [])
        try? AVAudioSession.sharedInstance().setActive(true)
        getvideo()
        name1.text = cat
        setupAudioSession()
        
        // Add tap gesture recognizer to toggle play/pause
              let tapGesture = UITapGestureRecognizer(target: self, action: #selector(togglePlayPause))
              videoview.addGestureRecognizer(tapGesture)
        // Show Play & Pause Icon over player
        setupPlayPauseIcon()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = videoview.bounds
    }
    
    // Set up Play/Pause icon
      func setupPlayPauseIcon() {
          playPauseIcon = UIImageView(frame: CGRect(x: (videoview.frame.width - 50) / 2, y: (videoview.frame.height - 50) / 2, width: 50, height: 50))
          playPauseIcon.contentMode = .scaleAspectFit
          playPauseIcon.isHidden = true  // Initially hidden
          
          // Add the image view to the view hierarchy
          videoview.addSubview(playPauseIcon)
      }

      // Toggle between play and pause
      @objc func togglePlayPause() {
          guard let player = player else { return }
          
          if player.rate == 0 {
              // If the video is paused, play it
              player.play()
              // Show pause icon
              playPauseIcon.image = UIImage(systemName: "pause.circle.fill")
              showPlayPauseIcon()
          } else {
              // If the video is playing, pause it
              player.pause()
              // Show play icon
              playPauseIcon.image = UIImage(systemName: "play.circle.fill")
              showPlayPauseIcon()
          }
      }

      // Show the Play/Pause icon for 1 second
      func showPlayPauseIcon() {
          playPauseIcon.isHidden = false
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
              self.playPauseIcon.isHidden = true
          }
      }
    
    func getvideo() {
        guard let id = ID, let videoURL = URL(string: id) else {
            print("Invalid or nil video URL")
            return
        }
        
        // Initialize AVPlayer
        let videoAsset = AVAsset(url: videoURL)
        let videoPlayerItem = AVPlayerItem(asset: videoAsset)
        player = AVPlayer(playerItem: videoPlayerItem)
        
        // Create and configure AVPlayerLayer
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = videoview.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        
        if let layer = playerLayer {
            videoview.layer.addSublayer(layer)
        }
        
        // Observe video status to check if it loads properly
        player?.currentItem?.addObserver(self, forKeyPath: "status", options: [.new, .old], context: nil)
        
        // Observe playback completion for looping
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishPlaying),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
        
        player?.play()
        print("Video started playing") // Debugging log
    }
    
    @objc func playerDidFinishPlaying() {
        player?.seek(to: CMTime.zero)
        player?.play()
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if let playerItem = object as? AVPlayerItem {
                switch playerItem.status {
                case .readyToPlay:
                    print("Video is ready to play")
                case .failed:
                    print("Playback error: \(playerItem.error?.localizedDescription ?? "Unknown error")")
                case .unknown:
                    print("Unknown error occurred")
                @unknown default:
                    print("Unhandled status")
                }
            }
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        player?.currentItem?.removeObserver(self, forKeyPath: "status")
    }
    func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .moviePlayback, options: [])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            print("Audio session activated")
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
    }
}
