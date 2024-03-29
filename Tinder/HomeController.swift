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
			UserModel(name: "Islands", age: 17, profession: "Arisona", imageNames: [
				"island_0",	"island_1", "island_2", "island_3", "island_4", "island_5",
				"island_6", "island_7", "island_8", "island_9", "island_10", "island_11",
				"island_12", "island_13", "island_14", "island_15", "island_16",
			]),
			UserModel(name: "Forests", age: 7, profession: "NewJersey", imageNames: [
				"forest_0",	"forest_1", "forest_2", "forest_3", "forest_4", "forest_5", "forest_6",
			]),
			UserModel(name: "Lakes", age: 6, profession: "Riverside", imageNames: [
				"lake_0", "lake_1", "lake_2", "lake_3", "lake_4", "lake_5",
			]),
			UserModel(name: "Mountains", age: 5, profession: "Kanzas", imageNames: [
				"mountain_0", "mountain_1", "mountain_2", "mountain_3", "mountain_4",
			]),
			UserModel(name: "Rivers", age: 3, profession: "Uta", imageNames: [
				"river_0", "river_1", "river_2",
			]),
			UserModel(name: "Waterfalls", age: 4, profession: "Oklahoma", imageNames: [
				"waterfall_0", "waterfall_1", "waterfall_2", "waterfall_3",
			]),
			//AdvertiserSample(title: "AdvertiserSample", brandName: "Louis Vuitton", posterPhotoName: "advertiser_poster")
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
		let overAllStack = UIStackView(arrangedSubviews: [/*topStack,*/ cardsDeckView, bottomStack])
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
	
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		if traitCollection.verticalSizeClass == .compact {
			print("Hotizontal device position")
		}
		else {
			print("Vertical device position")
		}
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

