//
//  CardView.swift
//  Tinder
//
//  Created by Zinko Viacheslav on 26.08.2019.
//  Copyright © 2019 Zinko Viacheslav. All rights reserved.
//  marcosantadev.com/calayer-auto-layout-swift/

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
	private let gradientLayer: CAGradientLayer = {
		let gragLayer = CAGradientLayer()
		gragLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
		gragLayer.locations = [0.6, 1.1] //0.5 - .clear color start from 50% of screen
		return gragLayer
	}()
	private let barsStackView: UIStackView = {
		let sv = UIStackView()
		sv.translatesAutoresizingMaskIntoConstraints = false
		sv.axis = .vertical
		return sv
	}()
	
	
	
	public func configureWith(_ cardVM: CardViewModel) {
		let imageName = cardVM.imageNames.first ?? ""
		imageView.image = UIImage(named: imageName)
		nameLabel.attributedText = cardVM.attributedString
		nameLabel.textAlignment = cardVM.textAlignment
	}
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
		setupBarsStackView()
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	private func setup() {
		addSubview(imageView)
		layer.addSublayer(gradientLayer)
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
	
	
	private func setupBarsStackView() {
		addSubview(barsStackView)
		NSLayoutConstraint.activate([
			barsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
			barsStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
			barsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
			barsStackView.heightAnchor.constraint(equalToConstant: 5),
		])
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
		let translation = gesture.translation(in: nil)
		let degrees: CGFloat = translation.x / 8
		let angle = degrees * .pi / 180
		
		// dismiss animation
		if shouldDismissCard {
			// 1) fix buggie jumping on start animation (on case 2)
			UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: [.calculationModeCubicPaced], animations: {
				UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3, animations: {
					self.transform = CGAffineTransform(rotationAngle: angle).translatedBy(x: directionalTranslation * 800, y: -300)
				})
			}, completion: {
				(_) in
				self.removeFromSuperview()
			})
			// 2)
			//			UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5,
			//						   options: [.curveEaseOut, .allowUserInteraction], animations: {
			//							self.frame.origin.x = directionalTranslation * 800
			//							// if use translation - it create buggie jumping on start animation
			//							//self.transform = CGAffineTransform(translationX: directionalTranslation * 800, y: 0)
			//			}, completion: {
			//				(_) in
			//				self.removeFromSuperview()
			//			})
		}
		// comeback animation
		else {
			UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5,
						   options: [.curveEaseOut, .allowUserInteraction], animations: {
				self.transform = .identity
			})
		}
	}
	
	
	override func layoutSubviews() {
		super.layoutSubviews()
		// set frame for gradient layer, in here you know what CardView frame will be
		// but, when animation is going on - gradient will hide immediately
		//gradientLayer.frame = self.frame
		
		gradientLayer.frame = self.bounds // fix for gradient disappearance
		layoutIfNeeded()
	}

}
