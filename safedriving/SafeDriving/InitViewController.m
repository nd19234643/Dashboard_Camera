//
//  ViewController.m
//  SafeDriving
//
//  Created by 房懷安 on 2015/8/19.
//  Copyright (c) 2015年 Fang Huai An. All rights reserved.
//

#import "InitViewController.h"

#import "MBProgressHUD.h"

@interface InitViewController ()
{
    MBProgressHUD *hud ;
}

@end

@implementation InitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.navigationController.navigationBar setHidden:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(moveToProductView) userInfo:nil repeats:NO];
    
}

- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Connecting";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) moveToProductView {
    
    [hud hide:YES];

    //[self performSegueWithIdentifier:@"moveToProductViewSegue" sender:self];
    [self performSegueWithIdentifier:@"moveToMenuSegue" sender:self];
    
}


@end
