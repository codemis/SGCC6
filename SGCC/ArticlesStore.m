#import "ArticlesStore.h"
#import <AFNetworking.h>

#define ARTICLES_URL @"http://sgucblog.com/feed/json"

@interface ArticlesStore ()

@property(strong,nonatomic)NSMutableArray *articles;

@end

@implementation ArticlesStore
+(ArticlesStore *)sharedStore {
    static ArticlesStore *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = ArticlesStore.new;
    });
    return __instance;
}
-(id)init {
    if (![super init]) return nil;
    self.articles = NSMutableArray.new;
    return self;
}
-(NSUInteger)count {
    return self.articles.count;
}
-(id)objectAtIndexedSubscript:(NSUInteger)index {
    return self.articles[index];
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

@end