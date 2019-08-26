//
//  CardView.swift
//  Tinder
//
//  Created by Zinko Viacheslav on 26.08.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit


class CardView: UIView {
	
	private let imageView: UIImageView = {
		let img = UIImageView(image: #imageLiteral(resourceName: "sampel"))
		//img.contentMode = .scaleAspectFill
		img.layer.cornerRadius = 10
		img.clipsToBounds = true
		return img
	}()
	private let threshold: CGFloat = 90 // points for card will fly-away
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		addSubview(imageView)
		imageView.fillSuperView()
		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(gesture:)))
		addGestureRecognizer(panGesture)
	}
	
	@objc private func onPan(gesture: UIPanGestureRecognizer) {
		switch gesture.state {
		case .changed	: onPanChanged(gesture)
		case .ended		: onPanEnded(gesture)
		default			: ()
		}
	}
	
	private func onPanChanged(_ gesture: UIPanGestureRecognizer) {
		let translation = gesture.translation(in: nil)
		let degrees: CGFloat = translation.x / 20
		let angle = degrees * .pi / 180
		let rotationalTransform = CGAffineTransform(rotationAngle: angle)
		transform = rotationalTransform.translatedBy(x: translation.x, y: translation.y)
	}
	
	private func onPanEnded(_ gesture: UIPanGestureRecognizer) {
		let directionalTranslation: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
		let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
		UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1,
					   options: [.curveEaseOut, .allowUserInteraction], animations: {
			if shouldDismissCard {
				// dont use translation, because it have buggie jumping
				self.frame = CGRect(x: directionalTranslation * 800, y: 0, width: self.superview!.frame.width,
									height: self.superview!.self.frame.height)
			}
			else {
				self.transform = .identity
			}
		}) {
			(_) in
			self.transform = .identity
			//self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
		}
	}
	
	
	
	

}
