//
//  YFCalendarWeekdayHeaderView.swift
//  YFCalendar
//
//  Created by 于帆 on 2017/5/3.
//  Copyright © 2017年 JasonYu. All rights reserved.
//

import UIKit

enum YFCalendarWeekdayTextType {
    case short
    case VeryShort
    case standAlone
}

class YFCalendarWeekdayHeaderView: UIView {
    
    init(calendar: Calendar, weekdayTextType: YFCalendarWeekdayTextType) {
        // 自定义初始化方法必须调用super.init
        super.init(frame: .null)
        
        self.backgroundColor = UIColor.white
        
        let weekdaySymbolsText = self.weekdaySymbols(calendar: calendar, weekdayTextType: weekdayTextType)
        
        var firstWeekdaySymbolLabel: UILabel?
        
        var dayNameArr: [String] = []
        var labelDict: [String: UILabel] = [:]
        
        for i in 0..<weekdaySymbolsText.count {
            let labelName = "weekdaySymbolLabel\(i)"
            dayNameArr.append(labelName)
            
            let dayLabel = UILabel()
            dayLabel.font = UIFont.systemFont(ofSize: 12)
            dayLabel.text = weekdaySymbolsText[i].uppercased()
            dayLabel.textColor = UIColor.black
            dayLabel.textAlignment = .center
            dayLabel.backgroundColor = UIColor.clear
            dayLabel.translatesAutoresizingMaskIntoConstraints = false
            
            labelDict[labelName] = dayLabel
            self.addSubview(dayLabel)
            
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[\(labelName)]|", options: .directionLeadingToTrailing, metrics: nil, views: labelDict))
            
            if firstWeekdaySymbolLabel == nil {
                firstWeekdaySymbolLabel = dayLabel
            } else {
                // constraints -- equal width with the firstLabel
                self.addConstraint(NSLayoutConstraint.init(item: dayLabel, attribute: .width, relatedBy: .equal, toItem: firstWeekdaySymbolLabel, attribute: .width, multiplier: 1.0, constant: 0))
            }
        }
        
        let layoutString = "|[\(dayNameArr.joined(separator: "]["))(>=0)]|"
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: layoutString, options: .alignAllCenterY, metrics: nil, views: labelDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

fileprivate extension YFCalendarWeekdayHeaderView {
    
    func weekdaySymbols(calendar: Calendar, weekdayTextType: YFCalendarWeekdayTextType) -> Array<String> {
        let dateformatter = DateFormatter()
        dateformatter.calendar = calendar
        
        var weekdaySymbols: Array<String>!
        
        switch weekdayTextType {
        case .short:
            weekdaySymbols = dateformatter.shortWeekdaySymbols
            
        case .standAlone:
            weekdaySymbols = dateformatter.standaloneWeekdaySymbols
            
        default:
            weekdaySymbols = dateformatter.veryShortWeekdaySymbols
        }
        
        return weekdaySymbols
    }
    
}
