//
//  ViewController.swift
//  musicplayer
//
//  Created by joseph on 2020/10/28.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {
    var index = 0
    let player = AVPlayer()
    var musicItem:AVPlayerItem?
    let gradientLayer = CAGradientLayer()
    let time = CMTime(value: 0, timescale: 1)
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var songSlider: UISlider!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var songLengthLabel: UILabel!
    @IBOutlet weak var playandPause: UIButton!
    @IBOutlet weak var musicImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let fileUrl = Bundle.main.url(forResource: "涼涼", withExtension: "mp3")!
        musicItem = AVPlayerItem(url: fileUrl)
        musicImage.image = UIImage(named: "涼涼.jpg")
        songNameLabel.text = "涼涼"
        observeCurrentTime()
        updatePlayerUI()
        viewBackGround()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @IBAction func volumeSlider(_ sender: UISlider) {
        sender.setValue(sender.value, animated: true)
        player.volume = sender.value
    }
    @IBAction func playButton(_ sender: UIButton) {
        player.replaceCurrentItem(with: musicItem)
// 根據播放的rate(播放速率)，來判斷他是否正在播放
        if player.rate == 0 {
//            按下播放鍵將圖換成暫停鍵
            playandPause.setImage(UIImage(systemName: "pause.fill.png"), for: UIControl.State.normal)
            player.play()
        }else{
//            按下暫停鍵將圖換成播放鍵
            playandPause.setImage(UIImage(systemName: "play.fill.png"), for: UIControl.State.normal)
            player.pause()
        }
    }
    @IBAction func songActionSlider(_ sender: UISlider) {
        let seconds = Int64(songSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        player.seek(to: targetTime)
    }
    @IBAction func forwardButton(_ sender: UIButton) {
        let fileUrl = Bundle.main.url(forResource: "I will always love you", withExtension: "mp3")!
        musicItem = AVPlayerItem(url: fileUrl)
        musicImage.image = UIImage(named: "I will always love you.jpg")
        songNameLabel.text = "I will always love you"
        observeCurrentTime()
        updatePlayerUI()
         player.replaceCurrentItem(with: musicItem)
    }
    @IBAction func backwardButton(_ sender: UIButton) {
        let fileUrl = Bundle.main.url(forResource: "涼涼", withExtension: "mp3")!
        musicItem = AVPlayerItem(url: fileUrl)
        musicImage.image = UIImage(named: "涼涼.jpg")
        songNameLabel.text = "涼涼"
        observeCurrentTime()
        updatePlayerUI()
        player.replaceCurrentItem(with: musicItem)
    }
    func updatePlayerUI(){
        guard let duration = musicItem?.asset.duration else {
            return
        }
        let seconds = CMTimeGetSeconds(duration)
        songLengthLabel.text = formatConversion(time:seconds)
        songSlider.minimumValue = 0
        songSlider.maximumValue = Float(seconds)
        songSlider.isContinuous = true
        }
    func observeCurrentTime(){
        player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: DispatchQueue.main, using: {(CMTime) in
            if self.player.currentItem?.status == .readyToPlay {
                let currentTime = CMTimeGetSeconds(self.player.currentTime())
                self.songSlider.value = Float(currentTime)
                self.currentTime.text = self.formatConversion(time:currentTime)
            }
        })
    }
    func formatConversion(time:Float64) -> String {
        let songLength = Int(time)
        let minutes = Int(songLength / 60)  // 求songLength的商，為分鐘數
        let seconds = Int(songLength % 60)  // 求songLength的餘數，為秒數
        var time = ""
        if minutes < 10 {
            time = "0\(minutes):"
        }else {
            time = "\(minutes):"
        }
        if seconds < 10 {
            time = time + "0\(seconds)"
        }else {
            time = time + "\(seconds)"
        }
        return time
    }
    //    自行設計漸層
    func viewBackGround(){
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.red.cgColor,UIColor.purple.cgColor,UIColor.orange.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
        //設定方向為斜的
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.locations = [0,0.6,0.8,1]
    }
}

