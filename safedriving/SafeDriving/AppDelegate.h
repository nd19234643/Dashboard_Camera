//
//  AppDelegate.h
//  SafeDriving
//
//  Created by 房懷安 on 2015/8/19.
//  Copyright (c) 2015年 Fang Huai An. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TcpWorker.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong) TcpWorker *tcpWorker;

@property (assign) NSInteger sensitvity;
@property (assign) NSInteger sleepingTime;
@property (assign) NSInteger movieDuration;
@property (assign) NSInteger evSetting;
@property (strong) NSString *mailAddress;
@property (assign) NSInteger ldwFcw;
@property (strong) NSString *smsAddress;

@property (assign) BOOL showAlert;

@end

