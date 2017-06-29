//
//  AlertWindow.swift
//  AlertWindow
//
//  Created by XiaXianBing on 2016-10-27.
//  Copyright © 2016年 XiaXianBing. All rights reserved.
//

import UIKit

public class AlertAction: NSObject {
	
	private var font: UIFont?
	private var color: UIColor?
	
	private var title: String = ""
	private var style: UIAlertActionStyle = .default
	private var handler: (() -> Void)?
	private var completion: (() -> Void)?
	
	public init(title: String, style: UIAlertActionStyle, handler:(() -> Void)?) {
		self.title = title
		self.style = style
		self.handler = handler
	}
	
	fileprivate func draw(_ parent: UIView, frame: CGRect, completion: (() -> Void)?) {
		self.completion = completion
		let button = UIButton(frame: frame)
		button.titleLabel?.font = self.textFont()
		button.setTitle(self.title, for: .normal)
		button.setTitleColor(self.textColor(), for: .normal)
		button.backgroundColor = UIColor.white
		button.setBackgroundImage(self.imageWithColor(UIColor.white), for: .normal)
		button.setBackgroundImage(self.imageWithColor(UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)), for: .highlighted)
		button.addTarget(self, action: #selector(self.didAlertButtonClick), for: .touchUpInside)
		parent.addSubview(button)
	}
	
	@objc private func didAlertButtonClick() {
		self.handler?()
		self.completion?()
	}
	
	private func textFont() -> UIFont {
		if self.font != nil {
			return self.font!
		}
		
		switch self.style {
		case .default:
			return UIFont.systemFont(ofSize: 17.0)
		case .cancel:
			return UIFont.systemFont(ofSize: 17.0)
		case .destructive:
			return UIFont.systemFont(ofSize: 17.0)
		}
	}
	
	private func textColor() -> UIColor {
		if self.color != nil {
			return self.color!
		}
		
		switch self.style {
		case .default:
			return UIColor(red: 46.0/255.0, green: 48.0/255.0, blue: 52.0/255.0, alpha: 1.0)
		case .cancel:
			return UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
		case .destructive:
			return UIColor(red: 230.0/255.0, green: 60.0/255.0, blue: 48.0/255.0, alpha: 1.0)
		}
	}
	
	private func imageWithColor(_ color: UIColor) ->UIImage {
		let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
		color.setFill()
		UIRectFill(rect)
		let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return image
	}
}

public class AlertWindow: UIViewController {
	
	private var alertTitle: String?
	private var message: String?
	private var style: UIAlertControllerStyle = .alert
	private var actions = [AlertAction]()
	
	private var window = UIWindow()
	private var background = UIImageView()
	private var contentView = UIVisualEffectView()
	
	private var isAnimation: Bool = false
	
	public init(title: String?, message: String?, style: UIAlertControllerStyle) {
		super.init(nibName: nil, bundle: nil)
		
		self.alertTitle = title
		self.message = message
		self.style = style
		self.modalPresentationStyle = .overCurrentContext
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: -
	// MARK: Orrvide
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.clear
		self.window = UIWindow(frame: UIScreen.main.bounds)
		self.window.windowLevel = UIWindowLevelStatusBar
		self.window.backgroundColor = UIColor.clear
		self.window.isHidden = false
		self.background = UIImageView(frame: self.window.bounds)
		self.background.backgroundColor = UIColor.black
		self.background.alpha = 0.0
		self.window.addSubview(self.background)
		let contentButton = UIButton(type: UIButtonType.custom)
		contentButton.frame = self.window.bounds
		contentButton.backgroundColor = UIColor.clear
		contentButton.addTarget(self, action: #selector(didContentButtonClick(_:)), for: UIControlEvents.touchUpInside)
		self.window.addSubview(contentButton)
		
		self.contentView = UIVisualEffectView()
		self.contentView.effect = UIBlurEffect(style: UIBlurEffectStyle.light)
		self.contentView.backgroundColor = UIColor.white
		self.window.addSubview(self.contentView)
		self.initContentView()
	}
	
	public override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.show()
	}
	
	
	// MARK: -
	// MARK: Requried
	
	private func initContentView() {
		self.contentView.alpha = 0.0
		var contentHeight: CGFloat = 0.0
		if self.style == .alert {
			contentHeight = 32.0
			self.contentView.frame = CGRect.init(x: 32.0, y: self.window.frame.size.height, width: self.window.frame.size.width - 2 * 32.0, height: 0.0)
		} else if self.style == .actionSheet {
			contentHeight = 20.0
			self.contentView.frame = CGRect.init(x: 0.0, y: self.window.frame.size.height, width: self.window.frame.size.width, height: 0.0)
		}
		let titleView = UIView()
		titleView.backgroundColor = UIColor.white
		let titleLabel = UILabel(frame: CGRect(x: 32.0, y: contentHeight, width: self.contentView.frame.size.width - 2 * 32.0, height: CGFloat.greatestFiniteMagnitude))
		titleLabel.numberOfLines = 0
		titleLabel.textAlignment = .center
		titleLabel.lineBreakMode = .byWordWrapping
		titleLabel.font = UIFont.systemFont(ofSize: 17.0)
		titleLabel.textColor = UIColor(red: 46.0/255.0, green: 48.0/255.0, blue: 52.0/255.0, alpha: 1.0)
		titleLabel.text = self.alertTitle ?? ""
		titleLabel.sizeToFit()
		if titleLabel.frame.size.height != 0.0 {
			titleLabel.frame = CGRect(x: 32.0, y: contentHeight, width: self.contentView.frame.size.width - 2 * 32.0, height: titleLabel.frame.size.height)
			titleView.addSubview(titleLabel)
			contentHeight += titleLabel.frame.size.height
			contentHeight += 10.0
		}
		
		let messageLabel = UILabel(frame: CGRect(x: 20.0, y: contentHeight, width: self.contentView.frame.size.width - 2 * 20.0, height: CGFloat.greatestFiniteMagnitude))
		messageLabel.numberOfLines = 0
		messageLabel.textAlignment = .center
		messageLabel.lineBreakMode = .byWordWrapping
		messageLabel.font = UIFont.systemFont(ofSize: 13.0)
		messageLabel.textColor = UIColor(red: 136.0/255.0, green: 136.0/255.0, blue: 136.0/255.0, alpha: 1.0)
		messageLabel.text = self.message ?? ""
		messageLabel.sizeToFit()
		if messageLabel.frame.size.height != 0.0 {
			messageLabel.frame = CGRect(x: 20.0, y: contentHeight, width: self.contentView.frame.size.width - 2 * 20.0, height: messageLabel.frame.size.height)
			titleView.addSubview(messageLabel)
			contentHeight += messageLabel.frame.size.height
			contentHeight += 20.0
		} else {
			contentHeight += 10.0
		}
		
		if self.style == .alert && self.actions.count == 0 {
			contentHeight += 12.0
		}
		titleView.frame = CGRect(x: 0.0, y: 0.0, width: self.contentView.frame.size.width, height: contentHeight)
		self.contentView.addSubview(titleView)
		if self.actions.count != 0 && (titleLabel.frame.size.height != 0.0 || messageLabel.frame.size.height != 0.0) {
			let divideView = UIImageView(frame: CGRect(x: 0.0, y: contentHeight, width: self.contentView.frame.size.width, height: 0.5))
			divideView.backgroundColor = UIColor(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1.0)
			self.contentView.addSubview(divideView)
			contentHeight += 0.5
		} else {
			contentHeight += 0.0
		}
		
		if self.style == .alert {
			if self.actions.count == 2 {
				var action = self.actions[0]
				action.draw(self.contentView, frame: CGRect(x: 0.0, y: contentHeight, width: self.contentView.frame.size.width/2.0, height: 50.0), completion: { [weak self] in
					self?.hidden()
				})
				let divideView = UIImageView()
				divideView.backgroundColor = UIColor(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1.0)
				divideView.frame = CGRect(x: self.contentView.frame.size.width/2.0, y: contentHeight, width: 0.5, height: 50.0)
				self.contentView.addSubview(divideView)
				action = self.actions[1]
				action.draw(self.contentView, frame: CGRect(x: self.contentView.frame.size.width/2.0 + 0.5, y: contentHeight, width: self.contentView.frame.size.width/2.0 - 0.5, height: 50.0), completion: { [weak self] in
					self?.hidden()
				})
				contentHeight += 50.0
			} else {
				for index in 0 ..< self.actions.count {
					let action = self.actions[index]
					action.draw(self.contentView, frame: CGRect(x: 0.0, y: contentHeight, width: self.contentView.frame.size.width, height: 50.0), completion: { [weak self] in
						self?.hidden()
					})
					contentHeight += 50.0
					
					if index != self.actions.count - 1 {
						let divideView = UIImageView()
						divideView.backgroundColor = UIColor(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1.0)
						divideView.frame = CGRect(x: 0.0, y: contentHeight, width: self.contentView.frame.size.width, height: 0.5)
						contentHeight += 0.5
						self.contentView.addSubview(divideView)
					}
				}
			}
			self.contentView.layer.cornerRadius = 12.0
			self.contentView.layer.masksToBounds = true
			self.contentView.frame = CGRect(x: self.contentView.frame.origin.x, y: (self.window.frame.size.height - contentHeight)/2.0, width: self.contentView.frame.size.width, height: contentHeight)
		} else if self.style == .actionSheet {
			for index in 0 ..< self.actions.count {
				let action = self.actions[index]
				action.draw(self.contentView, frame: CGRect(x: 0.0, y: contentHeight, width: self.contentView.frame.size.width, height: 50.0), completion: { [weak self] in
					self?.hidden()
				})
				contentHeight += 50.0
				
				if index != self.actions.count - 1 {
					let divideView = UIImageView()
					if self.actions.count > 1 && index == self.actions.count - 2 {
						divideView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
						divideView.frame = CGRect(x: 0.0, y: contentHeight, width: self.contentView.frame.size.width, height: 8.0)
						contentHeight += 8.0
					} else {
						divideView.backgroundColor = UIColor(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1.0)
						divideView.frame = CGRect(x: 0.0, y: contentHeight, width: self.contentView.frame.size.width, height: 0.5)
						contentHeight += 0.5
					}
					self.contentView.addSubview(divideView)
				}
			}
			self.contentView.frame = CGRect(x: 0.0, y: self.window.frame.size.height, width: self.contentView.frame.size.width, height: contentHeight + 60.0)
		}
	}
	
	@objc private func didContentButtonClick(_ sender: UIButton) {
		if self.style == .alert && self.actions.count != 0 {
			return
		}
		self.hidden()
	}
	
	
	// MARK: -
	// MARK: Public
	
	public func addAction(_ action: AlertAction) {
		self.actions.append(action)
	}
	
	
	// MARK: -
	// MARK: Private
	
	private func show() {
		if self.isAnimation {
			return
		}
		self.isAnimation = true
		self.background.alpha = 0.0
		self.contentView.alpha = (self.style == .alert) ? 0.0 : 1.0
		UIView.animate(withDuration: 0.32, delay: 0.0, options: .curveEaseInOut, animations: {
			self.background.alpha = 0.5
			if self.style == .alert {
				self.contentView.alpha = 1.0
			} else if self.style == .actionSheet {
				self.contentView.frame = CGRect.init(x: 0.0, y: self.window.frame.size.height - self.contentView.frame.size.height + 60.0, width: self.window.frame.size.width, height: self.contentView.frame.size.height)
			}
		}, completion: { (finish) in
			self.isAnimation = false
		})
	}
	
	private func hidden() {
		if self.isAnimation {
			return
		}
		self.isAnimation = true
		UIView.animate(withDuration: 0.32, delay: 0.0, options: .curveEaseInOut, animations: {
			self.background.alpha = 0.0
			if self.style == .alert {
				self.contentView.alpha = 0.0
			} else if self.style == .actionSheet {
				self.contentView.frame = CGRect.init(x: 0.0, y: self.window.frame.size.height, width: self.window.frame.size.width, height: self.contentView.frame.size.height)
			}
		}, completion: { (finish) in
			self.isAnimation = false
			self.dismiss(animated: false, completion: nil)
		})
	}
}
