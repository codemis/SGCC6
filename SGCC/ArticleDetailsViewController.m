#import "ArticleDetailsViewController.h"

@interface ArticleDetailsViewController ()

@property(weak,nonatomic)IBOutlet UILabel *author;
@property(weak,nonatomic)IBOutlet UILabel *date;
@property(weak,nonatomic)IBOutlet UIWebView *content;
@property(nonatomic)IBOutlet NSDateFormatter *mmmmdyyyyFormatter;

@end

@implementation ArticleDetailsViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.article.title;
    self.author.text = self.article.author;
    self.date.text =
      [self.mmmmdyyyyFormatter stringFromDate:self.article.publishedOn];
    [self.content loadHTMLString:self.article.content baseURL:nil];
}
@end