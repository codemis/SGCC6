#import "ArticlesTableViewController.h"
#import "ArticleDetailsViewController.h"
#import "ArticlesStore.h"
#import "Article.h"

@implementation ArticlesTableViewController
-(void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"articleDetailsSegue"]) {
        ArticleDetailsViewController *destinationVC =
          segue.destinationViewController;
        int row = self.tableView.indexPathForSelectedRow.row;
        destinationVC.article = [ArticlesStore sharedStore][row];
    }
}
@end