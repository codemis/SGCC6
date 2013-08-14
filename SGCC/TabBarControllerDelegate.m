#import "TabBarControllerDelegate.h"
#import "WebsiteViewController.h"

@interface TabBarControllerDelegate () <UITabBarControllerDelegate>

@end

@implementation TabBarControllerDelegate
-(BOOL)tabBarController:(UITabBarController *)tabBarController
shouldSelectViewController:(UIViewController *)viewController {
    NSLog(@"I'm in the delegate");
    if ([tabBarController.tabBar.selectedItem.title isEqualToString:@"Events"]) {
        WebsiteViewController *websiteVC = (WebsiteViewController *)viewController;
        websiteVC.websiteURL = [NSURL URLWithString: @"http://www.sgucandcs.org/calendar.php?pageID=39"];
    }
    return YES;
}
@end
