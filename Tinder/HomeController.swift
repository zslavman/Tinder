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
	private var cardViewModels: [CardViewModel] = {
		let arr = [
			UserModel(name: "Anything", age: 32, profession: "Cooper", imageName: "sample_00001"),
			UserModel(name: "Voilya", age: 25, profession: "Steeler", imageName: "sample_00002"),
			UserModel(name: "Ilionora", age: 27, profession: "Morder", imageName: "sample_00003"),
			UserModel(name: "Silvara", age: 23, profession: "Holder", imageName: "sample_00004"),
			UserModel(name: "Straden", age: 22, profession: "Border", imageName: "sample_00005"),
			UserModel(name: "Base", age: 21, profession: "Garder", imageName: "sample_00006"),
			UserModel(name: "Polizer", age: 22, profession: "Smiler", imageName: "sample_00007"),
			UserModel(name: "Romei", age: 18, profession: "Filler", imageName: "sample_00008"),
			UserModel(name: "Chank", age: 24, profession: "Enginer", imageName: "sample_00009"),
			UserModel(name: "Steny", age: 30, profession: "Bugger", imageName: "sample_00011"),
			UserModel(name: "Bloody", age: 20, profession: "Caller", imageName: "sample_00012"),
			AdvertiserSample(title: "AdvertiserSample", brandName: "Louis Vuitton", posterPhotoName: "sample_00010")
			] as [ProduceCardViewModelProtocol]
		let vievModels = arr.map{ $0.toCardViewModel()}
		return vievModels
	}()
	


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
		let reversed = cardViewModels.shuffled()
		reversed.forEach {
			(cardVM) in
			let cardView = CardView(frame: .zero)
			cardView.configureWith(cardVM)
			cardView.delegate = self
			cardsDeckView.addSubview(cardView)
			cardView.fillSuperView()
		}
	}

}

extension HomeController: BottomStackViewBarDelegate {
	
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

extension HomeController: CardViewDelegate {
	
	func stopPreviousAnim() {
		cardsDeckView.subviews.forEach {
			(subview) in
			if let entity = subview as? CardView {
				guard entity.canBeDismissed else { return }
				if let anims = entity.layer.animationKeys(), !anims.isEmpty {
					entity.layer.removeAllAnimations()
					entity.removeFromSuperview()
				}
			}
		}
	}
}

