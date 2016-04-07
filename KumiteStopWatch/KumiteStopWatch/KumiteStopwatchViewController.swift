//
//  KumiteStopwatchViewController.swift
//  KumiteStopWatch
//
//  Created by Shane Whitehead on 7/04/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit

class KumiteStopwatchViewController: StopWatchViewController {

	@IBOutlet weak var akaImageView: UIImageView!
	@IBOutlet weak var shiroImageView: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		akaImageView.image = StopwatchControls.imageOfAka()
		shiroImageView.image = StopwatchControls.imageOfShiro()

		// This was changed, but I caused a massive issue, broke XCode and had
		// to build it line by line to figure it out :P
//		let builder = TimeLineBuilder(
//			withName: "Kumite",
//			withDurationOf: 2.0 * 60.0,
//			andIsPausable: true)
//		
//		builder.startWith(color: UIColor.greenColor(), alerts: TimeLineAlert.None)
//		builder.endWith(color:UIColor.redColor(), alerts: TimeLineAlert.FlashBackground, TimeLineAlert.Vibrate)
//		builder.add(location: 0.75, color: UIColor.yellowColor(), alerts: TimeLineAlert.FlashBackground, TimeLineAlert.Vibrate)
//		
//		timeLine = builder.build()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
}
