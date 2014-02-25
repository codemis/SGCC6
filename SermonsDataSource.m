#import "SermonsDataSource.h"

@interface SermonsDataSource ()
    <UITableViewDataSource, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SermonsDataSource

#pragma mark - Object lifecycle
-(instancetype)init {
    return self;
}
-(void)fetchSermons {
    
}

-(Sermon *)sermonAtIndexPath:(NSIndexPath *)
    indexPath {
    return Sermon.new;
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section {
    return 0;
}
-(void)configureCell:(UITableViewCell *)cell
         atIndexPath:(NSIndexPath *)indexPath {
}
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"SermonCell"
                                    forIndexPath:indexPath];
    return cell;
}



@end
