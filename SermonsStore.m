#import "SermonsStore.h"
#import "AppDelegate.h"

#define SERMONS_URL @"http://sgucandcs.org/podcast.php?pageID=38"
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
    self.sqlDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [self updateSermonsFromWeb]; //TODO: Only if network is reachable
    return self;
}
-(void)updateSermonsFromWeb {
    
}
-(BOOL)sermonExists:(NSString *)id {
    self.request.predicate =
    [NSPredicate predicateWithFormat:@"supplierId == %@",id];
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
    sermon.summary = rawSermon[@"excerpt"];
    sermon.publishedOn =
    [self.sqlDateFormatter dateFromString:rawSermon[@"date"]];
    sermon.remoteUrlString = rawSermon[@"permalink"];
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save Sermon: %@",error.localizedDescription);
    }

    
}
@end
