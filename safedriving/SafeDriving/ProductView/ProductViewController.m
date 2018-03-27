//
//  ProductViewController.m
//  SafeDriving
//
//  Created by 房懷安 on 2015/8/19.
//  Copyright (c) 2015年 Fang Huai An. All rights reserved.
//

#import "ProductViewController.h"

#import "MenuItemCellView.h"

@interface ProductViewController ()
{
    BOOL isRecording;
    
    AVCaptureSession *captureSession;
    AVCaptureMovieFileOutput *movieFileOutput;
    AVCaptureDeviceInput *videoInputDevice;
    
    AVCaptureVideoPreviewLayer *previewLayer;
    
    NSArray *menuItems;
    
    IBOutlet UIView *menuView;
    IBOutlet UITableView *menuTable;
    
    IBOutlet UIView *cameraView;
    
    IBOutlet UIImageView *redView ;
    IBOutlet UIImageView *greenView ;
    IBOutlet UIPanGestureRecognizer *redViewPan;
    IBOutlet UIPanGestureRecognizer *greenViewPan;
    
}

@end

@implementation ProductViewController

static NSString *MenuItemCellViewIdentifier = @"MenuItemCellView";

#pragma mark - View's Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if ([self initialVideoInputDevice]) {
        [captureSession startRunning];
    }
    
    [cameraView setBackgroundColor:[UIColor clearColor]];
    
    menuItems = @[@"ADAS", @"設定", @"檔案", @"關於"];
    [menuTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [menuTable setSeparatorColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
     
     [menuView setHidden:YES];
}

- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

- (IBAction) handlePan :(UIPanGestureRecognizer *) recognizer {
    
    CGPoint translation = [recognizer translationInView:self.view];
    //recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    
    CGFloat yLocation = recognizer.view.center.y + translation.y ;
    
    NSLog(@"yLocation:%f", yLocation);
    
    recognizer.view.center = CGPointMake(recognizer.view.center.x , yLocation);
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    /*
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [recognizer velocityInView:self.view];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
        
        float slideFactor = 0.1 * slideMult; // Increase for more of a slide
        CGPoint finalPoint = CGPointMake(recognizer.view.center.x + (velocity.x * slideFactor),
                                         recognizer.view.center.y + (velocity.y * slideFactor));
        finalPoint.x = MIN(MAX(finalPoint.x, 0), self.view.bounds.size.width);
        finalPoint.y = MIN(MAX(finalPoint.y, 0), self.view.bounds.size.height);
        
        [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            recognizer.view.center = finalPoint;
        } completion:nil];
        
    }
    */
}


#pragma mark - Buttons' Event

- (IBAction) btnMenuClicked : (UIButton *) sender {
    
    if ([menuView isHidden]) {
        [menuView setHidden:NO];
    }
    else{
        [menuView setHidden:YES];
    }
}


#pragma mark - Video


- (BOOL) initialVideoInputDevice{

    captureSession = [[AVCaptureSession alloc] init];

    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (videoDevice) {
        
        NSError *error;
        
        videoInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        
        if (!error) {
            
            if ([captureSession canAddInput:videoInputDevice]) {
                [captureSession addInput:videoInputDevice];
            }
            else{
                return NO;
            }
        }
        else{
            NSLog(@"initialVideoInputDevice failed:%@", [error localizedDescription]);
            return NO;
        }
    }
    
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];

    if (audioDevice) {
        
        NSError *error;
        
        AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
        
        if (!error) {
            if ([captureSession canAddInput:audioInput]) {
                [captureSession addInput:audioInput];
            }
            else{
                NSLog(@"initialVideoInputDevice failed:%@", [error localizedDescription]);
                return NO;
            }
        }
        else{
            return NO;
        }
        
    }
    else{
        return NO;
    }
    
    //
    previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //
    movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    Float64 totalSeconds = 60;
    int32_t preferredTimeScale = 30;
    CMTime maxDuration = CMTimeMakeWithSeconds(totalSeconds, preferredTimeScale);
    
    // TODO : need to modify.
    movieFileOutput.maxRecordedDuration = maxDuration;
    movieFileOutput.minFreeDiskSpaceLimit = 1024 * 1024 ;
   
    if ([captureSession canAddOutput:movieFileOutput]) {
        [captureSession addOutput:movieFileOutput];
    }
    
    //	AVCaptureSessionPresetHigh - Highest recording quality (varies per device)
    //	AVCaptureSessionPresetMedium - Suitable for WiFi sharing (actual values may change)
    //	AVCaptureSessionPresetLow - Suitable for 3G sharing (actual values may change)
    //	AVCaptureSessionPreset640x480 - 640x480 VGA (check its supported before setting it)
    //	AVCaptureSessionPreset1280x720 - 1280x720 720p HD (check its supported before setting it)
    //	AVCaptureSessionPresetPhoto - Full photo resolution (not supported for video output)
    [captureSession setSessionPreset:AVCaptureSessionPresetMedium];
    
    //
    [previewLayer setFrame:[self.view bounds]];
    [[cameraView layer] addSublayer:previewLayer];
    
    
    
    return YES;
}

#pragma mark AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{

}

#pragma mark AVCaptureFileOutputRecordingDelegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{

}

#pragma mark - UITableViewDataSource and UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [menuItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MenuItemCellView *cell =(MenuItemCellView *) [tableView dequeueReusableCellWithIdentifier:MenuItemCellViewIdentifier forIndexPath:indexPath];
    
    if (nil == cell) {
        cell = [[MenuItemCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MenuItemCellViewIdentifier];
    }
    //
    
    [cell.lbTitle setText:[menuItems objectAtIndex:[indexPath row]]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (NO == [menuView isHidden]) {
        [menuView setHidden:YES];
    }
    
    NSInteger row = [indexPath row];
    
    // menuItems = @[@"ADAS", @"設定", @"檔案", @"關於"];
    switch (row) {
        case 0:
            {
                [self performSegueWithIdentifier:@"moveToADASViewSegue" sender:self];
            }
            break;
        case 1:
            {
                [self performSegueWithIdentifier:@"moveToSettingViewSegue" sender:self];
            }
            break;
        case 2:
            {
                [self performSegueWithIdentifier:@"moveToFileViewSegue" sender:self];
            }
            break;
        case 3:
            {
                [self performSegueWithIdentifier:@"moveToAboutViewSegue" sender:self];
            }
            break;
        default:
            break;
    }
    
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"moveToADASViewSegue"]) {
        
        
    }
    
    if ([segue.identifier isEqualToString:@"moveToSettingViewSegue"]) {
        
        
    }
    
    if ([segue.identifier isEqualToString:@"moveToFileViewSegue"]) {
        
        
    }
    
    if ([segue.identifier isEqualToString:@"moveToAboutViewSegue"]) {
        
        
    }
    
    
}


@end
