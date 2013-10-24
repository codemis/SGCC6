#import "ArticlesDataSource.h"
#import "ArticlesStore.h"

@interface ArticlesDataSource () <UITableViewDataSource>

@property(nonatomic)NSDateFormatter *mdyyyyFormatter;

@end

@implementation ArticlesDataSource

-(instancetype)init {
    if (![super init]) return nil;
    self.mdyyyyFormatter = NSDateFormatter.new;
    self.mdyyyyFormatter.dateFormat = @"M/d/yyyy";
    return self;
}
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
    NSString *detailText =
      [NSString stringWithFormat:@"%@: %@",
       [self.mdyyyyFormatter stringFromDate:article.publishedOn],
       article.summary];
    cell.detailTextLabel.text = detailText;
    return cell;
}
@end