//
//  WelcomeViewController.m
//  SGCC
//
//  Created by Johnathan Pulos on 1/3/13.
//  Copyright (c) 2013 Johnathan Pulos. All rights reserved.
//

#import "WelcomeViewController.h"
#import "WebsiteViewController.h"
#import <MessageUI/MessageUI.h>

//TODO: move defines to
#define kFileName @"WhatWeBelieve"
#define kFileType @"html"
#define kJesusURL @"http://www.matthiasmedia.com.au/2wtl/2wtlonline.html"
#define SGCC_PHONE @"tel://16262870486"
#define SGCC_EMAIL @"zombieonrails@gmail.com"
@interface WelcomeViewController () <UIActionSheetDelegate, MFMailComposeViewControllerDelegate>
- (IBAction)contactButtonClicked:(id)sender;
@end

@implementation WelcomeViewController
#pragma mark - Storyboard-related methods
-(void) home:(UIStoryboardSegue *)segue
{
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WebsiteViewController *controller = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"whoIsJesusSegue"]) {
        controller.websiteURL = [NSURL URLWithString:kJesusURL];
    } else if ([segue.identifier isEqualToString:@"whatWeBelieveSegue"]) {
        NSString *path = [NSBundle.mainBundle pathForResource:kFileName
                                                       ofType:kFileType];
        controller.websiteURL = [NSURL fileURLWithPath:path];
    }
}
- (IBAction)contactButtonClicked:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Contact Us"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:  @"Call Us",
                                                                        @"Email Us",
                                                                        @"Directions",
                                                                        @"Visit Website",
                                                                        nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}
#pragma mark - UIActionSheetDelegate Methods
-(void) showEmail
{
    MFMailComposeViewController *mailComposeVC = MFMailComposeViewController.new;
    mailComposeVC.mailComposeDelegate = self;
    [mailComposeVC setSubject:@"Contact from SGCC App"];
    [mailComposeVC setMessageBody:@"" isHTML:NO];
    [mailComposeVC setToRecipients:@[SGCC_EMAIL]];
    [self presentViewController:mailComposeVC animated:YES completion:NULL];
    
}
-(void)     actionSheet:(UIActionSheet *)actionSheet
   clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //Call
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SGCC_PHONE]];
            break;
        case 1:
            //Email
            [self showEmail];
            break;
        case 2:
            //Directions
            break;
        case 3:
            //Website
            break;
    }
}
#pragma mark - MailComposeDelegate Methods
- (void) mailComposeController:(MFMailComposeViewController *)controller
           didFinishWithResult:(MFMailComposeResult)result
                         error:(NSError *)error
{
    NSString *message = @"";
    NSString *messageTitle = @"";
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
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
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:^(void)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:messageTitle message:message delegate:self cancelButtonTitle:@"Done" otherButtonTitles:NULL, nil];
        [alert show];
    }];
}
@end
