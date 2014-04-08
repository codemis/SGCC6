#import "SermonsStore.h"
#import "AppDelegate.h"
#import <AFNetworking.h>

#define SERMONS_URL @"http://1ac275bb.ngrok.com/podcast.php"
@interface SermonsStore ()

@property(nonatomic,weak)NSManagedObjectContext *managedObjectContext;
@property(nonatomic)NSDateFormatter *sqlDateFormatter;
@property(nonatomic)NSFetchRequest *request;
@property(nonatomic)AppDelegate *appDelegate;

@end

@implementation SermonsStore

+(SermonsStore *)sharedStore { //FIXME: instancetype?
    static SermonsStore *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = SermonsStore.new; //FIXME: self.new?
    });
    return __instance;
}
-(id)init {
    if (!super.init) return nil;
    self.appDelegate = UIApplication.sharedApplication.delegate;
    self.managedObjectContext = self.appDelegate.managedObjectContext;
    self.request = NSFetchRequest.new;
    self.request.entity =
    [NSEntityDescription entityForName:@"Sermon"
                inManagedObjectContext:self.managedObjectContext];
    self.sqlDateFormatter = NSDateFormatter.new;
    //Sun, 16 Feb 2014 12:00:00 -0800
    //2014-02-04 23:04:33
    self.sqlDateFormatter.dateFormat = @"EEE, d MMM yyyy HH:mm:ss Z";
    [self updateSermonsFromWeb]; //TODO: Only if network is reachable
    return self;
}
-(void)updateSermonsFromWeb {
    AFHTTPRequestOperationManager *manager = AFHTTPRequestOperationManager.manager;
    manager.responseSerializer = AFJSONResponseSerializer.serializer;
    [manager GET:SERMONS_URL
      parameters:nil
         success:^(AFHTTPRequestOperation *operation,id responseObject) {
             int newSermonCount = 0;
             for (NSDictionary *rawSermon in responseObject)
                 if (![self sermonExists:rawSermon[@"id"]]) {
                     [self addSermon:rawSermon];
                     newSermonCount++;
                 }
             if (newSermonCount > 0) {
                 [NSFetchedResultsController deleteCacheWithName:@"Sermons"];
                 [NSNotificationCenter.defaultCenter
                  postNotificationName:@"shouldUpdateBadgeValue"
                  object:nil
                  userInfo:@{@"itemTitle":@"Sermons",
                             @"badgeValue":[NSString stringWithFormat:@"%i",
                                            newSermonCount]}];
             }
         }
         failure:^(AFHTTPRequestOperation *operation,NSError *error) {
             NSLog(@"Get %@ failed: %@",SERMONS_URL,error.localizedDescription);
             NSLog(@"Failure :-(");
         }
     ];
}
-(BOOL)sermonExists:(NSString *)id {
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
-(void)addSermon:(NSDictionary *)rawSermon {
    Sermon *sermon =[NSEntityDescription
                     insertNewObjectForEntityForName:@"Sermon"inManagedObjectContext:self.managedObjectContext];
    sermon.supplierID = @([rawSermon[@"id"] integerValue]);
    sermon.title = rawSermon[@"title"];
    sermon.author = rawSermon[@"author"];
    sermon.summary = rawSermon[@"summary"];
    sermon.publishedOn = [self.sqlDateFormatter dateFromString:rawSermon[@"publishedOn"]];
    sermon.remoteUrlString = rawSermon[@"url"];
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save Sermon: %@",error.localizedDescription);
    }

    
}
@end
