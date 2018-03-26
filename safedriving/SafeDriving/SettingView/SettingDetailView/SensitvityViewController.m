//
//  ResolutionViewController.m
//  SafeDriving
//
//  Created by 房懷安 on 2015/8/19.
//  Copyright (c) 2015年 Fang Huai An. All rights reserved.
//

#import "SensitvityViewController.h"

#import "AppDelegate.h"

#import "HttpRequestWorker.h"

@interface SensitvityViewController ()
{
    NSArray *sensitvities ;
    
    IBOutlet UIPickerView * pickerSensitvity ;
    IBOutlet UILabel *lbSensitvity;
    IBOutlet UIButton *btnConfirm ;
    
    AppDelegate *appDelegate;
    NSInteger selectedRow ;
}
@end

@implementation SensitvityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    sensitvities = @[@"低", @"中", @"高"];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //
    [pickerSensitvity selectRow:appDelegate.sensitvity inComponent:0 animated:YES];
    [lbSensitvity setText:[sensitvities objectAtIndex:appDelegate.sensitvity]];
    
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
    return [sensitvities count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    return [sensitvities objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    selectedRow = row;
    
    NSString *title = [sensitvities objectAtIndex:row];
    [lbSensitvity setText:title];
}

#pragma mark - Button's Event

- (IBAction) btnConfirmClicked : (UIButton *) sender {

    [appDelegate setSensitvity:selectedRow];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:selectedRow forKey:@"sensitvity"];
    [userDefaults synchronize];
    
    NSString *urlString = [NSString stringWithFormat:@"http://192.168.1.254/?custom=1&cmd=2011&par=%d", (int)appDelegate.sensitvity + 1];
    NSString *response = [[HttpRequestWorker sharedWorker] requestWithUrl:urlString];
    NSLog(@"response:%@", response );
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
