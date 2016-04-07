//
//  StopwatchPageViewController.swift
//  KumiteStopWatch
//
//  Created by Shane Whitehead on 7/04/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit

class StopwatchPageViewController: UIPageViewController {
	
	private var orderedViewControllers: [UIViewController] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()

		setNeedsStatusBarAppearanceUpdate()
		
		orderedViewControllers.append(loadViewControllerWithIdentifer("KumiteStopWatch"))
		orderedViewControllers.append(loadViewControllerWithIdentifer("CoolDown"))
		
		let kumiteTimeLine = TimeLineBuilder(
			withName: "2 Minute Kumite",
			withDurationOf: 2.0 * 60.0,
			andIsPausable: true)
			.startWith(color: UIColor.greenColor(), alerts: TimeLineAlert.None)
			.endWith(color:UIColor.redColor(), alerts: TimeLineAlert.FlashBackground, TimeLineAlert.Vibrate)
			.add(location: 0.75, color: UIColor.yellowColor(), alerts: TimeLineAlert.FlashBackground, TimeLineAlert.Vibrate)
			.build()
		
		if let viewController = orderedViewControllers[0] as? StopWatchViewController {
			viewController.timeLine = kumiteTimeLine
		}

//		let color = UIColor(red: 1.0, green: 0.8, blue: 0.6, alpha: 1.0)
		
		let coolDownTimeLine = TimeLineBuilder(
			withName: "1 Minute Cool Down",
			withDurationOf: 1.0 * 60.0,
			andIsPausable: true)
			.startWith(color: UIColor(red: 1.0, green: 0.2, blue: 0.6, alpha: 1.0), alerts: TimeLineAlert.None)
			.endWith(color:UIColor(red: 1.0, green: 0.8, blue: 0.6, alpha: 1.0), alerts: TimeLineAlert.FlashBackground, TimeLineAlert.Vibrate)
			.build()
		
		if let viewController = orderedViewControllers[1] as? StopWatchViewController {
			viewController.timeLine = coolDownTimeLine
		}
		
		dataSource = self

		if let firstViewController = orderedViewControllers.first {
			setViewControllers([firstViewController], direction: .Forward, animated: true, completion: nil)
		}
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
	
	func loadViewControllerWithIdentifer(name: String) -> UIViewController {
		let storyBoard = UIStoryboard(name: "Main", bundle: nil)
		print(storyBoard)
		return storyBoard.instantiateViewControllerWithIdentifier(name)
	}
	
}

extension StopwatchPageViewController {
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}
	
}

extension StopwatchPageViewController: UIPageViewControllerDataSource {
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
		guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
			return nil
		}
		let previousIndex = viewControllerIndex - 1
		guard previousIndex >= 0 else {
			return nil
		}
		guard orderedViewControllers.count > previousIndex else {
			return nil
		}
		return orderedViewControllers[previousIndex];
	}
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
		guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
			return nil
		}
		let nextIndex = viewControllerIndex + 1
		let count = orderedViewControllers.count
		guard count != nextIndex else {
			return nil
		}
		guard count > nextIndex else {
			return nil
		}
		return orderedViewControllers[nextIndex];
	}
	
	func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
		return orderedViewControllers.count
	}
	
	func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
		guard let firstViewController = viewControllers?.first,
			firstViewControllerIndex = orderedViewControllers.indexOf(firstViewController) else {
			return 0
		}
		return firstViewControllerIndex
	}
}
