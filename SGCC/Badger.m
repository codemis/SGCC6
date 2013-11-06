#import "Badger.h"

@interface Badger ()

@property(nonatomic,weak)IBOutlet UITabBar *tabBar;

@end

@implementation Badger

-(instancetype)init {
    if (![super init]) return nil;
    [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(updateBadgeValue:)
         name:@"shouldUpdateBadgeValue"
         object:nil];
    return self;
}
-(void)updateBadgeValue:(NSNotification *)notification {
    NSString *itemTitle = notification.userInfo[@"itemTitle"];
    NSString *badgeValue = notification.userInfo[@"badgeValue"];
    if ([badgeValue isEqualToString:@""]) badgeValue = nil;
    for (UITabBarItem *tabBarItem in self.tabBar.items)
        if ([tabBarItem.title isEqualToString:itemTitle])
            tabBarItem.badgeValue = badgeValue;
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end