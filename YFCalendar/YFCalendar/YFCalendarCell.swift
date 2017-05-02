//
//  YFCalendarCell.swift
//  YFCalendar
//
//  Created by 于帆 on 2017/5/2.
//  Copyright © 2017年 JasonYu. All rights reserved.
//

import UIKit

class YFCalendarCell: UICollectionViewCell
{
    
//    var dayLabel = UILabel()
    
    lazy var dayLabel: UILabel = { [unowned self] in
        let label = UILabel()
//        label.backgroundColor = UIColor.gray
        label.layer.cornerRadius = 16.0
        label.layer.masksToBounds = true
        label.textAlignment = NSTextAlignment.center
        
        // 使用autolayout 必须设置此属性为true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.dayLabel.text = "30"
        self.contentView.addSubview(self.dayLabel)
        
        self.contentView.addConstraint(NSLayoutConstraint.init(item: self.dayLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0))
        self.contentView.addConstraint(NSLayoutConstraint.init(item: self.dayLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0))
        self.contentView.addConstraint(NSLayoutConstraint.init(item: self.dayLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 32))
        self.contentView.addConstraint(NSLayoutConstraint.init(item: self.dayLabel, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 32))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


