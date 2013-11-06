#import "ArticlesTableViewController.h"
#import "ArticleDetailsViewController.h"
#import "ArticlesDataSource.h"
#import "Article.h"

@implementation ArticlesTableViewController
-(void)viewDidLoad {
    [super viewDidLoad];
    [(ArticlesDataSource *)self.tableView.dataSource fetchArticles];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"articleDetailsSegue"]) {
        ArticleDetailsViewController *destinationVC =
          segue.destinationViewController;
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        destinationVC.article =
          [(ArticlesDataSource *)self.tableView.dataSource articleForIndexPath:indexPath];
    }
}
@end