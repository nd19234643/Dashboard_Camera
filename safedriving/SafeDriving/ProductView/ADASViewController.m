//
//  ADASViewController.m
//  SafeDriving
//
//  Created by 房懷安 on 2015/8/19.
//  Copyright (c) 2015年 Fang Huai An. All rights reserved.
//

#import "ADASViewController.h"

#import "RTSPPlayer.h"
#import "AppDelegate.h"
#import "HttpRequestWorker.h"

@interface ADASViewController ()
{
    AppDelegate *appDelegate;
    
    IBOutlet UIImageView *imageView;
    RTSPPlayer *video;
    float lastFrameTime;
    NSTimer *nextFrameTimer;
    
    IBOutlet UIImageView *redView ;
    IBOutlet UIImageView *greenView ;
    IBOutlet UILabel *lbEuslope;
    IBOutlet UILabel *lbInitRow;
    IBOutlet UISegmentedControl *ldwFcwSensitivity;
    
    IBOutlet UISwitch *switchADASOnOff;
    IBOutlet UIButton *btnConfirm;
    
    IBOutlet UIPanGestureRecognizer *redViewPan;
    IBOutlet UIPanGestureRecognizer *greenViewPan;
    
    IBOutlet NSLayoutConstraint *redViewTopConstraint ;
    IBOutlet NSLayoutConstraint *greenViewTopConstraint ;
    

    Float64 outputFactor ;
    int videoHeight ;
    CGFloat videoY ;
    CGFloat videoFactor;
    
    CGFloat euslope;
    CGFloat initRow;
}

@end

@implementation ADASViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    [self setTitle:@"ADAS"];
    //
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //
    
    //video =[[RTSPPlayer alloc] initWithVideo:@"rtsp://192.168.1.254/xxx.mp4" usesTcp:NO];
    
    video =[[RTSPPlayer alloc] initWithVideo:@"rtsp://192.168.1.254/sjcam.mov" usesTcp:NO];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    videoFactor =  screenBounds.size.width / video.sourceWidth ;
    
    video.outputWidth = video.sourceWidth *  videoFactor; // 1/4
    video.outputHeight =  video.sourceHeight *  videoFactor ; // 1/4
    videoHeight = video.outputHeight;
    NSLog(@" video.sourceWidth:%d, video.sourceHeight:%d", video.sourceWidth, video.sourceHeight);
    
    // red line
    
    
    // green line
    
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [self playVideo:nil];
    
}


- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    
    // image's Left Top
    videoY = ((  imageView.frame.size.height - video.outputHeight  )/ 2 ) ;
    
    NSLog(@"imageView.frame.size.height:%f, video.outputHeight:%d, videoY:%f", imageView.frame.size.height, video.outputHeight, videoY);
    
    redViewTopConstraint.constant = ( imageView.frame.size.height / 2 ) - 9 ;
    greenViewTopConstraint.constant =  video.outputHeight  / 4 - 18 ;

    
    outputFactor = 1080.0f / video.outputHeight   ;
    

}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"touchesEnded");

}


- (IBAction) handlePan :(UIPanGestureRecognizer *) recognizer {
    
    
    
    CGPoint translation = [recognizer translationInView:self.view];
    //recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    
    NSLog(@"translation.y:%f", translation.y) ;
    
    CGFloat locationY = recognizer.view.center.y + translation.y  ;
    
    if (locationY < videoY ) {
        locationY = videoY +3 ;
    }
    else if(( locationY > (videoY + videoHeight ) ) && (translation.y > 0 )){
        locationY = videoY + videoHeight + 3 ;
    }
    
    
    recognizer.view.center = CGPointMake(recognizer.view.center.x , locationY );
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    CGFloat innerY =  locationY - videoY - 3 ;
    CGFloat phase = 1080  - ( innerY  * outputFactor ) ;
    
    if( 123 == recognizer.view.tag ){
        euslope = phase;
        
        NSLog(@"redView locationY:%f;innerY:%f; euslope:%f", locationY, innerY, euslope);
        
        if (locationY < videoY  ) {
            redViewTopConstraint.constant = videoY  ;
        }
        else if(( locationY > (videoY + videoHeight ) ) && (translation.y > 0 )){
            redViewTopConstraint.constant = videoY + videoHeight  ;
        }
        else{
            redViewTopConstraint.constant += translation.y  ;
            greenViewTopConstraint.constant -=  translation.y  ;
        }
        
        
        NSString *message = [NSString stringWithFormat:@"euslope %f", euslope];
        [lbEuslope setText:message];
        //[tcpWorker sendMessage:message];
    
    }
    else if(456 == recognizer.view.tag){
        initRow = phase;
        
        NSLog(@"greenView locationY:%f;innerY:%f; initRow:%f", locationY, innerY, initRow);
        
        
        if (locationY < videoY  ) {
            greenViewTopConstraint.constant = videoY - redViewTopConstraint.constant + 3 ;
        }
        else if(( locationY > (videoY + videoHeight ) ) && (translation.y > 0 )){
            greenViewTopConstraint.constant = (videoY + videoHeight)  - redViewTopConstraint.constant  - 3 ;
        }
        else{
            //redViewTopConstraint.constant -= translation.y  ;
            greenViewTopConstraint.constant +=  translation.y  ;
        }
        
        
        
        NSString *message = [NSString stringWithFormat:@"initRow %f", initRow];
        [lbInitRow setText:message];
        //[tcpWorker sendMessage:message];

    }
    
    
    
    
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


- (IBAction) playVideo:(id) sender {
    lastFrameTime = -1;
    
    // seek to 0.0 seconds
    [video seekTime:0.0];
    
    [nextFrameTimer invalidate];
    nextFrameTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 // 1.0/30
                                                           target:self
                                                         selector:@selector(displayNextFrame:)
                                                         userInfo:nil
                                                          repeats:YES];

}

#define LERP(A,B,C) ((A)*(1.0-C)+(B)*C)

-(void)displayNextFrame:(NSTimer *)timer
{
    NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
    if (![video stepFrame]) {
        [timer invalidate];
        [video closeAudio];
        return;
    }
    imageView.image = video.currentImage;
    float frameTime = 1.0/([NSDate timeIntervalSinceReferenceDate]-startTime);
    if (lastFrameTime<0) {
        lastFrameTime = frameTime;
    } else {
        lastFrameTime = LERP(frameTime, lastFrameTime, 0.8);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) ldwFcwSensitivityValueChanged :(id)sender {

    NSString *ldwFcw = [NSString stringWithFormat:@"sensitvity %d", (int)ldwFcwSensitivity.selectedSegmentIndex];
    [appDelegate.tcpWorker sendMessage:ldwFcw];
}

- (IBAction) switchADASOnOffValueChanged : (UISwitch *) sender {
    
    NSString *message;
    
    if (switchADASOnOff.isOn) {
        message = [NSString stringWithFormat:@"ADAS 1"];
    }
    else{
        message = [NSString stringWithFormat:@"ADAS 0"];
    }
    
    [appDelegate.tcpWorker sendMessage:message];
}

- (IBAction) btnConfirmClicked : (UIButton *) sender {
    NSString *euslopeMessage = [NSString stringWithFormat:@"euslope %f", euslope];
    NSString *initRowMessage = [NSString stringWithFormat:@"initRow %f", initRow];

    [appDelegate.tcpWorker sendMessage:euslopeMessage];
    [appDelegate.tcpWorker sendMessage:initRowMessage];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
