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
	private let cardViewModels = [
		UserModel(name: "Anything", age: 32, profession: "Cooper", imageName: "sample_00001").toCardViewModel(),
		UserModel(name: "Voilya", age: 25, profession: "Steeler", imageName: "sample_00002").toCardViewModel(),
		UserModel(name: "Ilionora", age: 27, profession: "Morder", imageName: "sample_00003").toCardViewModel(),
		UserModel(name: "Silvara", age: 23, profession: "Holder", imageName: "sample_00004").toCardViewModel(),
		UserModel(name: "Straden", age: 22, profession: "Border", imageName: "sample_00005").toCardViewModel(),
		UserModel(name: "Base", age: 21, profession: "Garder", imageName: "sample_00006").toCardViewModel(),
		UserModel(name: "Polizer", age: 22, profession: "Smiler", imageName: "sample_00007").toCardViewModel(),
		UserModel(name: "Romei", age: 18, profession: "Filler", imageName: "sample_00008").toCardViewModel(),
		UserModel(name: "Chank", age: 24, profession: "Enginer", imageName: "sample_00009").toCardViewModel(),
		UserModel(name: "Glory", age: 33, profession: "Proger", imageName: "sample_00010").toCardViewModel(),
		UserModel(name: "Steny", age: 30, profession: "Bugger", imageName: "sample_00011").toCardViewModel(),
		UserModel(name: "Bloody", age: 20, profession: "Caller", imageName: "sample_00012").toCardViewModel(),
	]

	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		createBars()
		setupCards()
	}
	
	private func createBars() {
		let overAllStack = UIStackView(arrangedSubviews: [topStack, cardsDeckView, bottomStack])
		overAllStack.axis = .vertical
		bottomStack.delegate = self
		
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
		cardViewModels.forEach {
			(cardVM) in
			let cardView = CardView(frame: .zero)
			cardView.imageView.image = UIImage(named: cardVM.imageName)
			cardView.nameLabel.attributedText = cardVM.attributedString
			cardView.nameLabel.textAlignment = cardVM.textAlignment
			cardsDeckView.addSubview(cardView)
			cardView.fillSuperView()
		}
		
		
	}

}

extension HomeController: HomeControllerDelegate {
	
	func onRefreshTap() {
		var allow = true
		cardsDeckView.subviews.forEach {
			(subview) in
			if subview is CardView {
				allow = false
			}
		}
		guard allow else { return }
		setupCards()
	}
	
}
