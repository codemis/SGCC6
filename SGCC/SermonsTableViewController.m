#import "SermonsTableViewController.h"
#import "SermonsDataSource.h"
#import "Sermon.h"
#import "AudioPlayerViewController.h"
#import <AFNetworking.h>

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
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    Sermon *sermon = [(SermonsDataSource *)self.tableView.dataSource sermonForIndexPath:indexPath];
    NSURL *URL = [NSURL URLWithString:sermon.remoteUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    [downloadTask resume];
}
#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AudioPlayerViewController *destinationVC = segue.destinationViewController;
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    destinationVC.sermon =
      [(SermonsDataSource *)self.tableView.dataSource sermonForIndexPath:indexPath];
}
@end