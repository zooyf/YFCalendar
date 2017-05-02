//
//  YFTestController.swift
//  YFCalendar
//
//  Created by 于帆 on 2017/5/2.
//  Copyright © 2017年 JasonYu. All rights reserved.
//

import UIKit

class YFTestController: UIViewController {
    
    var dayLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        
        self.dayLabel.backgroundColor = UIColor.red
        self.view.addSubview(self.dayLabel)
        self.dayLabel.translatesAutoresizingMaskIntoConstraints = false
        self.dayLabel.layer.cornerRadius = 16
        
        self.view.addConstraint(NSLayoutConstraint.init(item: self.dayLabel, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint.init(item: self.dayLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint.init(item: self.dayLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 32))
        self.view.addConstraint(NSLayoutConstraint.init(item: self.dayLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 32))
        
        
    }
    
}
