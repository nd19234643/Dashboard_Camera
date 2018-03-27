//
//  MenuViewController.m
//  SafeDriving
//
//  Created by 房懷安 on 2015/8/24.
//  Copyright (c) 2015年 Fang Huai An. All rights reserved.
//

#import "MenuViewController.h"

#import "AppDelegate.h"

#import "ImageMenuItemCellView.h"

@interface MenuViewController ()
{
    AppDelegate *appDelegate;
    
    IBOutlet UITableView *menuTable ;
    
    
    NSArray *menuItems ;
    
    NSArray *menuItemImageNames ;
}

@end

@implementation MenuViewController

static NSString *ImageMenuItemCellViewIdentifier = @"ImageMenuItemCellView";

- (void)viewDidLoad {
    [super viewDidLoad];
    // 
    [self.navigationController setNavigationBarHidden:NO];
    //
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //[appDelegate.tcpWorker initNetworkCommunicationWithIpAddress:@"192.168.1.246" andPort:3333];
    [appDelegate.tcpWorker initNetworkCommunicationWithIpAddress:@"192.168.1.254" andPort:3333];
    //
    menuItems = @[@"ADAS", @"設定", @"檔案", @"關於"];
    menuItemImageNames = @[@"adas", @"setting", @"file", @"about"];
    
    [menuTable setSeparatorColor:[UIColor clearColor]];
    

}


- (void)viewDidAppear:(BOOL)animated {
    if (NO == appDelegate.showAlert) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"收到SOS警示，是否傳出訊息" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
        [alert setTag:101];
        [alert show];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource and UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ImageMenuItemCellView *cell =  ( ImageMenuItemCellView * ) [tableView dequeueReusableCellWithIdentifier:ImageMenuItemCellViewIdentifier forIndexPath:indexPath];
    
    
    if (nil == cell) {
        cell =[[ImageMenuItemCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ImageMenuItemCellViewIdentifier];
    }
    
    NSString *title = [menuItems objectAtIndex:[indexPath row]];
    NSString *imageName = [menuItemImageNames objectAtIndex:[indexPath row]];
    
    [cell updateTitle:title andImage:imageName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = [indexPath row];
    
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

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSInteger tag = alertView.tag;
    
    switch (tag) {
        case 101:
            {
                if (1==buttonIndex) {
                    
                    [appDelegate setShowAlert:YES];
                    
                    //[self displayMailComposerSheet];
                    [self displaySMSComposerSheet];
                }
            }
            break;
            
        default:
            break;
    }


}

#pragma mark - Message

#pragma mark Mail

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
    // (Leon_Huang20170718+
    //NSString *emailBody = @"<p>It is SOS message !  <p><br /><a href=""http://maps.google.com/maps?q=24.060256,120.385684"">Map</a>";
    NSString *emailBody = @"<p>It is SOS message !  <p><br /><a href=""http://maps.google.com/maps?q=24.0759285,120.4101187"">Map</a>";
    // Leon_Huang20170718-)
    
    [picker setMessageBody:emailBody isHTML:YES];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {

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

#pragma mark SMS

- (void)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    
    // You can specify one or more preconfigured recipients.  The user has
    // the option to remove or add recipients from the message composer view
    // controller.
    /* picker.recipients = @[@"Phone number here"]; */
    
    // You can specify the initial message text that will appear in the message
    // composer view controller.
    
    [picker setSubject:@"SOS"];
    // (Leon_Huang20170718+
    //[picker setBody:@"It is SOS message !  \nhttp://maps.google.com/maps?q=24.060256,120.385684"];
    [picker setBody:@"It is SOS message !  \nhttp://maps.google.com/maps?q=24.0759285,120.4101187"];
    // Leon_Huang20170718-)
    
    if ([appDelegate.smsAddress length] > 0) {
        [picker setRecipients:@[appDelegate.smsAddress] ];
    }
    
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"SOS" ofType:@"jpg"];
    //NSData *myData = [NSData dataWithContentsOfFile:path];
    //[picker addAttachmentData:myData typeIdentifier:@"image/jpeg" filename:@"SOS.jpg"];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{

    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Result: SMS sending canceled") ;
            break;
        case MessageComposeResultSent:
            NSLog(@"Result: SMS sent" );
            break;
        case MessageComposeResultFailed:
            NSLog(@"Result: SMS sending failed" );
            break;
        default:
            NSLog(@"Result: SMS not sent" );
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)detectImage {
    
    //NSString *imagePath = @"http://192.168.1.254/ARTC/PICTURE/SOS";
    
    
    
    return YES;
}

@end
