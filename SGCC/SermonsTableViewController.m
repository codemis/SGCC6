#import "SermonsTableViewController.h"
#import "SermonsDataSource.h"
#import "Sermon.h"
#import "AudioPlayerViewController.h"

@interface SermonsTableViewController ()
@end

@implementation SermonsTableViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [(SermonsDataSource *)self.tableView.dataSource fetchSermons];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AudioPlayerViewController *destinationVC = segue.destinationViewController;
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    destinationVC.sermon =
      [(SermonsDataSource *)self.tableView.dataSource sermonForIndexPath:indexPath];
}
@end