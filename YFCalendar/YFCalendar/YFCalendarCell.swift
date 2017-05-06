//
//  YFCalendarCell.swift
//  YFCalendar
//
//  Created by 于帆 on 2017/5/2.
//  Copyright © 2017年 JasonYu. All rights reserved.
//

import UIKit

enum YFCalendarCellDateTimeType {
    case isToday
    case beforeToday
    case afterToday
}

enum YFCalendarCellSelectionStyle {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
}

class YFCalendarCell: UICollectionViewCell
{
    
    private var _dateTimeType: YFCalendarCellDateTimeType = .afterToday
    var dateTimeType: YFCalendarCellDateTimeType {
        get {
            return _dateTimeType
        }
        set {
            _dateTimeType = newValue
            switch newValue {
            case .beforeToday:
                self.dayLabel.textColor = UIColor.gray
                
            case .isToday:
                self.dayLabel.textColor = UIColor.red
                
            case .afterToday:
                self.dayLabel.textColor = UIColor.black
                
            }
            
        }
    }
    
    private lazy var _selectionStyle: YFCalendarCellSelectionStyle = .none
    var selectionStyle: YFCalendarCellSelectionStyle {
        get {
            return _selectionStyle
        }
        set {
            _selectionStyle = newValue
                        
            self.selectionLayer.isHidden = newValue == .none
            self.dayLabel.textColor = self.selectionTextColor
            
            var layerBounds = self.centerSelectionRect()
            let blankWidth = (self.bounds.width - layerBounds.width)/2.0
            switch newValue {
            case .single:
                self.selectionLayer.path = UIBezierPath.init(ovalIn: layerBounds).cgPath
                
            case .leftBorder:
                layerBounds.origin.x = blankWidth
                layerBounds.size.width = self.bounds.width - blankWidth
                self.selectionLayer.path = UIBezierPath.init(roundedRect: layerBounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize.init(width: layerBounds.size.height, height: layerBounds.size.height)).cgPath
                
            case .middle:
                layerBounds.origin.x = -5
                layerBounds.size.width = self.bounds.width + 5
                self.selectionLayer.path = UIBezierPath.init(rect: layerBounds).cgPath
                
            case .rightBorder:
                layerBounds.origin.x = -5
                layerBounds.size.width = self.bounds.width - blankWidth + 5
                self.selectionLayer.path = UIBezierPath.init(roundedRect: layerBounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize.init(width: layerBounds.size.height, height: layerBounds.size.height)).cgPath
                
            case .none:
                self.dateTimeType = _dateTimeType
                self.selectionLayer.isHidden = true
            }
        }
    }
    
    lazy var isToday: Bool = false
    
    lazy var selectionFillColor = UIColor.black
    
    lazy var selectionTextColor = UIColor.white
    
    lazy var selectionLayer: CAShapeLayer = CAShapeLayer()
        
    lazy var dayLabel: UILabel = { [unowned self] in
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        
        // 使用autolayout 必须设置此属性为true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    func setDate(date:Date?, calendar:Calendar?) {
        self._date = date
        
        if calendar == nil {
            self.dayLabel.text = ""
            self.dayLabel.accessibilityLabel = ""
            return
        }
        
        var day: String = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        dateFormatter.calendar = calendar
        day = dateFormatter.string(from: date!)
        self.dayLabel.text = day
        
        var accessibilityDay = ""
        let accessibilityFormatter = DateFormatter()
        accessibilityFormatter.dateStyle = .long
        accessibilityFormatter.timeStyle = .none
        accessibilityDay = accessibilityFormatter.string(from: date!)
        self.dayLabel.accessibilityLabel = accessibilityDay
    }
    
    fileprivate var _date: Date?
    var date: Date? {
        return _date
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.dayLabel.text = "30"
        self.contentView.addSubview(self.dayLabel)
        
        self.contentView.addConstraint(NSLayoutConstraint.init(item: self.dayLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0))
        self.contentView.addConstraint(NSLayoutConstraint.init(item: self.dayLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0))
        self.contentView.addConstraint(NSLayoutConstraint.init(item: self.dayLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 32))
        self.contentView.addConstraint(NSLayoutConstraint.init(item: self.dayLabel, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 32))
        
        self.contentView.layer.insertSublayer(self.selectionLayer, below: self.dayLabel.layer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension YFCalendarCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.selectionLayer.frame = self.bounds
        
        
    }
    
    fileprivate func centerSelectionRect() -> CGRect {
        return self.centerRect(size: CGSize.init(width: self.bounds.size.width/3.0*2.0, height: self.bounds.size.height/3.0*2.0))
    }
    
    fileprivate func centerRect(size: CGSize) -> CGRect {
        let x = self.bounds.size.width/2.0
        let y = self.bounds.size.height/2.0
        let width = size.width
        let height = size.height
        return CGRect.init(x: x - width / 2.0, y: y - height / 2.0, width: width, height: height)
    }
}
