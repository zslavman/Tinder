//
//  CardViewModel.swift
//  Tinder
//
//  Created by Zinko Viacheslav on 27.08.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit

class CardViewModel {
	let imageNames: [String]
	let attributedString: NSAttributedString
	let textAlignment: NSTextAlignment
	private var imageIndex = 0
	
	
	init(imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
		self.imageNames = imageNames
		self.attributedString = attributedString
		self.textAlignment = textAlignment
	}
	
	// little bit of reactive programming - notification clossure
	public var imageIndexObserver: ((Int, UIImage?) -> ())?
	
	
	public func goToNextPhoto() {
		imageIndex = min(imageIndex + 1, imageNames.count - 1)
		notifyExternalView()
	}
	
	public func goToPrevPhoto() {
		imageIndex = max(imageIndex - 1, 0)
		notifyExternalView()
	}
	
	private func notifyExternalView() {
		let image = UIImage(named: imageNames[imageIndex])
		imageIndexObserver?(imageIndex, image)
	}
	
}
