//
//  ViewController.swift
//  CounterClock
//
//  Created by Madona Syombua on 2/1/23.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var startAndStopButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timeRemaining: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    
    var timeLeft : Int?
    var estimate : Int?
    var clockTimer: Timer = Timer()
    var countdownTimer: Timer = Timer()
    var player: AVAudioPlayer?
    var speedFloat : Float = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //formart the date
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss"
        //the date time label
        dateTime.text = formatter.string(from: Date())
        
        formatter.dateFormat = "a"
        
        formatter.string(from: Date()) == "AM" ? renderBackgroundImage("night") :
            renderBackgroundImage("morning")
        startAndStopButton.setTitle("Start Timer", for: .normal)
        startAndStopButton.configuration?.baseForegroundColor = UIColor.black
        
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        timeRemaining.text = "Time Remaining:"
        
       loadCurrentTime()
    }

    func loadCurrentTime(){
        clockTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(self.currentTime) , userInfo: nil, repeats: true)
    }
    
    //check current time function
    @objc func currentTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss"
        dateTime.text = formatter.string(from: Date())

        formatter.dateFormat = "a"

        formatter.string(from: Date()) == "AM" ? renderBackgroundImage("morning") :
            renderBackgroundImage("night")
    }
    
    
    //background image that will change based on day or night mode
    func renderBackgroundImage (_ imageName : String) {
        background.image = UIImage(named: imageName)
    }
    
    // function for our second to hours minutes
    func secondsToHoursMinutes(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func timerCountdown(_ seconds: Int) -> String {
        let (h, m, s) = secondsToHoursMinutes(seconds)
        return String(format: "%02d:%02d:%02d",h,m,s)
    }
    
    @IBAction func timerStart(_ sender: Any) {
        countdownTimer.invalidate()
        if (startAndStopButton.currentTitle == "Start Timer") {
            startAndStopButton.setTitle("Stop Music", for: .normal)
            timeLeft = Int(datePicker.countDownDuration)
            countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startCountDown), userInfo: nil, repeats: true)
            timeRemaining.text = "Time Remaining: \(timerCountdown(Int(datePicker.countDownDuration)))"
        } else {
            player?.stop()
            startAndStopButton.setTitle("Start Timer", for: .normal)
        }
    }
    
    @objc func startCountDown() {
        if timeLeft! >= 0 {
            timeRemaining.text = "Time Remaining: \(timerCountdown(timeLeft!))"
            timeLeft! -= 1
        } else {
            countdownTimer.invalidate()
            playAlarm()
        }
    }
    
    func playAlarm() {
        if let asset = NSDataAsset(name:"alarmsong"){
            do {
                player = try AVAudioPlayer(data:asset.data, fileTypeHint:"mp3")
                player?.play()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
}

