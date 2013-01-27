//
//  WelcomeViewController.m
//  SGCC
//
//  Created by Johnathan Pulos on 1/3/13.
//  Copyright (c) 2013 Johnathan Pulos. All rights reserved.
//

#import "WelcomeController.h"
#import "WebsiteViewController.h"
#define SGUC_PHONE @"tel://16262870486"
@interface WelcomeController () <UIActionSheetDelegate>
- (IBAction)contactButtonClicked:(id)sender;
@end

@implementation WelcomeController

-(void) home:(UIStoryboardSegue *)segue
{
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"whoIsJesusSegue"]) {
        WebsiteViewController *controller = [segue destinationViewController];
        controller.websiteURL = [NSURL URLWithString:@"http://www.matthiasmedia.com.au/2wtl/2wtlonline.html"];
        controller.viewTitle = @"Who is Jesus?";
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
#pragma mark - UIActionSheetDelegate Functions
-(void)     actionSheet:(UIActionSheet *)actionSheet
   clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //Call
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SGUC_PHONE]];
            break;
        case 1:
            //Email
            break;
        case 2:
            //Directions
            break;
        case 3:
            //Website
            break;
    }
}
@end
