//
//  MainCoordinator.swift
//  noveltl-ios
//
//  Created by 19677165 on 18.08.2022.
//

import Foundation
import UIKit


enum MainPath: Path {

	case yellow
	case pink
	case green(text: String)
}

final class MainCoordinator: BaseCoordinator<TabBarTransition, MainPath> {

	override init(presenter: BaseCoordinator<TabBarTransition, MainPath>.Presenter, initialPath: MainPath?) {
		super.init(presenter: presenter, initialPath: initialPath)

		let yellowViewController = YellowViewController()
		yellowViewController.router = self.router

		let pinkViewController = UIViewController()
		pinkViewController.title = "Pink"
		pinkViewController.tabBarItem = UITabBarItem(
			title: "Pink", image: UIImage(named: "moon.stars.fill"), tag: 1
		)
		pinkViewController.view.backgroundColor = .systemPink

		perform(.multiple(.set([yellowViewController, pinkViewController]), .select(pinkViewController)), completion: nil)
	}

	override func prepareTransition(for path: MainPath) -> TabBarTransition {
		switch path {
		case .yellow:
			return .select(0)
		case .pink:
			return .select(1)
		case .green(let text):
			return Transition { presenter, _ in
				let vc = GreenViewController()
				vc.title = text
				presenter.present(vc, animated: true, completion: nil)
			}
		}
	}

}
