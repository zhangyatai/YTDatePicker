//
//  YTDatePicker.swift
//  YTDatePicker
//
//  Created by 油炸豆包 on 2022/9/26.
//

import UIKit

class YTDatePicker: UIView {

    var dateChangedBlock: ((_ date: Date?) -> Void)?
    // 最大日期限制
    open var maximumDate: Date?
    // 最小日期
    open var minmumDate: Date?
    // 文本颜色
    open var textColor: UIColor? = .white
    // 文本字体
    open var textFont: UIFont? = UIFont.systemFont(ofSize: 16, weight: .medium)
    
    enum DateStyle: Int {
        case yearMonthDay
    }
    // 日期类型
    private var style: DateStyle = .yearMonthDay
    // 年数组
    private var years: [String] {
        get {
            var list = [String]()
            for index in 1970..<2050 {
                list.append("\(index)")
            }
            return list
        }
    }
    // 月数组
    private let months: [String] = ["01","02","03","04","05","06","07","08","09","10","11","12"]
    // 日数组
    private var days: [String] {
        get {
            
            var list = [String]()
            
            func setDayArray(num: Int) {
                for index in 1...num {
                    list.append(String(format: "%02d", index))
                }
            }
            
            let yearCount = Int(years[yearIndex]) ?? 0
            let isRunNian = yearCount%4 == 0 ? ((yearCount%100 == 0 ? (yearCount/400 == 0 ? true : false) : true)) : false
            switch Int(months[monthIndex]) {
            case 1,3,5,7,8,10,12:
                setDayArray(num: 31)
            case 4,6,9,11:
                setDayArray(num: 30)
            case 2:
                if isRunNian {
                    setDayArray(num: 29)
                }else {
                    setDayArray(num: 28)
                }
            default: break
            }
            
            return list
        }
    }
    
    // 默认显示的时间
    private var defaultDate: Date = Date() {
        didSet {
            yearIndex = defaultDate.year - 1970
            monthIndex = defaultDate.month - 1
            dayIndex = defaultDate.day - 1
        }
    }
    //记录位置
    private var yearIndex: Int = Date().year - 1970
    private var monthIndex: Int = Date().month - 1
    private var dayIndex: Int = Date().day - 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(datePicker)
        scrollToDate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - lazy
    lazy var datePicker: UIPickerView = {
        let picker = UIPickerView(frame: bounds)
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
}

extension YTDatePicker: UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         getCount()[component]
    }
    private func getCount() -> [Int] {
        switch style {
        case .yearMonthDay:
            return [years.count,months.count,days.count]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        44
    }
}

extension YTDatePicker: UIPickerViewDataSource {
   
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let title: String
        switch style {
        case .yearMonthDay:
            if component == 0 {
                 title = "\(years[row])年"
            }else if component == 1 {
                title = "\(months[row])月"
            }else {
                title = "\(days[row])日"
            }
        }
        let label = UILabel()
        label.textAlignment = .center
        label.text = title
        label.textColor = textColor
        label.font = textFont
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch style {
        case .yearMonthDay:
            if component == 0 {
                yearIndex = row
            }else if component == 1 {
                monthIndex = row
            }else {
                dayIndex = row
            }
        }
        pickerView.reloadAllComponents()
        
        let string = "\(years[yearIndex])-\(months[monthIndex])-\(days[dayIndex])"
        let date = Date.date(time: string)
        
        if let max = maximumDate, let current = date, max.compare(current) == .orderedAscending {
            defaultDate = max
            scrollToDate()
        }
        
        if let min = minmumDate, let current = date, min.compare(current) == .orderedDescending {
            defaultDate = min
           scrollToDate()
        }

        dateChangedBlock?(date)
    }
    
    private func scrollToDate() {
        datePicker.selectRow(yearIndex, inComponent: 0, animated: true)
        datePicker.selectRow(monthIndex, inComponent: 1, animated: true)
        datePicker.selectRow(dayIndex, inComponent: 2, animated: true)
        datePicker.reloadAllComponents()
    }
}


extension Date {
    static let currentCalendar = Calendar.autoupdatingCurrent
    
    var year: Int {
        get {
            Date.currentCalendar.component(.year, from: self)
        }
    }
    var month: Int {
        Date.currentCalendar.component(.month, from: self)
    }
    var day: Int {
        Date.currentCalendar.component(.day, from: self)
    }
    
    static func date(time: String, format: String = "yyyy-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = NSTimeZone.local
        formatter.dateFormat = format
        let date = formatter.date(from: time)
        return date
    }
}
