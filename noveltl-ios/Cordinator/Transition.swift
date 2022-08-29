//
//  Transition.swift
//  noveltl-ios
//
//  Created by 19677165 on 16.08.2022.
//

import UIKit

/// Протокол для абстракции любой конкретной реализации перехода
protocol TransitionProtocol: TransitionContext {

	/// Презентер, выполняющий переход
	associatedtype Presenter

	/// Выполнить переход
	///  - Parameters:
	///   - presenter: презентер, выполняющий переход
	///   - completion: комплишен перехода
	func perform(on presenter: Presenter, completion: (() -> Void)?)
}

/// Атомарное действие по показу чего-либо на экране
struct Transition<PresenterType>: TransitionProtocol {

	/// Действие показа
	///  - Parameters:
	///   - presenter: исполнитель перехода
	///   - completion: комплишен перехода
	typealias Perform = (_ presenter: PresenterType, _ completion: (() -> Void)?) -> Void

	private let _presentables: [Presentable]
	private let _perform: Perform

	var presentables: [Presentable] { _presentables }

	///
	/// Инициализатор
	///
	/// С помощью инициализатора можно создать кастомный переход.
	///
	/// Для повсеместно используемых переходов (например, `UINavigationController.push( ... )`)
	/// хорошей практикой будет создание транзишенов через статические функции.
	///
	/// - Parameters:
	///  - perform: действие показа.
	init(perform: @escaping Perform) {
		self.init(presentables: [], perform: perform)
	}

	init(presentables: [Presentable], perform: @escaping Perform) {
		self._presentables = presentables
		self._perform = perform
	}

	func perform(on presenter: PresenterType, completion: (() -> Void)? = nil) {
		_perform(presenter, completion)
	}
}

/// Переходы общего назначения
extension Transition {

	/// Зачейнить несколько переходов в рамках одного презентера
	static func multiple<C: Collection>(_ transitions: C) -> Transition where C.Element == Transition  {
		Transition { presenter, completion in
			guard let transition = transitions.first else {
				completion?()
				return
			}
			transition.perform(on: presenter) {
				Transition
					.multiple(transitions.dropFirst())
					.perform(on: presenter, completion: completion)
			}
		}
	}

	static func multiple(_ transitions: Transition...) -> Transition {
		multiple(transitions)
	}

	/// Пустой переход
	static func none() -> Transition { Transition { _, completion in completion?() } }
}

/// Переход в рамках навигационного стэка
typealias NavigationTransition = Transition<UINavigationController>
extension NavigationTransition {

	static func push(_ presentable: Presentable, animated: Bool = true) -> Transition {
		Transition(presentables: [presentable]) { presenter, completion in
			guard let controller = presentable.viewController else { return }
			presenter.pushViewController(controller, animated: animated)
			completion?()
		}
	}

	static func pop(animated: Bool = true) -> Transition {
		Transition { presenter, completion in
			presenter.popViewController(animated: animated)
			completion?()
		}
	}
}

typealias WindowTransition = Transition<UIWindow>
extension WindowTransition {

	static func set(_ presentable: Presentable) -> Transition {
		Transition(presentables: [presentable]) { presenter, completion in
			guard presenter.rootViewController != presentable.viewController else {
				completion?()
				return
			}
			presenter.rootViewController = presentable.viewController
			UIView.transition(
				with: presenter,
				duration: 0.25,
				options: .transitionCrossDissolve,
				animations: nil,
				completion: { _ in completion?() }
			)
			presenter.makeKeyAndVisible()
		}
	}
}

typealias TabBarTransition = Transition<UITabBarController>
extension TabBarTransition {

	static func set(_ presentables: [Presentable]) -> Transition {
		Transition(presentables: presentables) { presenter, completion in
			presenter.setViewControllers(presentables.compactMap(\.viewController), animated: true)
			completion?()
		}
	}

	static func select(_ presentable: Presentable) -> Transition {
		Transition(presentables: [presentable]) { presenter, completion in
			presenter.selectedViewController = presentable.viewController
			completion?()
		}
	}

	static func select(_ index: Int) -> Transition {
		Transition { presenter, completion in
			presenter.selectedIndex = index
			completion?()
		}
	}
}


