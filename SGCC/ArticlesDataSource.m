#import "ArticlesDataSource.h"
#import "Article.h"

#define ARTICLES_URL @"http://www.sgucblog.com/feed"

@interface ArticlesDataSource () <UITableViewDataSource>

@property(strong,nonatomic)NSMutableArray *articles;

@end

@implementation ArticlesDataSource
-(id)init {
    if (![super init]) return nil;
    self.articles = [self getArticles];
    return self;
}
-(NSMutableArray *)getArticles {
    NSMutableArray *articles = [@[Article.new, Article.new] mutableCopy];
    return articles;
}
#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section {
    return self.articles.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"ArticleCell"
                                      forIndexPath:indexPath];
    Article *article =self.articles[indexPath.row];
    cell.textLabel.text = article.title;
    NSDateFormatter *mmddyyyy = NSDateFormatter.new;
    [mmddyyyy setDateStyle:NSDateFormatterShortStyle];
    NSString *detailText = [NSString stringWithFormat:@"%@: %@",
                            [mmddyyyy stringFromDate:article.publishedOn],
                            article.summary];
    cell.detailTextLabel.text = detailText;
    return cell;
}

@end