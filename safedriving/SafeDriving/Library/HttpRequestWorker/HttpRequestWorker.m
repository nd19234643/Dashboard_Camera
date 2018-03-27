//
//  HttpRequestWorker.m
//  SafeDriving
//
//  Created by 房懷安 on 2015/8/26.
//  Copyright (c) 2015年 Fang Huai An. All rights reserved.
//

#import "HttpRequestWorker.h"

@implementation HttpRequestWorker

+ (id) sharedWorker{

    static HttpRequestWorker *worker = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        worker = [[super alloc] init];
    
    });

    return worker;

}


- (NSString *) requestWithUrl :(NSString *) url{

    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"GET"];
    
    
    NSURLResponse *urlResponse ;
    NSError *error ;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error];
    
    if (error) {
        NSLog(@"ERROR:%@", [error localizedDescription]);
        
        return [error localizedDescription];
    }
    else{
        
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        //NSLog(@"response:%@", responseString);
        
        return responseString;
    }


}

@end
