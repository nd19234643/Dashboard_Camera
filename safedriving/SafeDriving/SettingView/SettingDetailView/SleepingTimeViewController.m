//
//  CycleTimeViewController.m
//  SafeDriving
//
//  Created by 房懷安 on 2015/8/19.
//  Copyright (c) 2015年 Fang Huai An. All rights reserved.
//

#import "SleepingTimeViewController.h"

#import "AppDelegate.h"

#import "HttpRequestWorker.h"

@interface SleepingTimeViewController ()
{
    NSArray *sleepingTimeList ;
    
    IBOutlet UIPickerView * pickerSleepingTime ;
    IBOutlet UILabel *lbSleepingTime;
    IBOutlet UIButton *btnConfirm ;
    
    AppDelegate *appDelegate;
    NSInteger selectedRow ;

}

@end

@implementation SleepingTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    sleepingTimeList = @[@"3 分鐘", @"5 分鐘", @"10 分鐘"];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //
    [pickerSleepingTime selectRow:appDelegate.sleepingTime inComponent:0 animated:YES];
    [lbSleepingTime setText:[sleepingTimeList objectAtIndex:appDelegate.sleepingTime]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerViewDataSource and UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [sleepingTimeList count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [sleepingTimeList objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    selectedRow = row;
    
    NSString *title = [sleepingTimeList objectAtIndex:row];
    [lbSleepingTime setText:title];
}

#pragma mark - Button's Event

- (IBAction) btnConfirmClicked : (UIButton *) sender {
    
    [appDelegate setSleepingTime:selectedRow];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:selectedRow forKey:@"sleepingTime"];
    [userDefaults synchronize];
    
    NSString *urlString = [NSString stringWithFormat:@"http://192.168.1.254/?custom=1&cmd=3007&par=%d", (int)(appDelegate.sleepingTime + 1)];
    NSString *response = [[HttpRequestWorker sharedWorker] requestWithUrl:urlString];
    NSLog(@"response:%@", response );
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
