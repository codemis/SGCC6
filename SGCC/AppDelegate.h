@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(strong,nonatomic)UIWindow *window;
@property(nonatomic,readonly)NSManagedObjectContext *managedObjectContext;

@end