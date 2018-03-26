//
//  TcpWorker.m
//  SafeDriving
//
//  Created by 房懷安 on 2015/8/20.
//  Copyright (c) 2015年 Fang Huai An. All rights reserved.
//

#import "TcpWorker.h"

@implementation TcpWorker

@synthesize inputStream;
@synthesize outputStream;

- (void) initNetworkCommunicationWithIpAddress:(NSString *) ipAddress andPort:(int) port {
    
    CFStringRef ipAddressCFStringRef = (__bridge CFStringRef) ipAddress;
    // 
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, ipAddressCFStringRef, port, &readStream, &writeStream);
    //CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"192.168.1.105", 3333, &readStream, &writeStream);
    
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
    
}

- (void) joinChat {
    NSString *response  = [NSString stringWithFormat:@"iam:tester"];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
    
}

- (void) sendMessage : (NSString *) message  {
    
    NSString *response  = [NSString stringWithFormat:@"%@", message];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}


- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    NSLog(@"stream event %lu", (unsigned long)streamEvent);
    
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            {
                NSLog(@"Stream opened");
                [status setString:@"OPENED"];
            }
            break;
        case NSStreamEventHasBytesAvailable:
            
            if (theStream == inputStream) {
                
                uint8_t buffer[1024];
                int len;
                
                while ([inputStream hasBytesAvailable]) {

                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (nil != output) {
                            
                            NSLog(@"server said: %@", output);

                        }
                    }
                }
                
                [status setString:@"CONNECTED"];
            }
            break;
            
            
        case NSStreamEventErrorOccurred:
            {
                [status setString:@"FAILED"];
                NSLog(@"Can not connect to the host!");
            }
            break;
            
        case NSStreamEventEndEncountered:
            {
                [status setString:@"CLOSED"];
                [theStream close];
                [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
                theStream = nil;
            }
            break;
        default:
            {
                [status setString:@"UNKNOWN"];
                NSLog(@"Unknown event");
            }
            break;
    }
    
}



@end
