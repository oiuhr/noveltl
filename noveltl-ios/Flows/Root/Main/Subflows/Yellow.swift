//
//  Yellow.swift
//  noveltl-ios
//
//  Created by 19677165 on 18.08.2022.
//

import Foundation
import UIKit


final class YellowViewController: UIViewController {

	var router: RouterBox<MainPath>?

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Yellow"
		tabBarItem = UITabBarItem(
			title: "Yellow", image: UIImage(named: "star.fill"), tag: 0
		)
		view.backgroundColor = .systemYellow
		let button = UIButton()
		button.setTitle("Greer", for: .normal)
		button.addTarget(self, action: #selector(tap), for: .touchUpInside)
		button.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(button)
		NSLayoutConstraint.activate([
			button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			button.widthAnchor.constraint(equalToConstant: 100),
			button.heightAnchor.constraint(equalToConstant: 100)
		])
	}


	@objc
	func tap() {
		router?.trigger(.green(text: String(UUID().uuidString.suffix(10))))
	}
}


