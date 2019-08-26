//
//  StackViewBarButtons.swift
//  Tinder
//
//  Created by Zinko Viacheslav on 26.08.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit

protocol BottomStackViewBarDelegate: class {
	func onRefreshTap()
}

class BottomStackViewBar: UIStackView {
	
	public weak var delegate: BottomStackViewBarDelegate?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		let refreshBttn = UIButton(type: .system)
		refreshBttn.addTarget(self, action: #selector(onRefreshTap), for: .touchUpInside)
		refreshBttn.setImage(#imageLiteral(resourceName: "icon_refresh").withRenderingMode(.alwaysOriginal), for: .normal)
		addArrangedSubview(refreshBttn)
		
		_ = [#imageLiteral(resourceName: "icon_dismiss"), #imageLiteral(resourceName: "icon_star"), #imageLiteral(resourceName: "icon_heart"), #imageLiteral(resourceName: "icon_flash")].map {
			(img) -> UIButton in
			let bttn = UIButton(type: .system)
			bttn.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
			addArrangedSubview(bttn)
			return bttn
		}
		distribution = .fillEqually
		heightAnchor.constraint(equalToConstant: 80).isActive = true
	}
	
	@objc private func onRefreshTap() {
		delegate?.onRefreshTap()
	}
	
	
}
