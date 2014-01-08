#import <Parse/Parse.h>
#import "TestFlight.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(nonatomic)UIWindow *window;
@property(nonatomic,readonly)NSManagedObjectContext *managedObjectContext;
@property(nonatomic,readonly)BOOL networkReachable;

@end