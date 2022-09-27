//
//  ViewController.swift
//  YTDatePicker
//
//  Created by 油炸豆包 on 2022/9/26.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 32/255.0, green: 32/255.0, blue: 34/255.0, alpha: 1)
        let picker = YTDatePicker(frame: CGRect(x: 20, y: 100, width: UIScreen.main.bounds.width - 40, height: 190))
        picker.maximumDate = Date()
        view.addSubview(picker)
        picker.dateChangedBlock = { date in
            let formatter = DateFormatter()
            //日期样式
            formatter.dateFormat = "yyyy-MM-dd"
            guard let date = date else {
                return
            }
            let string = formatter.string(from: date)
            debugPrint("\(string)")
        }
        
    }
}

