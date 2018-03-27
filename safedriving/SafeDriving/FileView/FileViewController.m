//
//  FileViewController.m
//  SafeDriving
//
//  Created by 房懷安 on 2015/8/19.
//  Copyright (c) 2015年 Fang Huai An. All rights reserved.
//

#import "FileViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>

#import "MBProgressHUD.h"

@interface FileViewController ()
{
    IBOutlet UIWebView *fileView;
    
    MBProgressHUD *hud ;
}

@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;

@end

@implementation FileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    [self setTitle:@"File"];
    
    // {Leon_Huang20170413+ [Fix bug: Can't connect to http file server]
    //[fileView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.254/NOVATEK/MOVIE"]]];
    
    //[fileView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.254/?custom=1&cmd=3015"]]];
    
    //[fileView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://appspot.azurewebsites.net/ARTC/VideoFile.html"]]];
    // Leon_Huang20170413-}
    
    [fileView setScalesPageToFit:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCloseClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// {Leon_Huang20170413+ [Fix bug: Can't connect to http file server]
- (IBAction)clickedVideoButton:(id)sender {
    
    [fileView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.254/WINWISE/MOVIE"]]];
    
    self.videoButton.hidden = YES;
    self.photoButton.hidden = YES;
}

- (IBAction)clickedPhotoButton:(id)sender {
    [fileView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.254/WINWISE/PHOTO"]]];
    
    self.videoButton.hidden = YES;
    self.photoButton.hidden = YES;
}
// Leon_Huang20170413-}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if(navigationType == UIWebViewNavigationTypeLinkClicked) {
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something...
            NSURL *requestedURL = [request URL];
            
            NSData *fileData = [[NSData alloc] initWithContentsOfURL:requestedURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            
            if (nil != fileData) {
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
                
                NSString *fileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, [requestedURL lastPathComponent]];
                
                [fileData writeToFile:fileName atomically:YES];
                
                //UISaveVideoAtPathToSavedPhotosAlbum(fileName, nil, nil, nil);
                
                NSURL *movieUrl = [NSURL fileURLWithPath:fileName];
                
                ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
                
                // {Leon_Huang20170413+ [Save photo to camera roll]
                [library writeImageDataToSavedPhotosAlbum:fileData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                    // error handling
                    if (error != nil) {
                        
                        return;
                    }
                    
                    NSLog(@"assetURL: %@", assetURL); //assets-library://asset/asset.JPG?id=43BA67DA-B834-4473-95D5-61BEB58114D0&ext=JPG
                }];
                // Leon_Huang20170413-}
                
                [library writeVideoAtPathToSavedPhotosAlbum:movieUrl completionBlock:^(NSURL *assetURL, NSError *error){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    });
                    
                    if (nil == error) {
                        NSLog(@"assetURL:%@", assetURL) ;
                        
                        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"Record"
                                                                                                   message: @"File Saved"
                                                                                            preferredStyle:UIAlertControllerStyleAlert                   ];
                        
                        UIAlertAction* ok = [UIAlertAction
                                             actionWithTitle:@"OK"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action)
                                             {
                                                 [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                             }];
                        
                        [myAlertController addAction: ok];
                        
                        [self presentViewController:myAlertController animated:YES completion:nil];
                    }
                    
                }];
            }

            
            
        });
        
        return NO;
        
    }
    
    return YES;
}

- (void) saveFileCompleted {
    NSLog(@"OK!");
}

@end
