//
//  Router.swift
//  noveltl-ios
//
//  Created by 19677165 on 16.08.2022.
//

import Foundation
import UIKit

/// Контекст перехода
protocol TransitionContext {

	/// Показываемые переходом сущности
	var presentables: [Presentable] { get }
}

typealias PresentationHandler = () -> Void
typealias ContextPresentationHandler = (TransitionContext) -> Void

/// Сущность, которая может триггерить конкретные пути
protocol Router: Presentable {

	/// Путь, который роутер может триггернуть
	associatedtype P: Path

	/// Триггернуть путь
	func trigger(_ path: P, with completion: PresentationHandler?)

	/// Триггернуть путь с прокидыванием контекста перехода
	func trigger(_ path: P, context completion: ContextPresentationHandler?)
}


extension Router {

	var router: RouterBox<P> { RouterBox(self) }
	func router<P: Path>(for path: P) -> RouterBox<P>? { router as? RouterBox<P> }
}

extension Router {

	func trigger(_ path: P) { trigger(path, with: nil) }
}

final class RouterBox<P: Path>: Router {

	private let _trigger: ((P, PresentationHandler?) -> ())?
	private let _contextTrigger: ((P, ContextPresentationHandler?) -> ())?
	private let _viewController: (() -> UIViewController?)?

	var viewController: UIViewController? { _viewController?() }

	init<R: Router>(_ router: R) where R.P == P {
		_trigger = router.trigger(_:with:)
		_contextTrigger = router.trigger(_:context:)
		_viewController = { router.viewController }
	}

	func trigger(_ path: P, with completion: PresentationHandler?) {
		_trigger?(path, completion)
	}

	func trigger(_ path: P, context completion: ContextPresentationHandler?) {
		_contextTrigger?(path, completion)
	}
}
