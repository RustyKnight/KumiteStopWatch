//
//  AppDelegate.swift
//  KumiteStopWatch
//
//  Created by Shane Whitehead on 19/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		return true
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//		loadReveal()
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

	func loadReveal() {
		if NSClassFromString("IBARevealLoader") == nil {
			let revealLibName = "libReveal" // or "libReveal-tvOS" for tvOS targets
			let revealLibExtension = "dylib"
			var error: String?
			
			if let dylibPath = NSBundle.mainBundle().pathForResource(revealLibName, ofType: revealLibExtension) {
				print("Loading dynamic library \(dylibPath)")
				
				let revealLib = dlopen(dylibPath, RTLD_NOW)
				if revealLib == nil {
					error = String(UTF8String: dlerror())
				}
			} else {
				error = "File not found."
			}
			
			if error != nil {
				let alert = UIAlertController(title: "Reveal library could not be loaded",
				                              message: "\(revealLibName).\(revealLibExtension) failed to load with error: \(error!)",
                                  preferredStyle: .Alert)
				alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
				UIApplication.sharedApplication().windows.first?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
			}
		}
 }
}

