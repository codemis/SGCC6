#import "SermonsTableViewController.h"
#import "SermonsDataSource.h"
#import "Sermon.h"
#import "AudioPlayerViewController.h"

@interface SermonsTableViewController () <UITableViewDelegate>
@end

@implementation SermonsTableViewController

#pragma mark - View lifecycle
-(void)viewDidLoad {
    [super viewDidLoad];
    [(SermonsDataSource *)self.tableView.dataSource fetchSermons];
}
#pragma mark - UITableViewDelegate
-(void)                        tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AudioPlayerViewController *destinationVC = segue.destinationViewController;
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    destinationVC.sermon =
      [(SermonsDataSource *)self.tableView.dataSource sermonForIndexPath:indexPath];
}
@end