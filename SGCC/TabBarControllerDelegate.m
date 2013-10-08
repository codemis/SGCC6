#import "TabBarControllerDelegate.h"
#import "WebsiteViewController.h"
#define EVENTS_URL @"http://www.sgucandcs.org/calendar.php?pageID=39"

@interface TabBarControllerDelegate () <UITabBarControllerDelegate>

@end

@implementation TabBarControllerDelegate
-(BOOL)   tabBarController:(UITabBarController *)tabBarController
shouldSelectViewController:(UIViewController *)viewController {
    if ([tabBarController.tabBar.selectedItem.title isEqualToString:@"Events"]) {
        UINavigationController *navC = (UINavigationController *)viewController;
        WebsiteViewController *websiteVC =
          (WebsiteViewController *)navC.viewControllers[0];
        websiteVC.websiteURL = [NSURL URLWithString: EVENTS_URL];
        websiteVC.title = tabBarController.tabBar.selectedItem.title;
    }
    return YES;
}
@end