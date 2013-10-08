#import "TabBarControllerDelegate.h"
#import "WebsiteViewController.h"
#define EVENTS_URL @"http://www.sgucandcs.org/calendar.php?pageID=39"

@interface TabBarControllerDelegate () <UITabBarControllerDelegate>

@end

@implementation TabBarControllerDelegate
-(BOOL)   tabBarController:(UITabBarController *)tabBarController
shouldSelectViewController:(UIViewController *)viewController {
    UITabBarItem *tabBarItem = tabBarController.tabBar.selectedItem;
    if ([tabBarItem.title isEqualToString:@"Events"]) {
        UINavigationController *navC = (UINavigationController *)viewController;
        WebsiteViewController *websiteVC =
          (WebsiteViewController *)navC.viewControllers[0];
        websiteVC.websiteURL = [NSURL URLWithString: EVENTS_URL];
        websiteVC.title = tabBarController.tabBar.selectedItem.title;
    }
    if (tabBarItem.badgeValue) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"shouldUpdateBadgeValue"
         object:nil
         userInfo:@{@"itemTitle":tabBarItem.title,
                    @"badgeValue":@""}];
    }
    return YES;
}
@end