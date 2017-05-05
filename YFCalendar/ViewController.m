//
//  ViewController.m
//  YFCalendar
//
//  Created by 于帆 on 2017/4/20.
//  Copyright © 2017年 JasonYu. All rights reserved.
//

#import "ViewController.h"
#import "PDTSimpleCalendarViewController.h"
#import "YFCalendar-Swift.h"
#import "TestViewController.h"

@interface ViewController () <PDTSimpleCalendarViewDelegate>

@property (nonatomic, strong) PDTSimpleCalendarViewController *pdtCalendarViewController;

@property (nonatomic, strong) YFCalendarController *calendarController;

@property (nonatomic, strong) YFTestController *testVC;

@end

@implementation ViewController

- (YFTestController *)testVC {
    if (!_testVC) {
        _testVC = [YFTestController new];
    }
    return _testVC;
}

- (YFCalendarController *)calendarController {
    if (!_calendarController) {
        _calendarController = [YFCalendarController new];
    }
    return _calendarController;
}

- (PDTSimpleCalendarViewController *)pdtCalendarViewController {
    if (!_pdtCalendarViewController) {
        _pdtCalendarViewController = [[PDTSimpleCalendarViewController alloc] init];
        _pdtCalendarViewController.weekdayHeaderEnabled = YES;
        _pdtCalendarViewController.weekdayTextType = PDTSimpleCalendarViewWeekdayTextTypeVeryShort;
        _pdtCalendarViewController.delegate = self;
        NSDateComponents *dateComponents = [NSDateComponents new];
        [dateComponents setDay:1];
        [dateComponents setMonth:2];
        [dateComponents setYear:2015];
        NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
        _pdtCalendarViewController.firstDate = date;
        _pdtCalendarViewController.lastDate = [NSDate date];
    }
    return _pdtCalendarViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushToPDTCalendarAction:(id)sender {    
    [self.navigationController pushViewController:self.pdtCalendarViewController animated:YES];
    
}

- (IBAction)pushToYFCalendar:(id)sender {
    
    YFCalendarController *calendarController = [YFCalendarController new];
    [self.navigationController pushViewController:calendarController animated:YES];
//    [self.navigationController pushViewController:self.calendarController animated:YES];
}

- (IBAction)toTestAction:(id)sender {
    
    [self.navigationController pushViewController:self.testVC animated:YES];
}

@end
