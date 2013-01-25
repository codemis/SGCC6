//
//  WelcomeViewController.m
//  SGCC
//
//  Created by Johnathan Pulos on 1/3/13.
//  Copyright (c) 2013 Johnathan Pulos. All rights reserved.
//

#import "WelcomeController.h"
#import "WebsiteViewController.h"

@interface WelcomeController ()
@end

@implementation WelcomeController

-(void) home:(UIStoryboardSegue *)segue
{
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"whoIsJesusSegue"]) {
        WebsiteViewController *controller = [segue destinationViewController];
        controller.websiteURL = [NSURL URLWithString:@"http://www.matthiasmedia.com.au/2wtl/2wtlonline.html"];
        controller.viewTitle = @"Who is Jesus?";
    }
}

@end
