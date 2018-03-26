//
//  SettingViewController.m
//  SafeDriving
//
//  Created by 房懷安 on 2015/8/19.
//  Copyright (c) 2015年 Fang Huai An. All rights reserved.
//

#import "SettingViewController.h"

#import "AppDelegate.h"

#import "NormalCellView.h"
#import "ContactCellView.h"

#import "SensitvityViewController.h"
#import "SleepingTimeViewController.h"
#import "DurationViewController.h"
#import "EVSettingViewController.h"
#import "SOSViewController.h"

@interface SettingViewController ()
{
    IBOutlet UITableView *settingsTable ;
    NSArray *settings ;
    NSArray *sensitvities;
    NSArray *sleepingTimeList ;
    NSArray *movieDurationList;
    NSArray *EvList;
    
    AppDelegate *appDelegate;
}

@end

@implementation SettingViewController

static NSString *NormalCellViewIdentifier = @"NormalCellView";
static NSString *ContactCellViewIdentifier = @"ContactCellView";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    [self.navigationController setNavigationBarHidden:NO];
    //
    //settings = @[@"錄音", @"影片解析度", @"循環錄影時間", @"緊急錄影", @"移動偵測", @"時間", @"緊急通知", @"語言", @"回復原廠設定"];
    
    settings = @[@"警示靈敏度", @"休眠時間", @"影片長度", @"EV設定", @"SOS功能", @"故障診斷", @"韌體更新" ];
    
    sensitvities = @[@"低", @"中", @"高"];
    sleepingTimeList = @[@"3 分鐘", @"5 分鐘", @"10 分鐘"];
    movieDurationList = @[@"3 分鐘", @"5 分鐘", @"10 分鐘"];
    EvList = @[@"+2.0", @"+1.7", @"+1.3", @"+1.0", @"+0.7", @"+0.3", @"0", @"-1.3", @"-0.7", @"-1.0", @"-1.3", @"-1.7",@"-2.0"];
    //
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //
    [self setTitle:@"設定"];
}

- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];

    [settingsTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource and UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [settings count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = [indexPath row];
    
    switch (row) {
        case 4:
            {
                return 90.0f ;
            }
        default:
            {
                return 70.0f;
            }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger row = [indexPath row];
    
    
    if (4 == row) {
        ContactCellView *cell =(ContactCellView *) [tableView dequeueReusableCellWithIdentifier:ContactCellViewIdentifier forIndexPath:indexPath];
        
        if (nil == cell) {
            cell = [[ContactCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ContactCellViewIdentifier];
        }
        
        [cell updateEmail:appDelegate.mailAddress andMessage:appDelegate.smsAddress];
        
        return cell;
    }
    else{
    
        NormalCellView *cell = (NormalCellView *) [tableView dequeueReusableCellWithIdentifier:NormalCellViewIdentifier  forIndexPath:indexPath];
        
        if (nil == cell) {
            cell = [[NormalCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NormalCellViewIdentifier];
        }
        
        NSString* title = [settings objectAtIndex:row];
        
        switch (row) {
            case 0:
                {
                    [cell updateTitle:title andDetail:[sensitvities objectAtIndex:appDelegate.sensitvity] andChecked:NO];
                }
                break;
            case 1:
                {
                    [cell updateTitle:title andDetail:[sleepingTimeList objectAtIndex:appDelegate.sleepingTime] andChecked:NO];
                }
                break;
            case 2:
                {
                    [cell updateTitle:title andDetail:[movieDurationList objectAtIndex:appDelegate.movieDuration] andChecked:NO];
                }
                break;
            case 3:
                {
                    [cell updateTitle:title andDetail:[EvList objectAtIndex:appDelegate.evSetting] andChecked:NO];
                }
                break;
            default:
                {
                    [cell updateTitle:title andDetail:@"" andChecked:NO];
                }
                break;
        }
        
        
        
        
       
    
        return cell;
    }
    
    
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = [indexPath row];
    
    switch (row) {
            
        case 0:
            // 警示靈敏度
            {
                [self performSegueWithIdentifier:@"moveToSensitvityViewSegue" sender:self];
            }
            break;
        case 1:
            // 休眠時間
            {
                [self performSegueWithIdentifier:@"moveToSleepingTimeViewSegue" sender:self];
            }
            break;
        case 2:
            // 影片長度
            {
                [self performSegueWithIdentifier:@"moveToDurationViewSegue" sender:self];
            }
            break;
        case 3:
            // EV設定
            {
                [self performSegueWithIdentifier:@"moveToEVSettingViewSegue" sender:self];
            }
            break;
        case 4:
            // SOS功能
            {
                [self performSegueWithIdentifier:@"moveToSOSViewSegue" sender:self];
            }
            break;
        case 5:
            // 故障診斷
            {
                
            }
            break;
        case 6:
            // 韌體更新
            {
                
            }
            break;
        default:
            break;
    }
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"moveToSensitvityViewSegue"]) {
        SensitvityViewController* destinationViewController = (SensitvityViewController*) segue.destinationViewController;
        
        if (destinationViewController) {
            [destinationViewController setTitle:@"警示靈敏度"];
        }
    }
    
    if ([segue.identifier isEqualToString:@"moveToSleepingTimeViewSegue"]) {
        SleepingTimeViewController* destinationViewController = (SleepingTimeViewController*) segue.destinationViewController;
        
        if (destinationViewController) {
            [destinationViewController setTitle:@"休眠時間"];
        }
    }
    
    if ([segue.identifier isEqualToString:@"moveToDurationViewSegue"]) {
        DurationViewController* destinationViewController = (DurationViewController*) segue.destinationViewController;
        
        if (destinationViewController) {
            [destinationViewController setTitle:@"影片長度"];
        }
    }
    
    if ([segue.identifier isEqualToString:@"moveToEVSettingViewSegue"]) {
        EVSettingViewController* destinationViewController = (EVSettingViewController*) segue.destinationViewController;
        
        if (destinationViewController) {
            [destinationViewController setTitle:@"EV設定"];
        }
    }
    
    if ([segue.identifier isEqualToString:@"moveToSOSViewSegue"]) {
        SOSViewController* destinationViewController = (SOSViewController*) segue.destinationViewController;
        
        if (destinationViewController) {
            [destinationViewController setTitle:@"SOS功能"];
        }
    }
    

}


@end
