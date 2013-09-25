#import "ArticlesDataSource.h"
#import "ArticlesStore.h"

@interface ArticlesDataSource () <UITableViewDataSource>

@end

@implementation ArticlesDataSource
#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section {
    return [ArticlesStore sharedStore].count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"ArticleCell"
                                      forIndexPath:indexPath];
    Article *article = [ArticlesStore sharedStore][indexPath.row];
    cell.textLabel.text = article.title;
    NSDateFormatter *mmddyyyy = NSDateFormatter.new;
    mmddyyyy.dateFormat = @"MM/dd/yyyy";
    NSString *detailText = [NSString stringWithFormat:@"%@: %@",
                            [mmddyyyy stringFromDate:article.publishedOn],
                            article.summary];
    cell.detailTextLabel.text = detailText;
    return cell;
}

@end