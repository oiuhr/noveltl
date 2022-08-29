//
//  Deeplinking.swift
//  noveltl-ios
//
//  Created by 19677165 on 21.08.2022.
//

import Foundation


extension Coordinator where Self: AnyObject {

	/// Зачейнить пути разных типов.
	///
	/// - Parameters:
	///  - path: изначальный путь координатора, которому прилетает первый переход.
	///  - remainingPaths: следующие пути для переходов.
	///
	/// - Note: не type-safe, может положить приложение.
	func chain(_ path: P, with remainingPaths: Path...) -> Transition<T.Presenter> {
		chain(path, with: remainingPaths)
	}

	func chain(_ path: P, with remainingPaths: [Path]) -> Transition<T.Presenter> {
		.chain(self, from: path, with: remainingPaths)
	}
}

fileprivate extension Transition {

	static func chain<C: Coordinator & AnyObject>(
		_ coordinator: C,
		from path: C.P,
		with remainingPaths: [Path]
	) -> Transition {
		Transition { [weak coordinator] _, completion in
			guard let coordinator = coordinator else { completion?(); return }
			path.trigger(on: coordinator, remainingPaths: remainingPaths, completion: completion)
		}
	}
}

fileprivate extension Path {

	func trigger(on presentable: Presentable, remainingPaths: [Path], completion: PresentationHandler?) {
		guard let router = presentable.router(for: self) else {
			completion?()
			return
		}

		router.trigger(self) { context in
			guard let nextPath = remainingPaths.first,
				  let nextPresentable = context.presentables.first
			else {
				completion?()
				return
			}
			nextPath.trigger(on: nextPresentable, remainingPaths: Array(remainingPaths.dropFirst()), completion: completion)
		}
	}
}
