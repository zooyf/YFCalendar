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

@property (nonatomic, strong) TestViewController *testVC;

@end

@implementation ViewController

- (TestViewController *)testVC {
    if (!_testVC) {
        _testVC = [TestViewController new];
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
    
    self.calendarController.testTitle = @"你好";
    [self.navigationController pushViewController:self.calendarController animated:YES];
}

- (IBAction)toTestAction:(id)sender {
    
    [self.navigationController pushViewController:self.testVC animated:YES];
}

@end
