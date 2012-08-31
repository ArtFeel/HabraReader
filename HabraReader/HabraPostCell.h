//
//  HabraPostCell.h
//  HabraReader
//
//  Created by Philip Vasilchenko on 31.08.12.
//  Copyright (c) 2012 Philip Vasilchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSSEntry;

@interface HabraPostCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *contentLabel;
@property (nonatomic, retain) IBOutlet UILabel *usernameLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;

+ (CGFloat)cellHeight;
- (void)fillCellWithEntry:(RSSEntry *)entry;

@end
