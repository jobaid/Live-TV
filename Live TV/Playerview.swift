import UIKit
import WebKit

class Playerview: UIViewController {

   // @IBOutlet weak var webView: WKWebView! // Connected from Storyboard
    var webView: WKWebView!
    var ID: String?  // Receiving the ID from the previous screen
    var cat: String?
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        loadVideoPlayer()
    }

    func setupWebView() {
        let config = WKWebViewConfiguration()
           config.allowsInlineMediaPlayback = true
           config.mediaTypesRequiringUserActionForPlayback = []

           webView = WKWebView(frame: .zero, configuration: config)
           webView.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(webView)

           NSLayoutConstraint.activate([
               webView.leadingAnchor.constraint(equalTo: view.leadingAnchor), // X = 0
               webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 76), // Y = 16
               webView.trailingAnchor.constraint(equalTo: view.trailingAnchor), // Full width
               webView.heightAnchor.constraint(equalTo: webView.widthAnchor, multiplier: 9.0/16.0) // Maintain 16:9 ratio
           ])
    }

    func loadVideoPlayer() {
        guard let id = ID, let videoURL = URL(string: id) else {
            print("Invalid or nil video URL")
            return
        }
        
        let htmlString = """
        <!DOCTYPE html>
        <html>
        <head>
        <meta charset="utf-8" />
        <title>Live Stream</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <link href="https://unpkg.com/video.js/dist/video-js.css" rel="stylesheet">
        <script src="https://unpkg.com/video.js/dist/video.js"></script>
        <script src="https://unpkg.com/videojs-contrib-hls/dist/videojs-contrib-hls.js"></script>
        <style>
            html, body {
                margin: 0;
                padding: 0;
                width: 100vw;
                height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                background-color: black;
            }
            #video-container {
                width: 100%;
                max-width: 100%;
                height: auto;
            }
            .video-js {
                width: 100%;
                height: 60%;
            }
        </style>
        </head>
        <body>
            <div id="video-container">
                <video id="my_video_1" class="video-js vjs-fluid vjs-default-skin" controls preload="auto" playsinline webkit-playsinline>
                    <source src="\(videoURL)" type="application/x-mpegURL">
                </video>
            </div>
            <script>
                var player = videojs('my_video_1', {
                    controlBar: {
                        fullscreenToggle: true // Keeps full-screen as an option
                    }
                });

                // Force inline playback and prevent auto full-screen
                document.addEventListener('DOMContentLoaded', function() {
                    var video = document.getElementById('my_video_1');
                    video.setAttribute('playsinline', 'true'); // ✅ Ensures video plays inline
                    video.setAttribute('webkit-playsinline', 'true'); // ✅ For older iOS versions
                });
            </script>
        </body>
        </html>
        """
        
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
}
