#import "ArticlesDataSource.h"
#import "Article.h"
#import <AFNetworking.h>

#define ARTICLES_URL @"http://sgucblog.com/feed/json"

@interface ArticlesDataSource () <UITableViewDataSource>

@property(strong,nonatomic)NSMutableArray *articles;

@end

@implementation ArticlesDataSource
-(id)init {
    if (![super init]) return nil;
    [self getArticles];
    return self;
}
-(void)getArticles {
    AFHTTPRequestOperationManager *manager =
      [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:ARTICLES_URL
      parameters:nil
         success:^(AFHTTPRequestOperation *operation,id responseObject) {
             NSLog(@"%@",responseObject);
             NSArray *rawArticles = responseObject;
             NSDictionary *rawArticle = rawArticles[0];
             Article *article =
               [[Article alloc] initWithTitle:rawArticle[@"title"]
          author:rawArticle[@"author"]
         content:rawArticle[@"content"]
         summary:rawArticle[@"excerpt"]
     publishedOn:nil
    urlString:rawArticle[@"permalink"]];
             NSLog(@"first article = %@",article);
             NSLog(@"Success!");
         }
         failure:^(AFHTTPRequestOperation *operation,NSError *error) {
             NSLog(@"Error: %@",error.localizedDescription);
             NSLog(@"Failure :-(");
         }];
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