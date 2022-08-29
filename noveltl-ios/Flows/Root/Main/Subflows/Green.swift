//
//  Green.swift
//  noveltl-ios
//
//  Created by 19677165 on 18.08.2022.
//

import Foundation
import UIKit


final class GreenViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .systemGreen
		let button = UIButton()
		button.setTitle(title, for: .normal)
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
		guard let navigationFacade = (UIApplication.shared.delegate as? AppDelegate) else { return }

		navigationFacade.consume(chain: NavigationMap.profile) { [weak self] in
			self?.dismiss(animated: true, completion: nil)
		}
	}
}
