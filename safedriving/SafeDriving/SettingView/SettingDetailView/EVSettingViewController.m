//
//  ContactViewController.m
//  SafeDriving
//
//  Created by 房懷安 on 2015/8/19.
//  Copyright (c) 2015年 Fang Huai An. All rights reserved.
//

#import "EVSettingViewController.h"

#import "AppDelegate.h"

#import "HttpRequestWorker.h"

@interface EVSettingViewController ()
{
    NSArray *EvList ;
    
    IBOutlet UIPickerView * pickerEV;
    IBOutlet UILabel *lbEv;
    IBOutlet UIButton *btnConfirm;
    
    AppDelegate *appDelegate;
    NSInteger selectedRow ;
}

@end

@implementation EVSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //
    EvList = @[@"+2.0", @"+1.7", @"+1.3", @"+1.0", @"+0.7", @"+0.3", @"0", @"-0.3", @"-0.7", @"-1.0", @"-1.3", @"-1.7",@"-2.0"];
    
    //
    [pickerEV selectRow:appDelegate.evSetting inComponent:0 animated:YES];
    [lbEv setText:[EvList objectAtIndex:appDelegate.evSetting]];

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
    return [EvList count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [EvList objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    selectedRow = row;
    
    NSString *title = [EvList objectAtIndex:row];
    [lbEv setText:title];
}

#pragma mark - Button's Event

- (IBAction) btnConfirmClicked : (UIButton *) sender {
    
    [appDelegate setEvSetting:selectedRow];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:selectedRow forKey:@"evSetting"];
    [userDefaults synchronize];
    
    NSString *urlString = [NSString stringWithFormat:@"http://192.168.1.254/?custom=1&cmd=2005&par=%d",(int) appDelegate.evSetting ];
    
    // (Leon_Huang20170418+ [Before sending http request, you must stop recording]
    NSString *response = [[HttpRequestWorker sharedWorker] requestWithUrl:@"http://192.168.1.254/?custom=1&cmd=2001&par=0"]; // Stop recording
    
    response = [[HttpRequestWorker sharedWorker] requestWithUrl:urlString];
    NSLog(@"response:%@", response );
    
    response = [[HttpRequestWorker sharedWorker] requestWithUrl:@"http://192.168.1.254/?custom=1&cmd=2001&par=1"]; // Start recording
    // Leon_Huang20170418-)
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
