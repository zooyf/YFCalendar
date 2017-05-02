//
//  YFCalendarViewFlowLayout.swift
//  YFCalendar
//
//  Created by 于帆 on 2017/5/4.
//  Copyright © 2017年 JasonYu. All rights reserved.
//

import UIKit

let YFCalendarFlowLayoutMinInterItemSpacing     = CGFloat(0.0)
let YFCalendarFlowLayoutMinLineSpacing          = CGFloat(0.0)
let YFCalendarFlowLayoutInsetTop                = CGFloat(5.0)
let YFCalendarFlowLayoutInsetLeft               = CGFloat(0.0)
let YFCalendarFlowLayoutInsetBottom             = CGFloat(5.0)
let YFCalendarFlowLayoutInsetRight              = CGFloat(0.0)
let YFCalendarFlowLayoutHeaderHeight            = CGFloat(30.0)

class YFCalendarViewFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        
        self.minimumInteritemSpacing = YFCalendarFlowLayoutMinInterItemSpacing
        self.minimumLineSpacing = YFCalendarFlowLayoutMinLineSpacing
        self.scrollDirection = .vertical
        self.sectionInset = UIEdgeInsetsMake(YFCalendarFlowLayoutInsetTop,
                                             YFCalendarFlowLayoutInsetLeft,
                                             YFCalendarFlowLayoutInsetBottom,
                                             YFCalendarFlowLayoutInsetRight);
        self.headerReferenceSize = CGSize.init(width: 0, height: YFCalendarFlowLayoutHeaderHeight)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
