#import "SermonsTableViewController.h"
#import "SermonsDataSource.h"
#import "Sermon.h"
#import "AudioPlayerViewController.h"
#import "DownloadCell.h"

@interface SermonsTableViewController () <UITableViewDelegate>
@property(nonatomic)NSIndexPath *downloadIndexPath;
@property(nonatomic)DownloadCell *downloadCell;
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
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    [manager setDidFinishEventsForBackgroundURLSessionBlock:^(NSURLSession *session) {
        //TODO: invoke app delegate's background download completion handler
    }];
    Sermon *sermon = [(SermonsDataSource *)self.tableView.dataSource sermonForIndexPath:indexPath];
    NSURL *URL = [NSURL URLWithString:sermon.remoteUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    NSProgress *progress;
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
                                                                     progress:nil
                                                                  destination:
        ^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                              inDomain:NSUserDomainMask
                                                                     appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
//    [progress addObserver:self
//               forKeyPath:@"fractionCompleted"
//                  options:NSKeyValueObservingOptionNew context:NULL];
    self.downloadCell = (DownloadCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [self.downloadCell.progressView setProgressWithDownloadProgressOfTask:downloadTask
                                                                 animated:YES];
    [downloadTask resume];
}
#pragma mark - Observers
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"fractionCompleted"] &&
        [object isKindOfClass:[NSProgress class]]) {
        NSProgress *progress = (NSProgress *)object;
        NSLog(@"Progress is %f",progress.fractionCompleted);
        [self.downloadCell updateProgressView:progress.fractionCompleted];
    }
}
#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AudioPlayerViewController *destinationVC = segue.destinationViewController;
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    destinationVC.sermon =
      [(SermonsDataSource *)self.tableView.dataSource sermonForIndexPath:indexPath];
}
@end