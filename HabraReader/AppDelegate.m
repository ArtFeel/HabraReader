//
//  AppDelegate.m
//  HabraReader
//
//  Created by Philip Vasilchenko on 30.08.12.
//  Copyright (c) 2012 Philip Vasilchenko. All rights reserved.
//

#import "AppDelegate.h"
#import "HabrViewController.h"

@implementation AppDelegate

@synthesize window;
@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Create main view
    HabrViewController *habrViewController = [[[HabrViewController alloc] init] autorelease];
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:habrViewController] autorelease];
    
    // Create main window
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    // Set black statusbar
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    
    return YES;
}

- (void)dealloc {
    [window release];
    [navigationController release];
    [super dealloc];
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
    
    // The assertion helps to find programmer errors in activity indicator management.
    // Since a negative NumberOfCallsToSetVisible is not a fatal error,
    // it should probably be removed from production code.
    NSAssert(NumberOfCallsToSetVisible >= 0, @"Network Activity Indicator was asked to hide more often than shown");
    
    // Display the indicator as long as our static counter is > 0.
    UIApplication *application = [UIApplication sharedApplication];
    [application setNetworkActivityIndicatorVisible:(NumberOfCallsToSetVisible > 0)];
}

@end
