#import "WelcomeViewController.h"
#import "WebsiteViewController.h"
#import <MessageUI/MessageUI.h>

//TODO: move defines to plist
#define ABOUT_FILE_NAME @"AboutUs"
#define ABOUT_FILE_TYPE @"rtf"
#define BELIEVE_FILE_NAME @"WhatWeBelieve"
#define BELIEVE_FILE_TYPE @"html"
#define JESUS_URL @"http://www.matthiasmedia.com.au/2wtl/2wtlonline.html"
#define SGCC_PHONE @"telprompt://16262870486"
#define SGCC_EMAIL @"zombieonrails@gmail.com"
#define SGCC_URL @"http://sgucandcs.org/#/home/welcome"

@interface WelcomeViewController ()
  <UIActionSheetDelegate,MFMailComposeViewControllerDelegate>
@end

@implementation WelcomeViewController
#pragma mark - Storyboard-related methods
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WebsiteViewController *controller = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"whoIsJesusSegue"]) {
        controller.websiteURL = [NSURL URLWithString:JESUS_URL];
        controller.title = @"Who Is Jesus?";
    } else if ([segue.identifier isEqualToString:@"whatWeBelieveSegue"]) {
        NSString *path = [NSBundle.mainBundle pathForResource:BELIEVE_FILE_NAME
                                                       ofType:BELIEVE_FILE_TYPE];
        controller.websiteURL = [NSURL fileURLWithPath:path];
        controller.title = @"What We Believe";
    } else if ([segue.identifier isEqualToString:@"aboutUsSegue"]) {
        NSString *path = [NSBundle.mainBundle pathForResource:ABOUT_FILE_NAME
                                                       ofType:ABOUT_FILE_TYPE];
        controller.websiteURL = [NSURL fileURLWithPath:path];
        controller.title = @"About Us";
    } else if ([segue.identifier isEqualToString:@"showWebsiteSegue"]) {
        controller.websiteURL = [NSURL URLWithString:SGCC_URL];
        controller.title = @"SGCCandCS.org";
    }
}
-(IBAction)contactButtonClicked:(id)sender {
    [[[UIActionSheet alloc] initWithTitle:@"Contact Us"
                                 delegate:self
                        cancelButtonTitle:@"Cancel"
                   destructiveButtonTitle:nil
                        otherButtonTitles:@"Call",
                                          @"Email",
                                          @"Visit",
                                          @"Website",
                                          nil]
      showFromTabBar:self.tabBarController.tabBar];
}
#pragma mark - UIActionSheetDelegate Methods
-(void)showEmail
{
    MFMailComposeViewController *mailComposeVC = MFMailComposeViewController.new;
    mailComposeVC.mailComposeDelegate = self;
    [mailComposeVC setSubject:@"Contact from SGCC App"];
    [mailComposeVC setMessageBody:@"" isHTML:NO];
    [mailComposeVC setToRecipients:@[SGCC_EMAIL]];
    [self presentViewController:mailComposeVC animated:YES completion:NULL];
}
-(void)  actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: //Call
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SGCC_PHONE]];
            break;
        case 1: //Email
            [self showEmail];
            break;
        case 2: //Visit
            [self performSegueWithIdentifier:@"visitSegue" sender:self];
            break;
        case 3: //Website
            [self performSegueWithIdentifier:@"showWebsiteSegue" sender:self];
            break;
    }
}
#pragma mark - MailComposeDelegate Methods
-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result
                       error:(NSError *)error
{
    NSString *message = @"";
    NSString *messageTitle = @"";
    switch (result)
    {
        case MFMailComposeResultCancelled:
            message = @"Your email will not be sent.";
            messageTitle = @"Email Cancelled";
            break;
        case MFMailComposeResultSaved:
            message = @"Thank You!  We will contact you as soon as possible.";
            messageTitle = @"Thank You";
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            message = @"Thank You!  We will contact you as soon as possible.";
            messageTitle = @"Thank You";
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            message = @"We had a problem!  Please try again later.";
            messageTitle = @"Sorry";
            NSLog(@"Mail sent failure: %@", error.localizedDescription);
            break;
        default:
            break;
    }
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:^(void)
    {
        [[[UIAlertView alloc] initWithTitle:messageTitle
                                    message:message
                                   delegate:self
                          cancelButtonTitle:@"Done"
                          otherButtonTitles:nil] show];
    }];
}
@end