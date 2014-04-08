# SGCC iPhone App

This is the iOS 7 version of the [SGCC](https://itunes.apple.com/us/app/sgcc/id449459787?mt=8) app. Under development.

Note: JSON must NOT be cached!

To Do:

For launch
1) Reachability
Can now use AFNetworkReachabilityManager on its own, or as a property on AFHTTPRequestOperationManager / AFHTTPSessionManager.

AFNetworkReachabilityManager class monitors current network reachability, 
providing callback blocks and notifications for when reachability changes

AFNetworkActivityIndicatorManager: Automatically start and stop the network 
activity indicator in the status bar as request operations and tasks begin and 
finish loading

UIActivityIndicatorView+AFNetworking: Automatically start and stop a
UIActivityIndicatorView according to the state of a specified request
operation or session task

UIProgressView+AFNetworking: Automatically track the upload or download progress 
of a specified request operation or session task

UIWebView+AFNetworking: Provides a more sophisticated API for loading URL 
requests, with support for progress callbacks and content transformation

[self.manager.reachabilityManager startMonitoring]; 

-(BOOL)connected {
    return AFNetworkReachabilityManager.sharedManager.reachable;
}
listen to AFNetworkingReachabilityDidChangeNotification or use the reachabilityStatusChangeBlock
2) Check for updates when app comes to foreground (or, better yet, update when
notified by web site via new silent push notification)
3) View current sermons
4) Download sermons for offline access
5) Airdrop invitation

Future
1) Like Podcast, automatically download specified number of episodes
2) Siri integration?
3) Event/calendar integration
4) Local Core Data database updates when notified that blog post has been
changed