//
//  EventsViewController.m
//  SGCC
//
//  Created by Johnathan Pulos on 1/26/13.
//  Copyright (c) 2013 Johnathan Pulos. All rights reserved.
//
#import "EventsViewController.h"
@interface EventsViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation EventsViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *websiteURL = [NSURL URLWithString:@"http://www.sgucandcs.org/calendar.php?pageID=39"];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:websiteURL];
    [self.webView loadRequest:request];
    self.webView.scalesPageToFit = YES;
}
@end
