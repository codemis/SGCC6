#import "ArticlesStore.h"
#import "AppDelegate.h"
#import <AFNetworking.h>

#define ARTICLES_URL @"http://sgucblog.com/feed/json"

@interface ArticlesStore ()

@property(nonatomic,weak)NSManagedObjectContext *managedObjectContext;
@property(nonatomic)NSArray *articles;

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
-(void)getArticles {
    NSFetchRequest *request = NSFetchRequest.new;
    request.entity =
      [NSEntityDescription entityForName:@"Article"
                  inManagedObjectContext:self.managedObjectContext];
    NSError *error;
    self.articles = [self.managedObjectContext executeFetchRequest:request
                                                             error:&error];
    if (error) {
        NSLog(@"Unable to fetch Articles: %@",error.localizedDescription);
    }
}

-(id)init {
    if (![super init]) return nil;
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    [self updateArticlesFromWeb]; //TODO: Only if network is reachable
    return self;
}
-(NSUInteger)count {
    return self.articles.count;
}
-(id)objectAtIndexedSubscript:(NSUInteger)index {
    return self.articles[index];
}
-(void)updateArticlesFromWeb {
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:ARTICLES_URL
      parameters:nil
         success:^(AFHTTPRequestOperation *operation,id responseObject) {
             int newArticleCount = 0;
             for (NSDictionary *rawArticle in responseObject)
                if (![self articleExists:rawArticle[@"id"]]) {
                    [self addArticle:rawArticle];
                    newArticleCount++;
                }
             if (newArticleCount > 0)
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"shouldUpdateBadgeValue"
                 object:nil
                 userInfo:@{@"itemTitle":@"Articles",
                            @"badgeValue":[NSString stringWithFormat:@"%i",
                                           newArticleCount]}];
             [self getArticles];
         }
         failure:^(AFHTTPRequestOperation *operation,NSError *error) {
             NSLog(@"Error: %@",error.localizedDescription);
             NSLog(@"Failure :-(");
         }];
}
-(BOOL)articleExists:(NSString *)id {
    NSFetchRequest *request = NSFetchRequest.new;
    request.entity =
      [NSEntityDescription entityForName:@"Article"
                  inManagedObjectContext:self.managedObjectContext];
    request.predicate =
      [NSPredicate predicateWithFormat:@"supplierId == %@",id];
    NSError *error;
    NSUInteger count =
      [self.managedObjectContext countForFetchRequest:request error:&error];
    if (error) {
        NSLog(@"countForFetchRequest failed!");
        return NO;
    } else return count > 0 ? YES : NO;
}
-(void)addArticle:(NSDictionary *)rawArticle {
    NSDateFormatter *dateFormatter = NSDateFormatter.new;
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    Article *article = [NSEntityDescription
                        insertNewObjectForEntityForName:@"Article"
                        inManagedObjectContext:self.managedObjectContext];
    article.supplierId =
      [NSNumber numberWithInteger:[rawArticle[@"id"] integerValue]];
    article.title = rawArticle[@"title"];
    article.author = rawArticle[@"author"];
    article.content = rawArticle[@"content"];
    article.summary = rawArticle[@"excerpt"];
    article.publishedOn = [dateFormatter dateFromString:rawArticle[@"date"]];
    article.urlString = rawArticle[@"permalink"];
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@",error.localizedDescription);
    }
}
@end