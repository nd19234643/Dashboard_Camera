//
//  ADASViewController.m
//  SafeDriving
//
//  Created by 房懷安 on 2015/8/19.
//  Copyright (c) 2015年 Fang Huai An. All rights reserved.
//

#import <IJKMediaFramework/IJKMediaFramework.h> // Leon_Huang, [RTSP Player]

#import "ADASViewController.h"
#import "AppDelegate.h"
#import "HttpRequestWorker.h"

@interface ADASViewController ()
{
    AppDelegate *appDelegate;
    
    IBOutlet UIImageView *imageView;
    float lastFrameTime;
    NSTimer *nextFrameTimer;
    
    IBOutlet UIImageView *redView;
    IBOutlet UIImageView *greenView;
    IBOutlet UILabel *lbEuslope;
    IBOutlet UILabel *lbInitRow;
    IBOutlet UISegmentedControl *ldwFcwSensitivity;
    
    IBOutlet UISwitch *switchADASOnOff;
    IBOutlet UIButton *btnConfirm;
    
    IBOutlet UIPanGestureRecognizer *redViewPan;
    IBOutlet UIPanGestureRecognizer *greenViewPan;
    
    IBOutlet NSLayoutConstraint *redViewTopConstraint;
    IBOutlet NSLayoutConstraint *greenViewTopConstraint;
    
    Float64 outputFactor;
    int videoHeight;
    CGFloat videoY;
    
    CGFloat euslope;
    CGFloat initRow;
    
    // (Leon_Huang+ [RTSP Player]
    NSTimer *removePlayerTimer;
    NSTimer *restartPlayerTimer;
    // Leon_Huang-)
}

// (Leon_Huang+ [RTSP Player]
@property(atomic,strong) NSURL *url;
@property(atomic, retain) id<IJKMediaPlayback> player;
// Leon_Huang-)

@end

@implementation ADASViewController

#pragma mark - view controller life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    [self setTitle:@"ADAS"];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // (Leon_Huang+ [RTSP Player]
    self.url = [[NSURL alloc] initWithString:@"rtsp://192.168.1.254/sjcam.mov"];
    //self.url = [NSURL URLWithString:@"rtsp://192.168.1.254/sjcam.mov"];
    
#ifdef DEBUG
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
#else
    [IJKFFMoviePlayerController setLogReport:NO];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
#endif
    
    [self setupPlayer];
    // Leon_Huang-)
    
    // red line
    
    // green line
    
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
}

// (Leon_Huang+ [RTSP Player]
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self installMovieNotificationObservers];
    
    [self.player prepareToPlay];
}
// Leon_Huang-)


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    // (Leon_Huang+ [RTSP Player]
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)
    {
        NSLog(@"Device orientation is Portrait");
        CGRect windowRect = [[UIScreen mainScreen] bounds];
        int videoWidth = windowRect.size.width;
        videoHeight = videoWidth * (windowRect.size.width / windowRect.size.height);
        videoY = (imageView.frame.size.height - videoHeight)/2;
        
        redViewTopConstraint.constant = (imageView.frame.size.height / 2) - 9;
        greenViewTopConstraint.constant = videoHeight / 4 - 18;
        
        outputFactor = 1080.0f / videoHeight;
    }
    else
    {
        NSLog(@"Device orientation is %ld", [UIApplication sharedApplication].statusBarOrientation);
        // Add the code which you want
    }
    
    removePlayerTimer = [NSTimer scheduledTimerWithTimeInterval:(60.0 * 10.0) target:self selector:@selector(removePlayer:) userInfo:nil repeats:YES];
    // Leon_Huang-)
}

// (Leon_Huang+ [RTSP Player]
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [removePlayerTimer invalidate];
    removePlayerTimer = nil;
    
    [restartPlayerTimer invalidate];
    restartPlayerTimer = nil;
    
    [self.player shutdown];
    [self removeMovieNotificationObservers];
}
// Leon_Huang-)

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// (Leon_Huang+ [RTSP Player]
- (void)dealloc {
    NSLog(@"Dealloc ADAS View Controller");
}

#pragma mark - tool methods
- (void)setupPlayer {
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    // [IJKFFMoviePlayerController checkIfPlayerVersionMatch:YES major:1 minor:0 micro:0];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:options];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = self.view.bounds;
    self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
    self.player.shouldAutoplay = YES;
    
    self.view.autoresizesSubviews = YES;
    [self.view addSubview:self.player.view];
    //[self.view bringSubviewToFront:self.button];
    [self.view sendSubviewToBack:self.player.view];
}

- (void)removePlayer:(NSTimer *)timer {
    NSLog(@"Times up, remove player");
    
    [self.player.view removeFromSuperview];
    [self.player shutdown];
    
    restartPlayerTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(restartPlayer:) userInfo:nil repeats:NO];
}

- (void)restartPlayer:(NSTimer *)timer {
    NSLog(@"Times up, restart player");
    
    [self setupPlayer];
    [self.player prepareToPlay];
}

#pragma mark - Observers methods
- (void)loadStateDidChange:(NSNotification *)notification
{
    //    MPMovieLoadStateUnknown        = 0,
    //    MPMovieLoadStatePlayable       = 1 << 0,
    //    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
    
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackDidFinish:(NSNotification *)notification
{
    //    MPMovieFinishReasonPlaybackEnded,
    //    MPMovieFinishReasonPlaybackError,
    //    MPMovieFinishReasonUserExited
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    switch (reason)
    {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification *)notification
{
    NSLog(@"mediaIsPreparedToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification *)notification
{
    //    MPMoviePlaybackStateStopped,
    //    MPMoviePlaybackStatePlaying,
    //    MPMoviePlaybackStatePaused,
    //    MPMoviePlaybackStateInterrupted,
    //    MPMoviePlaybackStateSeekingForward,
    //    MPMoviePlaybackStateSeekingBackward
    
    switch (_player.playbackState)
    {
        case IJKMPMoviePlaybackStateStopped: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

#pragma mark - Install Movie Notifications

/* Register observers for the various movie object notifications. */
-(void)installMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
}

#pragma mark - Remove Movie Notification Handlers

/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
}
// Leon_Huang-)

#pragma mark - Gesture
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"touchesEnded");
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:self.view];
    //recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    
    NSLog(@"translation.y:%f", translation.y);
    
    CGFloat locationY = recognizer.view.center.y + translation.y;
    
    if (locationY < videoY)
    {
        locationY = videoY + 3;
    }
    else if ((locationY > (videoY + videoHeight)) && (translation.y > 0))
    {
        locationY = videoY + videoHeight + 3;
    }
    
    
    recognizer.view.center = CGPointMake(recognizer.view.center.x, locationY);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    CGFloat innerY = locationY - videoY - 3;
    CGFloat phase = 1080 - (innerY * outputFactor);
    
    if (123 == recognizer.view.tag)
    {
        euslope = phase;
        
        NSLog(@"redView locationY:%f;innerY:%f; euslope:%f", locationY, innerY, euslope);
        
        if (locationY < videoY)
        {
            redViewTopConstraint.constant = videoY;
        }
        else if ((locationY > (videoY + videoHeight)) && (translation.y > 0))
        {
            redViewTopConstraint.constant = videoY + videoHeight;
        }
        else {
            redViewTopConstraint.constant += translation.y;
            greenViewTopConstraint.constant -= translation.y;
        }
        
        NSString *message = [NSString stringWithFormat:@"euslope %f", euslope];
        [lbEuslope setText:message];
        //[tcpWorker sendMessage:message];
    }
    else if (456 == recognizer.view.tag)
    {
        initRow = phase;
        
        NSLog(@"greenView locationY:%f;innerY:%f; initRow:%f", locationY, innerY, initRow);
        
        
        if (locationY < videoY)
        {
            greenViewTopConstraint.constant = videoY - redViewTopConstraint.constant + 3;
        }
        else if((locationY > (videoY + videoHeight)) && (translation.y > 0))
        {
            greenViewTopConstraint.constant = (videoY + videoHeight) - redViewTopConstraint.constant - 3;
        }
        else
        {
            //redViewTopConstraint.constant -= translation.y;
            greenViewTopConstraint.constant +=  translation.y;
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

#pragma mark - Events trigger
- (IBAction)ldwFcwSensitivityValueChanged:(id)sender {

    NSString *ldwFcw = [NSString stringWithFormat:@"sensitivity %d", (int)ldwFcwSensitivity.selectedSegmentIndex]; // sensitivity 0
    
    [appDelegate.tcpWorker sendMessage:ldwFcw];
}

- (IBAction)switchADASOnOffValueChanged:(UISwitch *)sender {
    
    NSString *message;
    
    if (switchADASOnOff.isOn)
    {
        message = [NSString stringWithFormat:@"ADAS 1"];
    }
    else
    {
        message = [NSString stringWithFormat:@"ADAS 0"];
    }
    
    [appDelegate.tcpWorker sendMessage:message];
}

- (IBAction)btnConfirmClicked:(UIButton *)sender {
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
