//
//  ViewController.swift
//  Tinder
//
//  Created by Zinko Viacheslav on 26.08.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
	
	private let topStack = TopStackViewBar()
	private let cardsDeckView = UIView()
	private let bottomStack = BottomStackViewBar()

	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		createBars()
		setupCards()
	}
	
	private func createBars() {
		let overAllStack = UIStackView(arrangedSubviews: [topStack, cardsDeckView, bottomStack])
		overAllStack.axis = .vertical
		
		view.addSubview(overAllStack)
		overAllStack.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			overAllStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			overAllStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			overAllStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			overAllStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
		])
		overAllStack.isLayoutMarginsRelativeArrangement = true
		overAllStack.layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 10)
		overAllStack.bringSubviewToFront(cardsDeckView)
	}
	
	private func setupCards() {
		let cardView = CardView(frame: .zero)
		cardsDeckView.addSubview(cardView)
		cardView.fillSuperView()
	}

}
