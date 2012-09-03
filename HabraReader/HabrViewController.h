//
//  HabrViewController.h
//  HabraReader
//
//  Created by Philip Vasilchenko on 30.08.12.
//  Copyright (c) 2012 Philip Vasilchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RSSKit/RSSKit.h>

@class TSMiniWebBrowser;

@interface HabrViewController : UITableViewController <RSSParserDelegate>
@property (nonatomic, retain) TSMiniWebBrowser *webBrowser;
@end
