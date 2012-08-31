//
//  HabrViewController.h
//  HabraReader
//
//  Created by Philip Vasilchenko on 30.08.12.
//  Copyright (c) 2012 Philip Vasilchenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RSSKit/RSSKit.h>

@class DetailViewController;

@interface HabrViewController : UITableViewController <RSSParserDelegate>
@property (strong, nonatomic) DetailViewController *detailViewController;
@property (nonatomic, retain) DetailViewController *dddController;
@end
