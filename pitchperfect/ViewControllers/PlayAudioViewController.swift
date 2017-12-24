//
//  PlayAudioViewController.swift
//  pitchperfect
//
//  Copyright © 2017 Matheus Campos. All rights reserved.
//

import UIKit
import AVFoundation

class PlayAudioViewController: UIViewController {
    /// MARK: Outlets
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var highButton: UIButton!
    @IBOutlet weak var lowButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!

    /// MARK: Properties
    var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!

    /// MARK: Controllers
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
    }

    /// MARK: Actions
    @IBAction func playAudio(_ sender: UIButton) {
        var effect = "none"
        switch(ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
            effect = "slow"
        case .fast:
            playSound(rate: 1.5)
            effect = "fast"
        case .chipmunk:
            playSound(pitch: 1000)
            effect = "chipmunk"
        case .vader:
            playSound(pitch: -1000)
            effect = "vader"
        case .echo:
            playSound(echo: true)
            effect = "echo"
        case .reverb:
            playSound(reverb: true)
            effect = "reverb"
        }

        print("Playing audio with \(effect) effect.")
        configureUI(.playing)
    }

    @IBAction func pauseAudio(_ sender: Any) {
        print("Audio paused.")
        stopAudio()
    }
}
