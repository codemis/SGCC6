#import "TabBarControllerDelegate.h"
#import "WebsiteViewController.h"

@interface TabBarControllerDelegate () <UITabBarControllerDelegate>

@end

@implementation TabBarControllerDelegate
-(BOOL)tabBarController:(UITabBarController *)tabBarController
shouldSelectViewController:(UIViewController *)viewController {
    NSLog(@"I'm in the delegate");
    if ([tabBarController.tabBar.selectedItem.title isEqualToString:@"Events"]) {
        UINavigationController *navC = (UINavigationController *)viewController;
        WebsiteViewController *websiteVC = (WebsiteViewController *)navC.viewControllers[0];
        websiteVC.websiteURL = [NSURL URLWithString: @"http://www.sgucandcs.org/calendar.php?pageID=39"];
        websiteVC.title = tabBarController.tabBar.selectedItem.title;
    }
    return YES;
}
@end
