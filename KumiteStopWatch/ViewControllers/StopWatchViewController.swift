//
//  StopWatchViewController.swift
//  KumiteStopWatch
//
//  Created by Shane Whitehead on 31/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit

class StopWatchViewController: UIViewController {
    
    @IBOutlet weak var stopWatchView: StopWatchView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    let startImage: UIImage = StopwatchControls.imageOfStartControl
    let resumeImage: UIImage = StopwatchControls.imageOfPausedControl
    let stopImage: UIImage = StopwatchControls.imageOfRunningControl
    let resetImage: UIImage = StopwatchControls.imageOfRestControl
    
    var timeLine: TimeLine? {
        didSet {
            updateTimeLine()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNeedsStatusBarAppearanceUpdate()
        
        stopWatchView.stopWatchDelegate = self
        
        startPauseButton.setTitle(nil, for: [.normal])
        startPauseButton.setImage(startImage, for: [.normal])
        
        resetButton.setTitle(nil, for: [.normal])
        resetButton.setImage(resetImage, for: [.normal])
        
        updateTimeLine()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopWatchView.pause()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTimeLine() {
        if let stopWatchView = stopWatchView {
            stopWatchView.timeLine = timeLine
            if let timeLine = timeLine {
                titleLabel.text = timeLine.name
            } else {
                titleLabel.text = "A Stopwatch"
            }
        }
    }
    
    @IBAction func startPauseButtonTapped(sender: UIButton) {
        switch (stopWatchView.currentAnimationState()) {
        case .stopped:
            stopWatchView.start()
        case .running:
            stopWatchView.pause()
        case .paused:
            stopWatchView.resume()
        }
    }
    
    @IBAction func resetButtonTapped(sender: UIButton) {
        stopWatchView.reset()
    }
    
}

extension StopWatchViewController: StopWatchDelegate {
    func stopWatch(_ stopWatchView: StopWatchView, stateDidChange state: AnimationState) {
        switch (state) {
        case .stopped:
            startPauseButton.setImage(startImage, for: [.normal])
        case .paused:
            startPauseButton.setImage(resumeImage, for: [.normal])
        case .running:
            startPauseButton.setImage(stopImage, for: [.normal])
        }
    }
}
