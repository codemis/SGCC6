#import "ArticlesDataSource.h"
#import "Article.h"
#import <AFNetworking.h>
#import <AFKissXMLRequestOperation.h>

#define ARTICLES_URL @"http://www.sgucblog.com/feed"

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
    [AFKissXMLRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"application/rss+xml"]];
    AFKissXMLRequestOperation *operation =
      [AFKissXMLRequestOperation XMLDocumentRequestOperationWithRequest:
         [NSURLRequest requestWithURL:[NSURL URLWithString:ARTICLES_URL]]
                                                                success:
       ^(NSURLRequest *request,NSHTTPURLResponse *response,
         DDXMLDocument *XMLDocument) {
           NSLog(@"XMLDocument: %@",XMLDocument);
           NSLog(@"Got document");
    }
                                                                failure:
       ^(NSURLRequest *request,NSHTTPURLResponse *response,
         NSError *error, DDXMLDocument *XMLDocument) {
           NSLog(@"Failure:%@",error.localizedDescription);
    }];
    [operation start];
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