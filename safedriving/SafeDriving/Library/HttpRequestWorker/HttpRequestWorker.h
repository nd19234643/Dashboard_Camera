//
//  HttpRequestWorker.h
//  SafeDriving
//
//  Created by 房懷安 on 2015/8/26.
//  Copyright (c) 2015年 Fang Huai An. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequestWorker : NSObject

+(id) sharedWorker ;

- (NSString *) requestWithUrl :(NSString *) url;

@end
