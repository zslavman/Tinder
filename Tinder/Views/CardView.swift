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
		let translation = gesture.translation(in: nil)
		switch gesture.state {
		case .changed:
			transform = CGAffineTransform(translationX: translation.x, y: translation.y)
		case .ended:
			UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
				self.transform = .identity
			}) {
				(_) in
				
			}
		default: ()
		}
		
	}

}
