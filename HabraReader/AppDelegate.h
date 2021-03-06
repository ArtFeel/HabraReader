//
//  AppDelegate.h
//  HabraReader
//
//  Created by Philip Vasilchenko on 30.08.12.
//  Copyright (c) 2012 Philip Vasilchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;

+ (AppDelegate *)sharedInstance;

- (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible;
- (BOOL)isNetworkReachable;

@end
