//
//  WebsiteViewController.m
//  SGCC
//
//  Created by Johnathan Pulos on 1/24/13.
//  Copyright (c) 2013 Johnathan Pulos. All rights reserved.
//

#import "WebsiteViewController.h"

@interface WebsiteViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation WebsiteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.websiteURL];
    [self.webView loadRequest:request];
    self.webView.scalesPageToFit = YES;
}

@end
