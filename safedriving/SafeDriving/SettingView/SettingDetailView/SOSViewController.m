//
//  LanguageViewController.m
//  SafeDriving
//
//  Created by 房懷安 on 2015/8/19.
//  Copyright (c) 2015年 Fang Huai An. All rights reserved.
//

#import "SOSViewController.h"

#import "AppDelegate.h"

@interface SOSViewController ()
{
    IBOutlet UITextField *txtEmail ;
    IBOutlet UITextField *txtSms ;
    IBOutlet UIButton *btnConfirm;
    
    AppDelegate *appDelegate;
}

@end

@implementation SOSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ( nil != appDelegate.mailAddress && [appDelegate.mailAddress length] > 0 ) {
        [txtEmail setText:appDelegate.mailAddress];
    }
    
    if ( nil != appDelegate.smsAddress && [appDelegate.smsAddress length] > 0 ) {
        [txtSms setText:appDelegate.smsAddress];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) btnConfirmClicked:(id)sender{
    
    [appDelegate setMailAddress:[txtEmail text]];
    [appDelegate setSmsAddress:[txtSms text]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[txtEmail text] forKey:@"mailAddress"];
    [userDefaults setObject:[txtSms text] forKey:@"smsAddress"];
    
    [userDefaults synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];

}

@end
