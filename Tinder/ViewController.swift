//
//  ViewController.swift
//  Tinder
//
//  Created by Zinko Viacheslav on 26.08.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	private let topStack = TopStackViewBar()
	private let middleStack = UIView()
	private let bottomStack = BottomStackViewBar()

	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		createBars()
	}
	
	private func createBars() {
		middleStack.backgroundColor = .blue

		let overAllStack = UIStackView(arrangedSubviews: [topStack, middleStack, bottomStack])
		overAllStack.axis = .vertical
		
		view.addSubview(overAllStack)
		overAllStack.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			overAllStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			overAllStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			overAllStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			overAllStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
		])
	}

}
