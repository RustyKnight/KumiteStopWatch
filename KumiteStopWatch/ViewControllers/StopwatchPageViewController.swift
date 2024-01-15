//
//  StopwatchPageViewController.swift
//  KumiteStopWatch
//
//  Created by Shane Whitehead on 7/04/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit

class StopwatchPageViewController: UIPageViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private var orderedViewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        
        orderedViewControllers.append(loadViewControllerWithIdentifer(name: "KumiteStopWatch"))
        orderedViewControllers.append(loadViewControllerWithIdentifer(name: "CoolDown"))
        
        let kumiteTimeLine = TimeLineBuilder(
            withName: "2 Minute Kumite",
            withDurationOf: 2.0 * 60.0,
            andIsPausable: true
        )
            .startWith(color: UIColor.green, alerts: TimeLineAlert.None)
            .endWith(color:UIColor.red, alerts: TimeLineAlert.FlashBackground, TimeLineAlert.Vibrate)
            .add(location: 0.75, color: UIColor.yellow, alerts: TimeLineAlert.FlashBackground, TimeLineAlert.Vibrate)
            .build()
        
        if let viewController = orderedViewControllers[0] as? StopWatchViewController {
            viewController.timeLine = kumiteTimeLine
        }
        
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
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func loadViewControllerWithIdentifer(name: String) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: name)
    }
    
}

extension StopwatchPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
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
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
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
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard
            let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = orderedViewControllers.firstIndex(of: firstViewController)
        else {
            return 0
        }
        return firstViewControllerIndex
    }
}
