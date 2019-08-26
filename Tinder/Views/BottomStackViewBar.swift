//
//  StackViewBarButtons.swift
//  Tinder
//
//  Created by Zinko Viacheslav on 26.08.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit

class BottomStackViewBar: UIStackView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		let subviews = [#imageLiteral(resourceName: "icon_refresh"), #imageLiteral(resourceName: "icon_dismiss"), #imageLiteral(resourceName: "icon_star"), #imageLiteral(resourceName: "icon_heart"), #imageLiteral(resourceName: "icon_flash")].map {
			(img) -> UIButton in
			let bttn = UIButton(type: .system)
			bttn.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
			return bttn
		}
		subviews.forEach {
			(v) in
			addArrangedSubview(v)
		}
		distribution = .fillEqually
		heightAnchor.constraint(equalToConstant: 80).isActive = true
	}
	
	
}
