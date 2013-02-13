#define FileName @"WhatWeBelieve"

#import "WhatWeBelieveViewController.h"

@interface WhatWeBelieveViewController ()
@property(weak,nonatomic)IBOutlet UIWebView *webView;
@end

@implementation WhatWeBelieveViewController
-(void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [NSBundle.mainBundle pathForResource:FileName
                                                   ofType:@"html"];
    NSURL *htmlURL = [NSURL fileURLWithPath:path];
    [self.webView loadRequest:[NSURLRequest requestWithURL:htmlURL]];
}
@end
