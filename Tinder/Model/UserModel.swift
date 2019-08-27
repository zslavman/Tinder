//
//  UserModel.swift
//  Tinder
//
//  Created by Zinko Viacheslav on 26.08.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit

protocol ProduceCardViewModelProtocol {
	func toCardViewModel() -> CardViewModel
}

struct UserModel: ProduceCardViewModelProtocol {
	
	let name		: String
	let age			: Int
	let profession	: String
	let imageName	: String
	
	public func toCardViewModel() -> CardViewModel {
		return CardViewModel(imageName: imageName, attributedString: getAttributed, textAlignment: .left)
	}

	private var getAttributed: NSAttributedString {
		let atr = NSMutableAttributedString(string: name, attributes: [
			.font : UIFont.systemFont(ofSize: 22, weight: .bold)
		])
		atr.append(NSAttributedString(string: " \(age) \n", attributes: [
			.font : UIFont.systemFont(ofSize: 18, weight: .semibold)
		]))
		atr.append(NSAttributedString(string: " \(profession)", attributes: [
			.font : UIFont.systemFont(ofSize: 14, weight: .regular)
		]))
		return atr
	}
}
