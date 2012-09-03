//
//  AppDelegate.m
//  HabraReader
//
//  Created by Philip Vasilchenko on 30.08.12.
//  Copyright (c) 2012 Philip Vasilchenko. All rights reserved.
//

#import "AppDelegate.h"

#import <Reachability/Reachability.h>
#import "HabrViewController.h"


#pragma mark AppDelegate (Private methods)
@interface AppDelegate ()
- (void)applyStylesheet;
@end

#pragma mark -
#pragma mark AppDelegate
@implementation AppDelegate

@synthesize window;
@synthesize navigationController;

- (BOOL)application:(UIApplication *)app didFinishLaunchingWithOptions:(NSDictionary *)options {
    // Create main view
    HabrViewController *habrViewController = [[[HabrViewController alloc] init] autorelease];
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:habrViewController] autorelease];
    
    // Create main window
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    // Set style
    [app setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    [self applyStylesheet];
    
    return YES;
}

- (void)dealloc {
    [window release];
    [navigationController release];
    [super dealloc];
}

#pragma mark -
#pragma Private methods

- (void)applyStylesheet {
    UINavigationBar *navigationBar = [UINavigationBar appearance];
	[navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-background"]
                        forBarMetrics:UIBarMetricsDefault];
    
    [navigationBar setTintColor:[UIColor colorWithRed:0 green:0.4f blue:0.4f alpha:0.8f]];
}

#pragma mark -
#pragma Additional methods

+ (AppDelegate *)sharedInstance {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible {
    static NSInteger NumberOfCallsToSetVisible = 0;
    if (setVisible)
        NumberOfCallsToSetVisible++;
    else
        NumberOfCallsToSetVisible--;
    
    // This log helps to find programmer errors in activity indicator management.
    if (NumberOfCallsToSetVisible < 0)
        NSLog(@"Network Activity Indicator was asked to hide more often than shown");
    
    // Display the indicator as long as our static counter is > 0.
    UIApplication *application = [UIApplication sharedApplication];
    [application setNetworkActivityIndicatorVisible:(NumberOfCallsToSetVisible > 0)];
}

- (BOOL)isNetworkReachable {
    Reachability* reachability = [Reachability reachabilityWithHostname:@"m.habrahabr.ru"];
    return [reachability isReachable];
}

@end
