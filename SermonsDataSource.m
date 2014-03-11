#import "SermonsDataSource.h"
#import "AppDelegate.h"

@interface SermonsDataSource ()
    <UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property(nonatomic)NSDateFormatter *mdyyyyFormatter;
@property(nonatomic,weak)NSManagedObjectContext *managedObjectContext;
@property(nonatomic)NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SermonsDataSource

#pragma mark - Object lifecycle
-(instancetype)init {
    if (!super.init) return nil;
    self.mdyyyyFormatter = NSDateFormatter.new;
    self.mdyyyyFormatter.dateFormat = @"M/d/yyyy";
    AppDelegate *appDelegate = UIApplication.sharedApplication.delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    return self;
}
#pragma mark - Getters
-(NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) return _fetchedResultsController;
    NSFetchRequest *fetchRequest = NSFetchRequest.new;
    fetchRequest.entity =
    [NSEntityDescription entityForName:@"Sermon"
                inManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *sort =
    [[NSSortDescriptor alloc] initWithKey:@"publishedOn"
                                ascending:NO];
    fetchRequest.sortDescriptors = @[sort];
    fetchRequest.fetchBatchSize = 20;
    _fetchedResultsController = [[NSFetchedResultsController alloc]
                                 initWithFetchRequest:fetchRequest
                                 managedObjectContext:self.managedObjectContext
                                 sectionNameKeyPath:nil cacheName:@"Sermons"];
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}
-(void)fetchSermons {
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved fetching error: %@, %@",error,error.userInfo);
        exit(-1);
    }
}

-(Sermon *)sermonForIndexPath:(NSIndexPath *)
    indexPath {
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo =
    self.fetchedResultsController.sections[section];
    return sectionInfo.numberOfObjects;
}
-(void)configureCell:(UITableViewCell *)cell
         atIndexPath:(NSIndexPath *)indexPath {
    Sermon *sermon = [self sermonForIndexPath:indexPath];
    cell.textLabel.text = sermon.title;
    NSString *detailText;
    if (sermon.summary.length > 0) {
        detailText =
        [NSString stringWithFormat:@"%@: %@",
         [self.mdyyyyFormatter stringFromDate:sermon.publishedOn],
         sermon.summary];
    } else {
        detailText = [self.mdyyyyFormatter stringFromDate:sermon.publishedOn];
    }
    cell.detailTextLabel.text = detailText;
}
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"SermonCell"
                                    forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}
#pragma mark - NSFetchedResultsController delegate protocol
-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}
-(void)controller:(NSFetchedResultsController *)controller
  didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath
    forChangeType:(NSFetchedResultsChangeType)type
     newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}
-(void)controller:(NSFetchedResultsController *)controller
 didChangeSection:(id)sectionInfo atIndex:(NSUInteger)sectionIndex
    forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:
             [NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:
             [NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}
@end
