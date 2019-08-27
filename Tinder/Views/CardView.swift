//
//  CardView.swift
//  Tinder
//
//  Created by Zinko Viacheslav on 26.08.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//

import UIKit

protocol CardViewDelegate: class {
	func stopPreviousAnim()
}

class CardView: UIView {
	
	public weak var delegate: CardViewDelegate?
	private let imageView: UIImageView = {
		let img = UIImageView(image: #imageLiteral(resourceName: "sampel"))
		img.contentMode = .scaleAspectFill
		img.layer.cornerRadius = 10
		img.clipsToBounds = true
		return img
	}()
	private let nameLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .white
		label.numberOfLines = 0 // allow multiline
		return label
	}()
	private let threshold: CGFloat = 90 // points for card will fly-away
	public var canBeDismissed = false // fix for dead animation come back
	private let gradientLayer = CAGradientLayer()
	
	
	
	public func configureWith(_ cardVM: CardViewModel) {
		imageView.image = UIImage(named: cardVM.imageName)
		nameLabel.attributedText = cardVM.attributedString
		nameLabel.textAlignment = cardVM.textAlignment
	}
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
		addGradientLayer()
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	private func setup() {
		addSubview(imageView)
		addSubview(nameLabel)
		imageView.fillSuperView()
		NSLayoutConstraint.activate([
			nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
			nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
		])
		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(gesture:)))
		addGestureRecognizer(panGesture)
	}
	
	
	@objc private func onPan(gesture: UIPanGestureRecognizer) {
		switch gesture.state {
		case .began		: delegate?.stopPreviousAnim()
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
		var shouldDismissCard = false
		if abs(gesture.translation(in: nil).x) > threshold || abs(gesture.translation(in: nil).y) > threshold {
			shouldDismissCard = true
			canBeDismissed = true
		}
		UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.99, initialSpringVelocity: 0.1,
					   options: [.curveEaseOut, .allowUserInteraction], animations: {
			if shouldDismissCard {
				// dont use translation, because it have buggie jumping
//				self.frame = CGRect(x: directionalTranslation * 800, y: 0, width: self.superview!.frame.width,
//									height: self.superview!.self.frame.height)
				
				self.transform = CGAffineTransform(translationX: directionalTranslation * 800, y: 200)
//				UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.99, animations: {
//					self.transform = .identity
//				})
			}
			else {
				self.transform = .identity
			}
		}) {
			(_) in
			if shouldDismissCard {
				self.removeFromSuperview()
			}
		}
	}
	
	
	private func addGradientLayer() {
		gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
		gradientLayer.locations = [0.6, 1.1] //0.5 - .clear color start from 50% of screen
		layer.addSublayer(gradientLayer)
		//bringSubviewToFront(nameLabel)
		//gradientLayer.frame = self.frame // in here CardView frame wouldn't be ready
	}
	
	
	override func layoutSubviews() {
		super.layoutSubviews()
		gradientLayer.frame = self.frame // in here you know what CardView frame will be
	}

}
