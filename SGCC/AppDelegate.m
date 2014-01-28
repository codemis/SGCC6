#import "AppDelegate.h"
#import "ArticlesStore.h"
#import <AFNetworkReachabilityManager.h>

@interface AppDelegate()

@property(nonatomic,readonly)NSManagedObjectModel *managedObjectModel;
@property(nonatomic,readonly)
  NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic,readwrite)BOOL networkReachable;

@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Core Data
-(NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext) return _managedObjectContext;
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (coordinator) {
        _managedObjectContext = NSManagedObjectContext.new;
        _managedObjectContext.persistentStoreCoordinator = coordinator;
    }
    return _managedObjectContext;
}
-(NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel) return _managedObjectModel;
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator) return _persistentStoreCoordinator;
    NSURL *storeUrl =
      [NSURL fileURLWithPath: [self.applicationDocumentsDirectory
                               stringByAppendingPathComponent: @"SGCC.sqlite"]];
    NSError *error = nil;
    _persistentStoreCoordinator =
      [NSPersistentStoreCoordinator.alloc
        initWithManagedObjectModel:self.managedObjectModel];
    if(![_persistentStoreCoordinator
          addPersistentStoreWithType:NSSQLiteStoreType configuration:nil
                                 URL:storeUrl options:nil error:&error]) {
        NSLog(@"PSC error: %@",error.localizedDescription);
    }
    return _persistentStoreCoordinator;
}
-(NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                NSUserDomainMask,
                                                YES) lastObject];
}
#pragma mark - ApplicationDelegate protocol
-(BOOL)           application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    AFNetworkReachabilityManager *manager =
      AFNetworkReachabilityManager.sharedManager;
    [manager startMonitoring];
    self.networkReachable = manager.reachable;
    [NSNotificationCenter.defaultCenter
      addObserver:self
      selector:@selector(updateNetworkReachability:)
      name:AFNetworkingReachabilityDidChangeNotification
      object:nil];
    [ArticlesStore sharedStore];
    [Parse setApplicationId:@"JPjs1lOtFvyV0mqvbQ4l6dhJMzl63ZkoUv3BY7ax"
                  clientKey:@"9GOYWAsKIqMkn58NXbGU3lJ5TPCFyMv95LbrmGjq"];
    [application registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |
      UIRemoteNotificationTypeSound)];
    [TestFlight takeOff:@"c7092e73-4699-4963-a07c-c25bb7e20153"];
    TFLog(@"application:didFinishLaunchingWithOptions:");
    return YES;
}
-(void)updateNetworkReachability:(NSNotification *)notification {
    NSNumber *status = (NSNumber *)notification.userInfo
      [AFNetworkingReachabilityNotificationStatusItem];
    NSLog(@"AFNetworkReachabilityStatus %@",status);
    self.networkReachable = status > 0 ? YES : NO;
}-(void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state.
    // This can occur for certain types of temporary interruptions (such as an
    // incoming phone call or SMS message) or when the user quits the
    // application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down
    // OpenGL ES frame rates. Games should use this method to pause the game.
}
-(void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.
}
-(void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive
    // state; here you can undo many of the changes made on entering the
    // background.
}
-(void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the
    // application was inactive. If the application was previously in the
    // background, optionally refresh the user interface.
}
-(void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate.
    // Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)          application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
      fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    self.silentRemoteNotificationCompletionHandler = completionHandler;
    [ArticlesStore.sharedStore updateArticlesFromWeb];
}
-(void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}
#pragma mark - Parse delegate
-(void)                              application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    PFInstallation *currentInstallation = PFInstallation.currentInstallation;
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}
-(void)          application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    TFLog(@"application:didReceiveRemoteNotification:");
    [PFPush handlePush:userInfo];
}
@end