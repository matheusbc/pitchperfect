//
//  MainViewController.swift
//  pitchperfect
//
//  Copyright © 2017 Matheus Campos. All rights reserved.
//

import AVFoundation
import UIKit

class RecordAudioViewController: UIViewController {
    /// MARK: Outlets
    /// Record audio button.
    @IBOutlet weak var recordButton: UIButton!
    /// Stop recording audio button.
    @IBOutlet weak var stopButton: UIButton!
    /// Record audio label.
    @IBOutlet weak var recordLabel: UILabel!

    /// MARK: Properties
    /// Audio recorder session.
    var recordingSession: AVAudioSession!
    /// Audio recorder.
    var audioRecorder: AVAudioRecorder!

    /// MARK: Actions
    /**
     Record audio button action.

     - Parameter sender: The type of the sender object.
     */
    @IBAction func startRecording(_ sender: Any) {
        recordAudio()
    }

    /**
     Stop recording audio button action.

     - Parameter sender: The type of the sender object.
     */
    @IBAction func stopRecording(_ sender: Any) {
        stopRecording()
    }

    override func viewWillAppear(_ animated: Bool) {
        loadRecorder()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "audioRecorded" {
            let playAudioVC = segue.destination as! PlayAudioViewController
            let recordedAudioURL = sender as! URL
            playAudioVC.recordedAudioURL = recordedAudioURL
        }
    }

    /// Initializes recorder audio session and requests audio permission.
    func loadRecorder() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.configureUI(.notRecording)
                    } else {
                        AlertDialog.showAlert(self, title: Alerts.RecordingDisabledTitle, message: Alerts.RecordingDisabledMessage)
                        print("Error! App hasn't permission to record audio.")
                    }
                }
            }
        } catch {
            AlertDialog.showAlert(self, title: Alerts.AudioSessionError, message: String(describing: error))
            print("Error while initializing audio recorder.")
        }
    }

    /// Starts recording audio.
    func recordAudio() {
        configureUI(.recording)

        let filePath = getFilePath()
        print("Recording audio to path: " + filePath.absoluteString)

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: filePath, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        } catch {
            configureUI(.notRecording)
        }
    }

    /// Stops recording audio.
    func stopRecording() {
        print("Stopped recording audio.")
        configureUI(.notRecording)

        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }

    /// Gets audio file path.
    /// Returns: audio file path.
    func getFilePath() -> URL {
        let audioFileName = "pitchPerfect.m4a"
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent(audioFileName)
    }

    // MARK: UI Functions
    func configureUI(_ playState: RecordingState) {
        switch(playState) {
        case .recording:
            recordButton.isEnabled = false
            stopButton.isEnabled = true
            recordLabel.text = "Recording audio... Tap to stop"
        case .notRecording:
            recordButton.isEnabled = true
            stopButton.isEnabled = false
            recordLabel.text = "Tap to start recording"
        }
    }
}

extension RecordAudioViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "audioRecorded", sender: audioRecorder.url)
        } else {
            AlertDialog.showAlert(self, title: Alerts.RecordingFailedTitle, message: Alerts.RecordingFailedMessage)
            print("Audio recording was not successfully.")
        }
    }
}
