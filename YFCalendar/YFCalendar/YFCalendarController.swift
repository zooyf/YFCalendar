//
//  YFCalendarController.swift
//  YFCalendar
//
//  Created by 于帆 on 2017/4/20.
//  Copyright © 2017年 JasonYu. All rights reserved.
//

import UIKit

private let CellIdentifier = "YFTestCell"

@objc class YFCalendarController : UIViewController
{
    
    var testTitle: String?
    
    fileprivate lazy var calendarCV: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-64), collectionViewLayout: layout)
        view.clipsToBounds = false
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CellIdentifier)
        
        view.delegate = self
        view.dataSource = self
        
        view.backgroundColor = UIColor.blue
        
//        layout.itemSize = CGSize.init(width: 70, height: 70)

        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        
        self.view.addSubview(self.calendarCV)
        
        self.view.backgroundColor = UIColor.white
    }
    
    
    
}

extension YFCalendarController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier,for: indexPath)
        
        cell.contentView.backgroundColor = UIColor.red
        
        return cell
    }
}

extension YFCalendarController: UICollectionViewDelegateFlowLayout {
    
}


fileprivate extension YFCalendarController {
    
    
    
    
}
