#import "DownloadCell.h"

@implementation DownloadCell
-(IBAction)downloadButtonTapped {
    [self.tableView.delegate tableView:self.tableView
accessoryButtonTappedForRowWithIndexPath:[self.tableView indexPathForCell:self]];
}
-(void)updateProgressView:(float)percentCompleted {
    [self.progressView setProgress:percentCompleted animated:YES];
}
@end