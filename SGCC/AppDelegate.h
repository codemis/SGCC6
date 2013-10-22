@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(strong,nonatomic) UIWindow *window;
@property(nonatomic,retain,readonly)NSManagedObjectModel *managedObjectModel;
@property(nonatomic,retain,readonly)NSManagedObjectContext *managedObjectContext;
@property(nonatomic,retain,readonly)NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end