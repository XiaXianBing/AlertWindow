//
//  ViewController.swift
//  AlertWindow
//
//  Created by XiaXianBing on 2016-10-27.
//  Copyright © 2016年 XiaXianBing. All rights reserved.
//

import UIKit
import AlertWindow

class ViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "AlertWindow"
	}
}


// MARK: -
// MARK: UITableViewDataSource && UITableViewDelegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
	
	public func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 36.0
	}
	
	public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0.0
	}
	
	public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "Alert View"
		} else if section == 1 {
			return "Action Sheet"
		}
		return ""
	}
	
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 4
	}
	
	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 48.0
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let identifier: String = "AlertWindowCellID"
		var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
		if cell == nil {
			cell = Bundle.main.loadNibNamed("UITableViewCell", owner: self, options: nil)?.last as? UITableViewCell
		}
		if indexPath.row == 0 {
			cell?.textLabel?.text = "No Action"
		} else if indexPath.row == 1 {
			cell?.textLabel?.text = "One Action"
		} else if indexPath.row == 2 {
			cell?.textLabel?.text = "Two Action"
		} else if indexPath.row == 3 {
			cell?.textLabel?.text = "Three Action"
		}
		return cell!
	}
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		var style: UIAlertControllerStyle = .alert
		if indexPath.section == 1 {
			style = .actionSheet
		}
		let alert = AlertWindow(title: "开启定位服务", message: "检测到您没有开启定位服务, 无法正常定位。开启定位服务后, 才能查看您当前位置距门店距离以及导航信息。", style: style)
		let action0 = AlertAction(title: "立即开启", style: .cancel, handler: { _ in
			print("立即开启")
		})
		let action1 = AlertAction(title: "暂不开启", style: .destructive, handler: { _ in
			print("暂不开启")
		})
		let action2 = AlertAction(title: "取消", style: .cancel, handler: { _ in
			print("取消")
		})
		
		if indexPath.row == 0 {
		} else if indexPath.row == 1 {
			alert.addAction(action1)
		} else if indexPath.row == 2 {
			alert.addAction(action0)
			alert.addAction(action1)
		} else if indexPath.row == 3 {
			alert.addAction(action0)
			alert.addAction(action1)
			alert.addAction(action2)
		}
		self.present(alert, animated: false, completion: nil)
	}
}

