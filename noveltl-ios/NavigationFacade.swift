//
//  NavigationFacade.swift
//  noveltl-ios
//
//  Created by 19677165 on 22.08.2022.
//

import Foundation


typealias NavigationChain = [Path]

struct NavigationMap {

	static let portfolio: NavigationChain = [MainPath.yellow]
	static let profile: NavigationChain = [MainPath.pink]

	static func asset(with id: String) -> [Path] { [MainPath.green(text: id)] }
}
