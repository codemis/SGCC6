#import "ArticlesDataSource.h"
#import "AppDelegate.h"

@interface ArticlesDataSource ()
  <UITableViewDataSource,NSFetchedResultsControllerDelegate>

@property(nonatomic)NSDateFormatter *mdyyyyFormatter;
@property(nonatomic,weak)NSManagedObjectContext *managedObjectContext;
@property(nonatomic)NSFetchedResultsController *fetchedResultsController;
@property(nonatomic,weak)IBOutlet UITableView *tableView;

@end

@implementation ArticlesDataSource
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
      [NSEntityDescription entityForName:@"Article"
                  inManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *sort =
      [[NSSortDescriptor alloc] initWithKey:@"publishedOn"
                                  ascending:NO];
    fetchRequest.sortDescriptors = @[sort];
    fetchRequest.fetchBatchSize = 20;
    _fetchedResultsController = [[NSFetchedResultsController alloc]
                                 initWithFetchRequest:fetchRequest
                                 managedObjectContext:self.managedObjectContext
                                 sectionNameKeyPath:nil cacheName:@"Articles"];
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}
-(void)fetchArticles {
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved fetching error: %@, %@",error,error.userInfo);
        exit(-1);
    }
}
-(Article *)articleForIndexPath:(NSIndexPath *)indexPath {
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
    Article *article = [self articleForIndexPath:indexPath];
    cell.textLabel.text = article.title;
    NSString *detailText =
    [NSString stringWithFormat:@"%@: %@",
     [self.mdyyyyFormatter stringFromDate:article.publishedOn],
     article.summary];
    cell.detailTextLabel.text = detailText;
}
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"ArticleCell"
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