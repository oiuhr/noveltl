//
//  Presentable.swift
//  noveltl-ios
//
//  Created by 19677165 on 16.08.2022.
//

import Foundation
import UIKit

/// Сущность, которую можно как то представить(показать) на экране
protocol Presentable {

	/// Вью-контроллер сущности
	var viewController: UIViewController? { get }
	/// Роутер сущности
	func router<P: Path>(for path: P) -> RouterBox<P>?
}

extension Presentable {

	func router<P: Path>(for path: P) -> RouterBox<P>? { self as? RouterBox<P> }
}

extension UIViewController: Presentable {
	var viewController: UIViewController? { self }
}

extension UIWindow: Presentable {
	var viewController: UIViewController? { rootViewController }
}
