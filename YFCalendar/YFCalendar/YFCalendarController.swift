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

private let kYFCalendarCellIdentifier                   = "kYFCalendarCellIdentifier"
private let kYFCalendarSectionHeaderViewIdentifier      = "kYFCalendarSectionHeaderViewIdentifier"
private let kYFCalendarUnitYMD: Set<Calendar.Component> = [.day, .month, .year]

@objc(YFCalendarControllerDelegate)
protocol YFCalendarControllerDelegate: NSObjectProtocol {
    
    @objc optional func yf_calendardidFinishPickingDate(startDate: Date, endDate: Date) -> Bool
    
}

@objc class YFCalendarController : UIViewController
{
    
    // MARK: - default properties
    
    weak var delegate: YFCalendarControllerDelegate?
    
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
    
    private var _startDate: Date?
    /// First selection date. 选中的第一个日期
    var startDate: Date? {
        get {
            return _startDate
        }
        set {
            _startDate = (newValue != nil) ? self.clamp(date: newValue!) : nil
        }
    }
    
    private var _endDate: Date?
    /// Last selection date. 选中的最后一个日期
    var endDate: Date? {
        get {
            return _endDate
        }
        set {
            _endDate = (newValue != nil) ? self.clamp(date: newValue!) : nil
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
    
    /// header date formatter
    fileprivate lazy var headerDateFormatter: DateFormatter = self.createHeaderDateFormatter()
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
        return self.calendar.dateComponents([.month], from: self.firstMonth, to: self.lastMonth).month! + 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let firstDateOfMonth = self.firstDateOfMonth(with: section)
        let rangeOfWeeks = self.calendar.range(of: Calendar.Component.weekOfMonth, in: Calendar.Component.month, for: firstDateOfMonth)
        let distance = rangeOfWeeks?.lowerBound.distance(to: (rangeOfWeeks?.upperBound)!)
//        distance = (rangeOfWeeks!.upperBound - rangeOfWeeks!.lowerBound)
        print(rangeOfWeeks?.count == distance)
        return (rangeOfWeeks?.count)! * Int(self.daysPerWeek)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: YFCalendarCell = collectionView.dequeueReusableCell(withReuseIdentifier: kYFCalendarCellIdentifier,for: indexPath) as! YFCalendarCell
        
        let cellDate: Date = self.dateForIndexPath(indexPath)
        
        var dateTime: YFCalendarCellDateTimeType = .disabledDate
        
        var selectionStyle: YFCalendarCellSelectionStyle = .none
        if indexPath.section == 1 && indexPath.row == 3 {
            print(indexPath)
        }
        
        if self.dateInCurrentMonth(indexPath) {
            
            cell.setDate(date: cellDate, calendar: self.calendar)
            
            // specify the cellDate. enabled/disabled or today
            if self.isEnabledDate(someDate: cellDate) {
                dateTime = self.isTodayDate(someDate: cellDate) ? .isToday : .enabledDate
            } else {
                dateTime = .disabledDate
            }
            
            
            if let startDate = self.startDate {
                let startDateCompare = startDate.compare(cellDate)
                let isStartDate = startDateCompare == .orderedSame
                if let endDate = self.endDate {
                    let compareEndDate = cellDate.compare(endDate)
                    let isEndDate = compareEndDate == .orderedSame
                    if isStartDate {
                        selectionStyle = .leftBorder
                    }
                    else if isEndDate {
                        selectionStyle = .rightBorder
                    }
                    else if startDateCompare == .orderedAscending && compareEndDate == .orderedAscending {
                        selectionStyle = .middle
                    }
                    
                } else {
                    if isStartDate {
                        selectionStyle = .single
                    }
                }
            }
            
        } else {
            cell.setDate(date: nil, calendar: nil)
        }
        cell.dateTimeType = dateTime
        cell.selectionStyle = selectionStyle
        
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let headerView: YFCalendarSectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kYFCalendarSectionHeaderViewIdentifier, for: indexPath) as! YFCalendarSectionHeaderView
            
            headerView.titleLabel.text = self.headerDateFormatter.string(from: self.firstDateOfMonth(with: indexPath.section)).uppercased()
            
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout Extension
extension YFCalendarController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return self.isEnabledDate(someDate: self.dateForIndexPath(indexPath))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cellDate = self.dateForIndexPath(indexPath)
        
        var shouldPop = false
        if let startDate = self.startDate {
            
            if let _ = self.endDate {
                /// if the start and end date all be selected, reset. 如果开始和结束日期都已选择,重新选择
                self.endDate = nil
                self.startDate = cellDate
            } else {
                /// otherwise, set endDate. 否则,设置endDate
                switch startDate.compare(cellDate) {
                case .orderedAscending:
                    self.endDate = cellDate
                    
                case .orderedDescending:
                    self.endDate = startDate
                    self.startDate = cellDate
                    
                // default and .orderedSame cases must return. cause the following 'if let' require both self.startDate and self.endDate not empty!
                default:
                    return
                }
                
                if let result = self.delegate?.yf_calendardidFinishPickingDate?(startDate: self.startDate!, endDate: self.endDate!) {
                    shouldPop = result
                }
            }
            
            
        } else {
            
            self.startDate = cellDate
        }
        
        collectionView.reloadData()
        
        if shouldPop {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if fabs(velocity.y) > 0.0 {
            if self.overlayView.alpha < 1.0 {
                UIView.animate(withDuration: 0.25, animations: { 
                    self.overlayView.alpha = 1.0
                })
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let delay = decelerate ? 1.5 : 0.0
        self.perform(#selector(hideOverlayView), with: nil, afterDelay: delay)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let indexPaths = self.calendarView.indexPathsForVisibleItems
        let sortedIndexPaths = indexPaths.sorted()
        if let firstIndexPath = sortedIndexPaths.first {
            self.overlayView.text = self.headerDateFormatter.string(from: self.firstDateOfMonth(with: firstIndexPath.section))
        }
    }
    
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
    
    
    // Without '@objc', error would rise in 'self.perform(#selector(hideOverlayView), with: nil, afterDelay: delay)'
    @objc func hideOverlayView() {
        UIView.animate(withDuration: 0.25) {
            self.overlayView.alpha = 0.0
        }
    }
}

// MARK: - Calendar Calculations 日历计算
fileprivate extension YFCalendarController {
    
    /// Get the midnight time of a specific date.
    ///   e.g.
    ///    input: 2017-1-1 14:33:32
    ///   output: 2017-1-1 00:00:00
    ///
    /// - Parameter date: input date
    /// - Returns: New date with h/m/s components set to zero.
    func clamp(date: Date) -> Date {
//        let components = self.calendar.dateComponents(kYFCalendarUnitYMD, from: date)
//        return self.calendar.date(from: components)!
        return self.calendar.startOfDay(for:date)
    }
    
    func firstDateOfMonth(with section: Int) -> Date {
        var offsetComponents = DateComponents()
        offsetComponents.month = section
        return self.calendar.date(byAdding: offsetComponents, to: self.firstMonth)!
    }
    
    func dateForIndexPath(_ indexPath: IndexPath) -> Date {
        let firstDateOfMonth: Date = self.firstDateOfMonth(with: indexPath.section)
        let weekDay: Int = self.calendar.dateComponents([.weekday], from: firstDateOfMonth).weekday!
        var startOffset = weekDay - self.calendar.firstWeekday
        startOffset += Int(startOffset >= 0 ? 0 : self.daysPerWeek)
        
        var dateComponents = DateComponents()
        dateComponents.day = indexPath.item - startOffset
        return  self.calendar.date(byAdding: dateComponents, to: firstDateOfMonth)!
    }
    
    func indexPath(ofDate date:Date?) -> IndexPath? {
        if date == nil {
            return nil
        }
        
        for cell in self.calendarView.visibleCells as! [YFCalendarCell] {
            if let cellDate = cell.date {
                if cellDate.compare(date!) == .orderedSame {
                    return self.calendarView.indexPath(for: cell)
                }
            }
        }
        
        return nil
    }
    
    func isEnabledDate(someDate: Date) -> Bool {
        let cellDate = self.clamp(date: someDate)
        var enabled = false
        if (cellDate.compare(self.firstDate) == .orderedDescending && cellDate.compare(self.lastDate) == .orderedAscending) || cellDate.compare(self.firstDate) == .orderedSame {
            enabled = true
        }
        return enabled
    }
    
    func isTodayDate(someDate: Date) -> Bool {
        let cellDate = self.clamp(date: someDate)
        return cellDate.compare(self.calendar.startOfDay(for: Date())) == .orderedSame
    }
    
    func dateInCurrentMonth(_ indexPath: IndexPath) -> Bool {
        
        let firstDateOfMonth: Date = self.firstDateOfMonth(with: indexPath.section)
        let cellDateComponents: DateComponents = self.calendar.dateComponents(kYFCalendarUnitYMD, from: self.dateForIndexPath(indexPath))
        let firstDateMonthComponents: DateComponents = self.calendar.dateComponents(kYFCalendarUnitYMD, from: firstDateOfMonth)
        
        return cellDateComponents.month == firstDateMonthComponents.month
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
        components.year = 2
        components.month = -1
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
        let view = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-64), collectionViewLayout: layout)
        view.clipsToBounds = false
        view.backgroundColor = UIColor.white
        view.showsHorizontalScrollIndicator = false
        view.allowsMultipleSelection = true
        
        // register cell and section header
        view.register(YFCalendarCell.self, forCellWithReuseIdentifier: kYFCalendarCellIdentifier)
        view.register(YFCalendarSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kYFCalendarSectionHeaderViewIdentifier)
        
        // delegate and datasource
        view.delegate = self
        view.dataSource = self
        
        // layout
        let itemWidth = CGFloat(floorf(Float(UIScreen.main.bounds.size.width/7.0)))
        layout.sectionInset = UIEdgeInsetsMake(0, UIScreen.main.bounds.size.width - itemWidth * 7.0, 0, 0)
        layout.itemSize = CGSize.init(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = CGFloat.leastNormalMagnitude
        layout.minimumInteritemSpacing = CGFloat.leastNormalMagnitude
        
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
    
    func createHeaderDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = self.calendar
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy LLLL", options: 0, locale: self.calendar.locale)
        return formatter
    }
    
}
