#import "DownloadCell.h"

@implementation DownloadCell
-(IBAction)downloadButtonTapped {
    [self.tableView.delegate tableView:self.tableView
accessoryButtonTappedForRowWithIndexPath:[self.tableView indexPathForCell:self]];
}
@end