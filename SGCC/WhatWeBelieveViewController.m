#define kFileName @"WhatWeBelieve"
#define kFileType @"html"

#import "WhatWeBelieveViewController.h"

@interface WhatWeBelieveViewController ()
@property(weak,nonatomic)IBOutlet UIWebView *webView;
@end

@implementation WhatWeBelieveViewController
-(void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [NSBundle.mainBundle pathForResource:kFileName
                                                   ofType:kFileType];
    if (path) {
        NSURL *htmlURL = [NSURL fileURLWithPath:path];
        [self.webView loadRequest:[NSURLRequest requestWithURL:htmlURL]];
    } else {
        NSString *errorMessage =
          [NSString stringWithFormat:@"Failed opening %@.%@",
                                     kFileName,
                                     kFileType];
        [self.webView loadHTMLString:errorMessage
                             baseURL:[NSURL URLWithString:@"/"]];
    }
}
@end
