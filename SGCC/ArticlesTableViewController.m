#import "ArticlesTableViewController.h"

@interface ArticlesTableViewController ()

@end

@implementation ArticlesTableViewController
-(void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
}
@end