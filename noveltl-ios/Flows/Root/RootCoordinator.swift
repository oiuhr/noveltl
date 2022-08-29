//
//  RootCoordinator.swift
//  noveltl-ios
//
//  Created by 19677165 on 18.08.2022.
//

import UIKit


enum RootPath: Path {
	case root
}

final class RootCoordinator: BaseCoordinator<WindowTransition, RootPath> {

	let mainCoordinator: MainCoordinator

	init(window: UIWindow) {
		mainCoordinator = MainCoordinator(presenter: UITabBarController(), initialPath: .yellow)
		super.init(presenter: window, initialPath: .root)
	}

	override func prepareTransition(for path: RootPath) -> WindowTransition {
		return .set(mainCoordinator)
	}
}
