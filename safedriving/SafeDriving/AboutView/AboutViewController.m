//
//  AboutViewController.m
//  SafeDriving
//
//  Created by 房懷安 on 2015/8/19.
//  Copyright (c) 2015年 Fang Huai An. All rights reserved.
//

#import "AboutViewController.h"

#import "AppDelegate.h"

@interface AboutViewController ()
{
    AppDelegate *appDelegate;
    
    IBOutlet UITextField *txtMessage ;
    IBOutlet UIButton *btnSend ;
    
    IBOutlet UITextField *txtEuslopeNumber ;
    IBOutlet UITextField *txtInitRowNumber ;
    
    IBOutlet UIButton *btnSendMail ;
}

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    [self setTitle:@"About"];
    
    //
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //[appDelegate.tcpWorker joinChat];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    [appDelegate setShowAlert:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Mail

- (void)displayMailComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"SOS"];
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:appDelegate.mailAddress];
    //NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    //NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
    
    [picker setToRecipients:toRecipients];
    //[picker setCcRecipients:ccRecipients];
    //[picker setBccRecipients:bccRecipients];
    
    // Attach an image to the email
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SOS" ofType:@"jpg"];
    NSData *myData = [NSData dataWithContentsOfFile:path];
    [picker addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"sos"];
    
    // Fill out the email body text
    // {Leon_Huang20170718+
    //NSString *emailBody = @"<p>It is SOS message !  <p><br /><a href=""http://maps.google.com/maps?q=24.060256,120.385684"">Map</a>";
    NSString *emailBody = @"<p>It is SOS message !  <p><br /><a href=""http://maps.google.com/maps?q=24.0759285,120.4101187"">Map</a>";
    // Leon_Huang20170718-}
    
    [picker setMessageBody:emailBody isHTML:YES];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: Mail sending canceled" );
            break;
        case MFMailComposeResultSaved:
            NSLog( @"Result: Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog( @"Result: Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog( @"Result: Mail sending failed");
            break;
        default:
            NSLog( @"Result: Mail not sent");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Buttons' Event

- (IBAction) btnSendMailClicked :(id)sender{

    [self displayMailComposerSheet];

}



- (IBAction) btnSendClicked :(UIButton *)sender {

    [appDelegate.tcpWorker sendMessage:[NSString stringWithFormat:@"msg:%@", [txtMessage text]]];
}

- (IBAction) btnSendEuslopeClicked :(UIButton *)sender {
    
    NSString *message = [NSString stringWithFormat:@"euslope %@", [txtEuslopeNumber text]];
    
    [appDelegate.tcpWorker sendMessage:message];
}

- (IBAction) btnSendInitRowClicked :(UIButton *)sender {
    
    NSString *message = [NSString stringWithFormat:@"initRow %@", [txtInitRowNumber text]];
    
    [appDelegate.tcpWorker sendMessage:message];
}

- (IBAction) btnCloseClicked :(UIButton * )sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
