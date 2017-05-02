//
//  YFCalendarSectionHeader.swift
//  YFCalendar
//
//  Created by 于帆 on 2017/5/2.
//  Copyright © 2017年 JasonYu. All rights reserved.
//

import UIKit

let YFCalendarWeekdayHeaderSize = CGFloat(12.0)

class YFCalendarSectionHeader: UICollectionReusableView {
    
    lazy var titleLabel: UILabel = { [unowned self] in
        let lb = UILabel()
        lb.textColor = UIColor.gray
        lb.font = UIFont.systemFont(ofSize: YFCalendarWeekdayHeaderSize)
        
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.titleLabel)
        
        self.addConstraint(NSLayoutConstraint.init(item: self.titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint.init(item: self.titleLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 10))
        
        self.titleLabel.text = "2017年5月"
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.lightGray
        self.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        let onePixel = 1.0 / UIScreen.main.scale
        self.addConstraint(NSLayoutConstraint.init(item: separatorView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: separatorView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: separatorView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: separatorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: onePixel))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
