//
//  TopStackViewBar.swift
//  Tinder
//
//  Created by Zinko Viacheslav on 26.08.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit

class TopStackViewBar: UIStackView {
	
	private let settingsBttn: UIButton = {
		let bttn = UIButton(type: .system)
		bttn.setImage(#imageLiteral(resourceName: "icon_persone").withRenderingMode(.alwaysOriginal), for: .normal)
		return bttn
	}()
	private let messageBttn: UIButton = {
		let bttn = UIButton(type: .system)
		bttn.setImage(#imageLiteral(resourceName: "icon_bubbles").withRenderingMode(.alwaysOriginal), for: .normal)
		return bttn
	}()
	private let fireImageView: UIImageView = {
		let im = UIImageView(image: #imageLiteral(resourceName: "icon_fire"))
		im.contentMode = .scaleAspectFit
		return im
	}()
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	private func setup() {
		distribution = .equalCentering
		_ = [settingsBttn, fireImageView, messageBttn].map{ addArrangedSubview($0) }
		isLayoutMarginsRelativeArrangement = true // for next line working
		layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
		heightAnchor.constraint(equalToConstant: 80).isActive = true
	}
	
	
}
