//
//  YFCalendarController.swift
//  YFCalendar
//
//  Created by 于帆 on 2017/4/20.
//  Copyright © 2017年 JasonYu. All rights reserved.
//

import UIKit

let YFCalendarOverlaySize           = CGFloat(14.0)
let YFCalendarWeekdayHeaderHeight   = CGFloat(20.0)

private let kYFCalendarCellIdentifier               = "kYFCalendarCellIdentifier"
private let kYFCalendarSectionHeaderIdentifier      = "kYFCalendarSectionHeaderIdentifier"
private let kYFCalendarUnitYMD: Set<Calendar.Component> = [.day, .month, .year]

@objc class YFCalendarController : UIViewController
{
    
    // MARK: - default properties
    
    /// Background color of the Calendar. This will also affect the value of the background color for the overlay view.
    lazy var backgroundColor: UIColor = UIColor.white
    
    /// Text color for the overlay view (Month and Year when the user scrolls the calendar).
    lazy var overlayTextColor: UIColor = UIColor.black
    
    private lazy var _firstDate: Date = self.createFirstDate()
    /// first date of the calendar. 日历的起始日期.
    var firstDate: Date {
        get {
            return _firstDate
        }
        set {
            _firstDate = self.clamp(date: newValue)
        }
    }
    
    private lazy var _lastDate: Date = self.createLastDate()
    /// last date of the calendar. 日历的结束日期.
    var lastDate: Date {
        get {
            return _lastDate
        }
        set {
            _lastDate = self.clamp(date: newValue)
        }
    }
    
    /**
     *  The calendar used to generate the view.
     *
     *  If not set, the default value is `[NSCalendar currentCalendar]`
     */
    private lazy var _calendar: Calendar = Calendar.current
    var calendar: Calendar {
        get {
            return _calendar
        }
        set {
            _calendar = newValue
        }
    }
    
    // MARK: - fileprivate properties
    
    /// days per week
    fileprivate lazy var daysPerWeek: UInt = {
        [unowned self] in // Avoid strong recycle reference. 避免强引用循环.
        // Using class variable in lazy method, 'self.' has no code hits.
        let range = self.calendar.maximumRange(of: .weekday)
        return UInt(range!.upperBound - range!.lowerBound)
    }()
    
    /// calendar collection view
    fileprivate lazy var calendarView: UICollectionView = self.createCalendarView()
    
    /// overlay floating view. 滑动时悬浮显示年月.
    fileprivate lazy var overlayView: UILabel = self.createOverlayView()
    
    /// week day header at the top.
    fileprivate lazy var weekdayHeaderView: YFCalendarWeekdayHeaderView = self.createWeekdayHeaderView()
    
    /// first month of the calendar
    fileprivate lazy var firstMonth: Date = self.createFirstMonth()
    
    /// last month of the calendar
    fileprivate lazy var lastMonth: Date = self.createLastMonth()
}

// MARK: - view life cycle
extension YFCalendarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        
        self.view.addSubview(self.calendarView)
        
        self.view.backgroundColor = UIColor.white
        
        print(self.calendar)
        
        self.setupHeaderAndOverlayView()
        print(self.firstDate)
        print(self.lastDate)
        
    }
}

// MARK: - UICollectionViewDataSource Extension
extension YFCalendarController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5*7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kYFCalendarCellIdentifier,for: indexPath)
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kYFCalendarSectionHeaderIdentifier, for: indexPath)
            
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout Extension
extension YFCalendarController: UICollectionViewDelegateFlowLayout {
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let itemWidth = CGFloat(floorf(Float(UIScreen.main.bounds.size.width/7.0)))
//        
//        return CGSize.init(width: itemWidth, height: itemWidth)
//    }
}


// MARK: - UI methods
fileprivate extension YFCalendarController {
    
    func setupHeaderAndOverlayView() {
        self.view.addSubview(self.weekdayHeaderView)
        self.view.addSubview(self.overlayView)
        
        let weekdayHeaderHeight = YFCalendarWeekdayHeaderHeight
        
        let viewsDict: [String: Any] = ["overlayView": self.overlayView,
                         "weekdayHeaderView": self.weekdayHeaderView
                         ]
        let metricsDict: [String: CGFloat] = ["overlayViewHeight": YFCalendarFlowLayoutHeaderHeight,
                                            "weekdayHeaderHeight": weekdayHeaderHeight]
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[overlayView]|", options: .alignAllTop, metrics: nil, views: viewsDict))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[weekdayHeaderView]|", options: .alignAllTop, metrics: nil, views: viewsDict))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[weekdayHeaderView(weekdayHeaderHeight)][overlayView(overlayViewHeight)]", options: .directionLeadingToTrailing, metrics: metricsDict, views: viewsDict))
        
        self.calendarView.contentInset = UIEdgeInsetsMake(weekdayHeaderHeight, 0, 0, 0);
    }
    
}

// MARK: - Calendar Calculations 日历计算
fileprivate extension YFCalendarController {
    
    func clamp(date: Date) -> Date {
        let components = self.calendar.dateComponents(kYFCalendarUnitYMD, from: date)
        return self.calendar.date(from: components)!
    }
    
}

// MARK: - lazy initializer methods 懒加载方法
fileprivate extension YFCalendarController {
    
    func createFirstDate() -> Date {
        var components: DateComponents = self.calendar.dateComponents(kYFCalendarUnitYMD, from: Date.init())
        components.day = 1
        return self.calendar.date(from: components)!
    }
    
    func createLastDate() -> Date {
        var components: DateComponents = self.calendar.dateComponents(kYFCalendarUnitYMD, from: Date.init())
        components.day = -1
        components.year = 1
        self.lastDate = self.calendar.date(byAdding: components, to: self.firstDate)!
        return self.lastDate
    }
    
    func createOverlayView() -> UILabel {
        let overlayView = UILabel()
        overlayView.backgroundColor = self.backgroundColor.withAlphaComponent(0.90)
        overlayView.font = UIFont.boldSystemFont(ofSize: YFCalendarOverlaySize)
        overlayView.textColor = self.overlayTextColor
        overlayView.alpha = 0.0
        overlayView.textAlignment = .center
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        return overlayView
    }
    
    func createWeekdayHeaderView() -> YFCalendarWeekdayHeaderView {
        let weekdayHeaderView = YFCalendarWeekdayHeaderView.init(calendar: self.calendar, weekdayTextType: YFCalendarWeekdayTextType.VeryShort)
        weekdayHeaderView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20)
        return weekdayHeaderView
    }
    
    func createCalendarView() -> UICollectionView {
        let layout = YFCalendarViewFlowLayout()
        let view = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-64), collectionViewLayout: YFCalendarViewFlowLayout())
        view.clipsToBounds = false
        view.backgroundColor = UIColor.white
        view.showsHorizontalScrollIndicator = false
        
        // register cell and section header
        view.register(YFCalendarCell.self, forCellWithReuseIdentifier: kYFCalendarCellIdentifier)
        view.register(YFCalendarSectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kYFCalendarSectionHeaderIdentifier)
        
        // delegate and datasource
        view.delegate = self
        view.dataSource = self
        
        // layout
        let itemWidth = CGFloat(floorf(Float(UIScreen.main.bounds.size.width/7.0)))
        layout.itemSize = CGSize.init(width: itemWidth, height: itemWidth)
        
        return view
    }
    
    func createFirstMonth() -> Date {
        var components: DateComponents = self.calendar.dateComponents(kYFCalendarUnitYMD, from: self.firstDate)
        components.day = 1
        return self.calendar.date(from: components)!
    }
    
    func createLastMonth() -> Date {
        var components: DateComponents = self.calendar.dateComponents(kYFCalendarUnitYMD, from: self.lastDate)
        components.day = 0
        components.month! += 1
        return self.calendar.date(from: components)!
    }
    
}
