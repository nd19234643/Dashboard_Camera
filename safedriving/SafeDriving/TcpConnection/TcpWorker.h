//
//  TcpWorker.h
//  SafeDriving
//
//  Created by 房懷安 on 2015/8/20.
//  Copyright (c) 2015年 Fang Huai An. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TcpWorker : NSObject<NSStreamDelegate>
{
    NSInputStream	*inputStream;
    NSOutputStream	*outputStream;
    
    NSMutableString *status ;
}

@property (strong) NSInputStream *inputStream;
@property (strong) NSOutputStream *outputStream;

- (void) initNetworkCommunicationWithIpAddress:(NSString *) ipAddress andPort:(int) port;

- (void) sendMessage : (NSString *) message ;

- (void) joinChat;

@end
