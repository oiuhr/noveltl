//
//  AppDelegate.swift
//  noveltl-ios
//
//  Created by 19677165 on 25.02.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var coordinator: RootCoordinator?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		coordinator = RootCoordinator(window: UIWindow())
		return true
	}

	func consume(chain: NavigationChain, with completion: PresentationHandler?) {
		guard let transition = coordinator?.chain(.root, with: chain) else { return }
		coordinator?.perform(transition, completion: completion)
	}
}

