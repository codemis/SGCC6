#import "ArticleDetailsViewController.h"

@interface ArticleDetailsViewController ()

@property(weak,nonatomic)IBOutlet UILabel *author;
@property(weak,nonatomic)IBOutlet UILabel *date;
@property(weak,nonatomic)IBOutlet UITextView *content;
@property(strong,nonatomic)IBOutlet NSDateFormatter *dateToStringFormatter;

@end

@implementation ArticleDetailsViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.article.title;
    self.author.text = self.article.author;
    self.date.text =
      [self.dateToStringFormatter stringFromDate:self.article.publishedOn];

    self.content.text = self.article.content;
}

@end