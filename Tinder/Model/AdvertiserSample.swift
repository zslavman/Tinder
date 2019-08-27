//
//  AdvertiserSample.swift
//  Tinder
//
//  Created by Zinko Viacheslav on 27.08.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit

struct AdvertiserSample: ProduceCardViewModelProtocol {
	
	let title: String
	let brandName: String
	let posterPhotoName: String
	
	
	public func toCardViewModel() -> CardViewModel {
		let atr = NSMutableAttributedString(string: " \(title) \n", attributes: [
			.font : UIFont.systemFont(ofSize: 32, weight: .heavy)
			])
		atr.append(NSAttributedString(string: " \(brandName)", attributes: [
			.font : UIFont.systemFont(ofSize: 20, weight: .semibold)
			]))
		return CardViewModel(imageName: posterPhotoName, attributedString: atr, textAlignment: .center)
	}
	
}
