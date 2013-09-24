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
    self.articles = NSMutableArray.new;
    [self getArticles];
    return self;
}
-(void)getArticles {
    AFHTTPRequestOperationManager *manager =
      [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDateFormatter *dateFormatter = NSDateFormatter.new;
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [manager GET:ARTICLES_URL
      parameters:nil
         success:^(AFHTTPRequestOperation *operation,id responseObject) {
            for (NSDictionary *rawArticle in responseObject) {
                NSLog(@"Date = %@",rawArticle[@"date"]);
             Article *article =
               [[Article alloc] initWithTitle:rawArticle[@"title"]
          author:rawArticle[@"author"]
         content:rawArticle[@"content"]
         summary:rawArticle[@"excerpt"]
     publishedOn:[dateFormatter dateFromString:rawArticle[@"date"]]
    urlString:rawArticle[@"permalink"]];
                [self.articles addObject:article];
            }
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
    mmddyyyy.dateFormat = @"MM/dd/yyyy";
    NSString *detailText = [NSString stringWithFormat:@"%@: %@",
                            [mmddyyyy stringFromDate:article.publishedOn],
                            article.summary];
    cell.detailTextLabel.text = detailText;
    return cell;
}

@end