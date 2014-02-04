#import "ArticleDetailsViewController.h"

@interface ArticleDetailsViewController ()

@property(weak,nonatomic)IBOutlet UILabel *author;
@property(weak,nonatomic)IBOutlet UILabel *date;
@property(weak,nonatomic)IBOutlet UIWebView *content;
@property(nonatomic)IBOutlet NSDateFormatter *mmmmdyyyyFormatter;

@end

@implementation ArticleDetailsViewController
- (IBAction)shareButtonClicked:(id)sender {
    UIActivityViewController *activityVC =
    [[UIActivityViewController alloc]
     initWithActivityItems:@[[NSURL URLWithString:self.article.urlString]]
     applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.article.title;
    self.author.text = self.article.author;
    self.date.text =
      [self.mmmmdyyyyFormatter stringFromDate:self.article.publishedOn];
    [self.content loadHTMLString:self.article.content baseURL:nil];
}
@end