//
//  Coordinator.swift
//  noveltl-ios
//
//  Created by 19677165 on 04.08.2022.
//

import Foundation
import Combine
import UIKit

/// Агреггирующий протокол для координатора.
protocol Coordinator: Router, TransitionPerformer {

	/// Возвращает переход для конкретного пути.
	func prepareTransition(for path: P) -> T
}

/// Базовый класс координатора.
class BaseCoordinator<T: TransitionProtocol, P: Path>: Coordinator {

	public var viewController: UIViewController? { presenter as? UIViewController }

	public private(set) var presenter: Presenter

	public init(presenter: Presenter, initialPath: P?) {
		self.presenter = presenter
		initialPath.map(prepareTransition).map(performInitialTransition)
	}

	func prepareTransition(for path: P) -> T {
		fatalError("\(#function) не реализован у \(String(describing: self))")
	}

	func perform(_ transition: T, completion: (() -> Void)? = nil) {
		transition.perform(on: presenter, completion: completion)
	}

	func trigger(_ path: P, with completion: PresentationHandler?) {
		let transition = prepareTransition(for: path)
		perform(transition, completion: completion)
	}

	func trigger(_ path: P, context completion: ContextPresentationHandler?) {
		let transition = prepareTransition(for: path)
		perform(transition) { completion?(transition) }
	}
}

extension BaseCoordinator {
	typealias Presenter = T.Presenter
}

private extension BaseCoordinator {

	func performInitialTransition(_ transition: T) {
		perform(transition, completion: nil)
	}
}
