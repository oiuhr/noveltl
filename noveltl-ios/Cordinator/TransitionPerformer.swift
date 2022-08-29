//
//  TransitionPerformer.swift
//  noveltl-ios
//
//  Created by 19677165 on 16.08.2022.
//

import Foundation

/// Сущность, которая может выполнить переход.
protocol TransitionPerformer {

	/// Тип перехода, который может выполнить сущность
	associatedtype T: TransitionProtocol

	/// Выполнить переход
	///  - Parameters:
	///   - transition: переход
	///   - completion: комплишен перехода
	func perform(_ transition: T, completion: (() -> Void)?)
}
