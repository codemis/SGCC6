#import "WebsiteViewController.h"

@interface WebsiteViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation WebsiteViewController
-(void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.websiteURL];
    [self.webView loadRequest:request];
    self.webView.scalesPageToFit = YES;
    self.navigationController.navigationBarHidden = NO;
}
@end