#import "ArticlesDataSource.h"

@implementation ArticlesDataSource

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleCell"
                                                            forIndexPath:indexPath];
    cell.textLabel.text = @"I Am a Zombie!";
    cell.detailTextLabel.text = @"8/27/2013: I want to eat your BRAINS!!";
    return cell;
}

@end