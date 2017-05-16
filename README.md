YFCalendar
===
YFCalnedar is a convenience calendar date picker library written in swift for iOS 8.0+. 

## Install
* Drag `YFCalendar` folder into your project. 👍

## Usage
### Swift
```    
    let calendarController: YFCalendarController = YFCalendarController()
    
    calendarController.firstDate = Date();
    calendarController.lastDate = Date().addingTimeInterval(11/12.0*365*oneDayTimeInterval)
    
    calendarController.startDate = Date().addingTimeInterval(oneDayTimeInterval)
    calendarController.endDate = Date().addingTimeInterval(oneDayTimeInterval * 5)
    
    self.navigationController?.pushViewController(calendarController, animated: true)
```

### Objective-c
```
    YFCalendarController *calendarController = [YFCalendarController new];
    calendarController.delegate = self;
    calendarController.startDate = self.date1;
    calendarController.endDate = self.date2;
    
    [self.navigationController pushViewController:calendarController animated:YES];
```

Screenshots
==========
| ![](http://i4.buimg.com/588926/7c3751385cf96596.png) | ![](http://i4.buimg.com/588926/57de767fc63efdcb.png) |
| ------------- | ---------- |
