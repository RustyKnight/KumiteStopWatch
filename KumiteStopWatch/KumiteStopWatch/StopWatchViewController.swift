//
//  StopWatchViewController.swift
//  KumiteStopWatch
//
//  Created by Shane Whitehead on 31/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit

class StopWatchViewController: UIViewController {
	
	@IBOutlet weak var akaImageView: UIImageView!
	@IBOutlet weak var shiroImageView: UIImageView!
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
		
		startPauseButton.setTitle(nil, forState: .Normal)
		startPauseButton.setImage(startImage, forState: UIControlState.Normal)
		
		resetButton.setTitle(nil, forState: .Normal)
		resetButton.setImage(resetImage, forState: UIControlState.Normal)
		
		// This was changed, but I caused a massive issue, broke XCode and had
		// to build it line by line to figure it out :P
		let builder = TimeLineBuilder(
			withName: "Kumite",
			withDurationOf: 2.0 * 60.0)
		
		builder.startWith(color: UIColor.greenColor(), alerts: TimeLineAlert.None)
		builder.endWith(color:UIColor.redColor(), alerts: TimeLineAlert.FlashBackground, TimeLineAlert.Vibrate)
		builder.add(location: 0.75, color: UIColor.yellowColor(), alerts: TimeLineAlert.FlashBackground, TimeLineAlert.Vibrate)
		
		timeLine = builder.build()
		
		akaImageView.image = StopwatchControls.imageOfAka()
		shiroImageView.image = StopwatchControls.imageOfShiro()
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func updateTimeLine() {
		stopWatchView.timeLine = timeLine
		if let timeLine = timeLine {
			titleLabel.text = timeLine.name
		} else {
			titleLabel.text = "A Stopwatch"
		}
	}
	
	@IBAction func startPauseButtonTapped(sender: UIButton) {
		switch (stopWatchView.currentAnimationState()) {
		case .Stopped:
			stopWatchView.start()
		case .Running:
			stopWatchView.pause()
		case .Paused:
			stopWatchView.resume()
		}
	}
	
	@IBAction func resetButtonTapped(sender: UIButton) {
		stopWatchView.reset()
	}
	
}

extension StopWatchViewController: StopWatchDelegate {
	func stopWatch(stopWatchView: StopWatchView, stateDidChange state: AnimationState) {
		switch (state) {
		case .Stopped:
			startPauseButton.setImage(startImage, forState: UIControlState.Normal)
		case .Paused:
			startPauseButton.setImage(resumeImage, forState: UIControlState.Normal)
		case .Running:
			startPauseButton.setImage(stopImage, forState: UIControlState.Normal)
		}
	}
}
