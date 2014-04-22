#import "ArticlesStore.h"
#import "AppDelegate.h"
#import <AFNetworking.h>

#define ARTICLES_URL @"http://7c8873f6.ngrok.com/?feed=json"

@interface ArticlesStore ()

@property(nonatomic,weak)NSManagedObjectContext *managedObjectContext;
@property(nonatomic)NSDateFormatter *sqlDateFormatter;
@property(nonatomic)NSFetchRequest *request;
@property(nonatomic)AppDelegate *appDelegate;

@end

@implementation ArticlesStore

+(ArticlesStore *)sharedStore { //FIXME: instancetype?
    static ArticlesStore *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = ArticlesStore.new; //FIXME: self.new?
    });
    return __instance;
}
-(id)init {
    if (!super.init) return nil;
    self.appDelegate = UIApplication.sharedApplication.delegate;
    self.managedObjectContext = self.appDelegate.managedObjectContext;
    self.request = NSFetchRequest.new;
    self.request.entity =
      [NSEntityDescription entityForName:@"Article"
                  inManagedObjectContext:self.managedObjectContext];
    self.sqlDateFormatter = NSDateFormatter.new;
    self.sqlDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [self updateArticlesFromWeb]; //TODO: Only if network is reachable
    return self;
}
-(void)updateArticlesFromWeb {
    if (!self.appDelegate.networkReachable) {
        NSLog(@"In updateArticlesFromWeb: Network not reachable :-(");
//        return;
    }
    AFHTTPRequestOperationManager *manager =
      AFHTTPRequestOperationManager.manager;
    manager.responseSerializer = AFJSONResponseSerializer.serializer;
    [manager GET:ARTICLES_URL
      parameters:nil
         success:^(AFHTTPRequestOperation *operation,id responseObject) {
             int newArticleCount = 0;
             for (NSDictionary *rawArticle in responseObject)
                if (![self articleExists:rawArticle[@"id"]]) {
                    [self addArticle:rawArticle];
                    newArticleCount++;
                }
             if (newArticleCount > 0) {
                 [NSFetchedResultsController deleteCacheWithName:@"Articles"];
                 [NSNotificationCenter.defaultCenter
                   postNotificationName:@"shouldUpdateBadgeValue"
                   object:nil
                   userInfo:@{@"itemTitle":@"Articles",
                              @"badgeValue":[NSString stringWithFormat:@"%i",
                                            newArticleCount]}];
             }
         }
         failure:^(AFHTTPRequestOperation *operation,NSError *error) {
             NSLog(@"Get %@ failed: %@",ARTICLES_URL,error.localizedDescription);
             NSLog(@"Failure :-(");
         }];
}
-(BOOL)articleExists:(NSString *)id {
    self.request.predicate =
      [NSPredicate predicateWithFormat:@"supplierID == %@",id];
    NSError *error;
    NSUInteger count =
      [self.managedObjectContext countForFetchRequest:self.request
                                                error:&error];
    if (error) {
        NSLog(@"countForFetchRequest failed!");
        return NO;
    } else return count > 0 ? YES : NO;
}
-(void)addArticle:(NSDictionary *)rawArticle {
    Article *article = [NSEntityDescription
                        insertNewObjectForEntityForName:@"Article"
                        inManagedObjectContext:self.managedObjectContext];
    article.supplierID = @([rawArticle[@"id"] integerValue]);
    article.title = rawArticle[@"title"];
    article.author = rawArticle[@"author"];
    article.content = rawArticle[@"content"];
    article.summary = rawArticle[@"excerpt"];
    article.publishedOn =
      [self.sqlDateFormatter dateFromString:rawArticle[@"date"]];
    article.urlString = rawArticle[@"permalink"];
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save Article: %@",error.localizedDescription);
    }
}
@end