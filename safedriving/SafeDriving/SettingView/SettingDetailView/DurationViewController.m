//
//  DateViewController.m
//  SafeDriving
//
//  Created by 房懷安 on 2015/8/19.
//  Copyright (c) 2015年 Fang Huai An. All rights reserved.
//

#import "DurationViewController.h"

#import "AppDelegate.h"

#import "HttpRequestWorker.h"

@interface DurationViewController ()
{
    NSArray *movieDurationList ;
    
    IBOutlet UIPickerView * pickerMovieDuration ;
    IBOutlet UILabel *lbMovieDuration;
    IBOutlet UIButton *btnConfirm ;
    
    AppDelegate *appDelegate;
    NSInteger selectedRow ;
}

@end

@implementation DurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    movieDurationList = @[@"3 分鐘", @"5 分鐘", @"10 分鐘"];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSLog(@"sleepingTime: %ld", (long)appDelegate.sleepingTime);
    [pickerMovieDuration selectRow:appDelegate.sleepingTime inComponent:0 animated:YES];
    
    // (Leon_Huang20170414+ [Fix bug: ]
    //[self pickerView:pickerMovieDuration didSelectRow:appDelegate.sleepingTime inComponent:0];
    // Leon_Huang20170414-)
    
    
    [lbMovieDuration setText:[movieDurationList objectAtIndex:appDelegate.movieDuration]];
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
    return [movieDurationList count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [movieDurationList objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    selectedRow = row;
    
    NSString *title = [movieDurationList objectAtIndex:row];
    [lbMovieDuration setText:title];
}

#pragma mark - Button's Event

- (IBAction)btnConfirmClicked:(UIButton *)sender {
    
    [appDelegate setMovieDuration:selectedRow];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:selectedRow forKey:@"movieDuration"];
    [userDefaults synchronize];

    NSString *urlString = [NSString stringWithFormat:@"http://192.168.1.254/?custom=1&cmd=2003&par=%d",(int)appDelegate.movieDuration + 1];
    
    // (Leon_Huang20170418+ [Before sending http request, you must stop recording]
    NSString *response = [[HttpRequestWorker sharedWorker] requestWithUrl:@"http://192.168.1.254/?custom=1&cmd=2001&par=0"]; // Stop recording
    
    response = [[HttpRequestWorker sharedWorker] requestWithUrl:urlString];
    NSLog(@"response:%@", response);
    
    response = [[HttpRequestWorker sharedWorker] requestWithUrl:@"http://192.168.1.254/?custom=1&cmd=2001&par=1"]; // Start recording
    // Leon_Huang20170418-)
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
