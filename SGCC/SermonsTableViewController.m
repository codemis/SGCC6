#import "SermonsTableViewController.h"
#import "SermonsDataSource.h"
#import "Sermon.h"

@interface SermonsTableViewController ()
@end

@implementation SermonsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [(SermonsDataSource *)self.tableView.dataSource fetchSermons];
}

@end
