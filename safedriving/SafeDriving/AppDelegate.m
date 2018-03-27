//
//  AppDelegate.m
//  SafeDriving
//
//  Created by 房懷安 on 2015/8/19.
//  Copyright (c) 2015年 Fang Huai An. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger sensitvity = [userDefaults integerForKey:@"sensitvity"];
    if (0 == sensitvity) {
        sensitvity = 1;
    }
    [self setSensitvity:sensitvity];
    
    NSInteger sleepingTime =[userDefaults integerForKey:@"sleepingTime"];
    if (0 == sleepingTime) {
        sleepingTime = 1 ;
    }
    [self setSleepingTime: sleepingTime];
    
    NSInteger movieDuration = [userDefaults integerForKey:@"movieDuration"];
    if (0 == movieDuration) {
        movieDuration = 1;
    }
    [self setMovieDuration:movieDuration];
    
    NSInteger evSetting = [userDefaults integerForKey:@"evSetting"];
    if (0 == evSetting) {
        evSetting = 0;
    }
    [self setEvSetting:evSetting];
    
    NSString* mailAddress = [userDefaults stringForKey:@"mailAddress"];
    if (nil == mailAddress) {
        mailAddress = [NSString stringWithFormat:@""];
    }
    [self setMailAddress: mailAddress];
    
    NSString* smsAddress =  [userDefaults stringForKey:@"smsAddress"];
    if (nil == smsAddress) {
        smsAddress = [NSString stringWithFormat:@""];
    }
    [self setSmsAddress: smsAddress];
    
    NSInteger ldwfcw = [userDefaults integerForKey:@"ldwfcw"];
    if (0 == ldwfcw) {
        ldwfcw = 1;
    }
    [self setLdwFcw:ldwfcw];
    
    [self setShowAlert:NO];
    
    self.tcpWorker = [[TcpWorker alloc] init];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
