//
//  YFTestController.swift
//  YFCalendar
//
//  Created by 于帆 on 2017/5/2.
//  Copyright © 2017年 JasonYu. All rights reserved.
//

import UIKit

class YFTestController: UIViewController {
    
    var button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        
        self.button.backgroundColor = UIColor.red
        self.view.addSubview(self.button)
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.button.layer.cornerRadius = 16
        
        self.view.addConstraint(NSLayoutConstraint.init(item: self.button, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint.init(item: self.button, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint.init(item: self.button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 32))
        self.view.addConstraint(NSLayoutConstraint.init(item: self.button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 32))
        
        self.button.addTarget(self, action: #selector(toYFCalendarController), for: .touchUpInside)
        
        
    }
    
    func toYFCalendarController() {
        
        let oneDayTimeInterval: TimeInterval = 24*60*60
        
        let calendarController: YFCalendarController = YFCalendarController()
        
        calendarController.firstDate = Date();
        calendarController.lastDate = Date().addingTimeInterval(3.5*365*oneDayTimeInterval)
        
        calendarController.startDate = Date().addingTimeInterval(oneDayTimeInterval)
        calendarController.endDate = Date().addingTimeInterval(oneDayTimeInterval * 5)
        
        self.navigationController?.pushViewController(calendarController, animated: true)
    }
    
}
