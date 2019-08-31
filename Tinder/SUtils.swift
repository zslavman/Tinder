//
//  Calculations.swift
//  ChatApp
//
//  Created by Zinko Vyacheslav on 02.12.2018.
//  Copyright © 2018 Zinko Vyacheslav. All rights reserved.
//

import Foundation
import UIKit

struct SUtils {
	
	public static func convertDate(date: Date) -> String {
		let dateFormater = DateFormatter()
		dateFormater.locale = Locale(identifier: "RU")
		dateFormater.dateFormat = "dd"
		let numDay = dateFormater.string(from: date)
		var month = dateFormater.shortMonthSymbols[Calendar.current.component(.month, from: date) - 1]
		if month.last == "." {
			month = String(month.dropLast())
		}
		dateFormater.dateFormat = "yyyy"
		let year = dateFormater.string(from: date)
		return "\(numDay) \(month) \(year)"
	}
	
	
	static func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
		let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		UIGraphicsBeginImageContextWithOptions(size, false, 0)
		color.setFill()
		UIRectFill(rect)
		let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return image
	}
	
	
	static func alert(message: String, title: String = "", completion: (() -> ())?) -> UIAlertController {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let OK_action = UIAlertAction(title: "OK", style: .default, handler: {
			(action) in
			if let completion = completion {
				completion()
			}
		})
		alertController.addAction(OK_action)
		return alertController
	}
	
	
	public static func linkParser (url: URL) -> [String:String] {
		var dict = [String:String]()
		let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
		if let queryItems = components.queryItems {
			for item in queryItems {
				dict[item.name] = item.value!
			}
		}
		return dict
	}
	
	
	public static func printDictionary(dict:[String:Any]) {
		dict.forEach { print("\($0.key) = \($0.value)")}
	}
	
	
	/// Возвращает рандомное число между min и max
	public static func random(_ min: Int, _ max: Int) -> Int {
		guard min < max else {return min}
		return Int(arc4random_uniform(UInt32(1 + max - min))) + min
	}
	
	
	// расстояние между дкумя точками
	public func distanceCalc(a:CGPoint, b:CGPoint) -> CGFloat{
		return sqrt(pow((b.x - a.x), 2) + pow((b.y - a.y), 2))
	}
	
	// пересчет времени передвижения при различных расстояниях
	public func timeToTravelDistance(distance:CGFloat, speed:CGFloat) -> TimeInterval{
		let time = distance / speed
		return TimeInterval(time)
	}
	
	
	// получение текущего DateComponents
	public static func getDateComponent(fromDate:Date = Date()) -> DateComponents{
		let calendar = Calendar(identifier: .gregorian)
		let components = calendar.dateComponents([.month, .day, .hour, .minute, .second], from: fromDate)
		return components
	}
	
	
	/// Play taptic feedback
	///
	/// - Parameter state: touch-state for avoid re-triggering
	public static func tapticFeedback(state: UIGestureRecognizer.State? = nil) {
		if state != nil {
			guard state == .began else { return }
		}
		let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
		impactFeedbackgenerator.prepare()
		impactFeedbackgenerator.impactOccurred()
		// more sensetive feedback with 3 cases:
		//let generator = UINotificationFeedbackGenerator()
		//generator.notificationOccurred(.success)
	}
	
	
	public static func sizeFromUrl(url: URL?) -> String {
		guard let filePath = url?.path else {
			return "0 Mb"
		}
		guard let attribute = try? FileManager.default.attributesOfItem(atPath: filePath),
			let bytes = (attribute[FileAttributeKey.size] as? NSNumber)?.int64Value else { return "0 Mb" }
		return sizeFromBytes(bytes: bytes)
	}
	
	
	public static func sizeFromBytes(bytes: Int64) -> String {
		let formatter = ByteCountFormatter()
		formatter.allowedUnits 	= ByteCountFormatter.Units.useMB
		formatter.countStyle 	= ByteCountFormatter.CountStyle.decimal
		formatter.includesUnit 	= false
		let sizeInMb = formatter.string(fromByteCount: bytes)
		return "\(sizeInMb) Mb"
	}
	
	
	public static func resizeImage(_ image: UIImage, toSize: CGSize) -> UIImage {
		let size = image.size
		let widthRatio  = toSize.width  / size.width
		let heightRatio = toSize.height / size.height
		
		// Figure out what our orientation is, and use that to form the rectangle
		var newSize: CGSize
		if(widthRatio > heightRatio) {
			newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
		} else {
			newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
		}
		// This is the rect that we've calculated out and this is what is actually used below
		let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
		
		// Actually do the resizing to the rect using the ImageContext stuff
		UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
		image.draw(in: rect)
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return newImage!
	}
	
	
	/// Resize image proportionally
	///
	/// - Parameters:
	///   - image: source
	///   - firstOutSide: required size of the output side
	///   - isMin: if true - firstOutSide will be min, else - max
	public static func resizeImage(_ image: UIImage, firstOutSide: CGFloat, isMin: Bool) -> UIImage {
		let size = image.size
		let isLandscape = size.width > size.height
		let origMinSide = min(size.width, size.height)
		let origMaxSide = max(size.width, size.height)
		let ratio = origMaxSide / origMinSide // > 0
		var secondOutSide = ratio * firstOutSide
		if !isMin {
			secondOutSide = firstOutSide / ratio
		}
		
		var newSize: CGSize
		if (isLandscape && isMin) || (!isLandscape && !isMin) {
			newSize = CGSize(width: secondOutSide, height: firstOutSide)
		}
		else {
			newSize = CGSize(width: firstOutSide,  height: secondOutSide)
		}
		
		let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
		UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
		image.draw(in: rect)
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return newImage!
	}
	
	
	/// cropping image using it minimal side -> return centered, croped image
	public static func squareCropping(image: UIImage) -> UIImage {
		let cgimage = image.cgImage!
		let contextImage = UIImage(cgImage: cgimage)
		let contextSize: CGSize = contextImage.size
		var posX: CGFloat = 0
		var posY: CGFloat = 0
		
		let minSide = min(image.size.width, image.size.height)
		var cgwidth = CGFloat(minSide)
		var cgheight = CGFloat(minSide)
		
		// See what size is longer and create the center off of that
		if contextSize.width > contextSize.height {
			posX = ((contextSize.width - contextSize.height) / 2)
			posY = 0
			cgwidth = contextSize.height
			cgheight = contextSize.height
		}
		else {
			posX = 0
			posY = ((contextSize.height - contextSize.width) / 2)
			cgwidth = contextSize.width
			cgheight = contextSize.width
		}
		let cropRect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
		
		// Create bitmap image from context using the rect
		let imageRef: CGImage = cgimage.cropping(to: cropRect)!
		
		// Create a new image based on the imageRef and rotate back to the original orientation
		let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
		
		return image
	}
	
	
	
	/// Prevent backup files on iCloud
	///
	/// - Parameter localUrl: local Url-link of file
	public static func iCloudPreventBackupFile(localUrl: URL?) {
		guard let localUrl = localUrl else {
			print("given file URL is not valid!")
			return
		}
		var _localUrl = localUrl
		do {
			var resourceValues = URLResourceValues()
			resourceValues.isExcludedFromBackup = true
			try _localUrl.setResourceValues(resourceValues)
		} catch {
			print(error.localizedDescription)
		}
	}
	
	
	/// bad - masked view willbe without mask
	public static func viewToImage(view: UIView) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0)
		defer { UIGraphicsEndImageContext() }
		view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
		return UIGraphicsGetImageFromCurrentImageContext()
	}
	
	
}


//****************************************************************************************************


extension UIView {
	
	public func fillSuperView(padding: UIEdgeInsets = .zero){
		translatesAutoresizingMaskIntoConstraints = false
		if let superviewTopAnchor = superview?.topAnchor { // >0 не работает
			topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
		}
		if let superviewBottomAnchor = superview?.bottomAnchor { // >0 не работает
			bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
		}
		if let superviewLeadingAnchor = superview?.leadingAnchor {
			leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
		}
		if let superviewTrailingAnchor = superview?.trailingAnchor {
			trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
		}
	}
	
	func centerInView(_ view: UIView) {
		translatesAutoresizingMaskIntoConstraints = false
		let constraints: [NSLayoutConstraint] = [
			centerXAnchor.constraint(equalTo: view.centerXAnchor),
			centerYAnchor.constraint(equalTo: view.centerYAnchor)
		]
		NSLayoutConstraint.activate(constraints)
	}
	
	func centerInSuperview(size: CGSize = .zero) {
		translatesAutoresizingMaskIntoConstraints = false
		if let superviewCenterXAnchor = superview?.centerXAnchor {
			centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
		}
		if let superviewCenterYAnchor = superview?.centerYAnchor {
			centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
		}
		if size.width != 0 {
			widthAnchor.constraint(equalToConstant: size.width).isActive = true
		}
		if size.height != 0 {
			heightAnchor.constraint(equalToConstant: size.height).isActive = true
		}
	}
	
	@discardableResult
	func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
		translatesAutoresizingMaskIntoConstraints = false
		var anchoredConstraints = AnchoredConstraints()
		
		if let top = top {
			anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
		}
		if let leading = leading {
			anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
		}
		if let bottom = bottom {
			anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
		}
		if let trailing = trailing {
			anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
		}
		if size.width != 0 {
			anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
		}
		if size.height != 0 {
			anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
		}
		[anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach{ $0?.isActive = true }
		
		return anchoredConstraints
	}

}


struct AnchoredConstraints {
	var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}


extension UIImage { // bad - can see pixels
	convenience init(view: UIView) {
		UIGraphicsBeginImageContext(view.frame.size)
		view.layer.render(in: UIGraphicsGetCurrentContext()!)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		self.init(cgImage: image!.cgImage!)
	}
}


extension UIViewController {
	
	// present VC on top level (above keyboard, eg.)
	func presentAboveAll() {
		let win = UIWindow(frame: UIScreen.main.bounds)
		let vc = UIViewController()
		vc.view.backgroundColor = .clear
		win.rootViewController = vc
		win.windowLevel = .alert + 1
		win.makeKeyAndVisible()
		vc.present(self, animated: true, completion: nil)
	}
}


extension String {
	
	var localized: String {
		return NSLocalizedString(self, comment: "")
	}
	
}



/// Create visual effect view with given effect and its intensity
class CustomIntensityVisualEffectView: UIVisualEffectView {
	
	var timer: Timer?
	private var animator: UIViewPropertyAnimator!
	
	///   - effect: visual effect, eg UIBlurEffect(style: .dark)
	///   - intensity: custom intensity from 0.0 (no effect) to 1.0 (full effect) using linear scale
	init(effect: UIVisualEffect, intensity: CGFloat) {
		super.init(effect: nil)
		animator = UIViewPropertyAnimator(duration: 1, curve: .linear) {
			[unowned self] in
			self.effect = effect
		}
		let step = intensity / 10 // devide animation to 10 steps
		
		// run timer, vich will smoothly animate blur effect
		timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true, block: {
			(_) in
			self.animator.fractionComplete += step
			if self.animator.fractionComplete >= intensity {
				self.timer?.invalidate()
			}
		})
	}
	
	deinit {
		timer?.invalidate()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}
	
}
