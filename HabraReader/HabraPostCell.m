//
//  HabraPostCell.m
//  HabraReader
//
//  Created by Philip Vasilchenko on 31.08.12.
//  Copyright (c) 2012 Philip Vasilchenko. All rights reserved.
//

#import "HabraPostCell.h"
#import <RSSKit/RSSEntry.h>

#pragma mark HabraPostCell (Private methods)
@interface HabraPostCell ()
- (NSString *)formatedDateFromEntryDate:(NSString *)entryDate;
- (NSString *)cleanSummaryFromEntrySummary:(NSString *)entrySummary;
@end


#pragma mark -
#pragma mark HabraPostCell
@implementation HabraPostCell

@synthesize titleLabel;
@synthesize contentLabel;
@synthesize usernameLabel;
@synthesize dateLabel;

- (void)dealloc {
    [titleLabel release];
    [contentLabel release];
    [usernameLabel release];
    [dateLabel release];
    [super dealloc];
}

#pragma mark -
#pragma mark Public methods

+ (CGFloat)cellHeight {
    return 100.0f;
}

- (void)fillCellWithEntry:(RSSEntry *)entry {
    self.titleLabel.text = entry.title;
    self.contentLabel.text = [self cleanSummaryFromEntrySummary:entry.summary];
    self.usernameLabel.text = entry.author;
    self.dateLabel.text = [self formatedDateFromEntryDate:entry.date];
}

#pragma mark -
#pragma mark Private methods

- (NSString *)formatedDateFromEntryDate:(NSString *)entryDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // Conver rss date string to nsdate
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"us_US"];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyy HH:mm:ss zzz"];
    [dateFormatter setLocale:usLocale];
    NSDate *date = [dateFormatter dateFromString:entryDate];
    [usLocale release];
    
    // Conver nsdate to formatted string
    NSLocale *ruLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];
    NSString *format = [NSString stringWithFormat:@"dd MMMM yyyy '%@' HH:mm", LSTRING(@"at")];
    [dateFormatter setDateFormat:format];
    [dateFormatter setLocale:ruLocale];
    NSString *formatedDate = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    [ruLocale release];

    return formatedDate;
}

- (NSString *)cleanSummaryFromEntrySummary:(NSString *)entrySummary {
    NSString *summary = [[entrySummary copy] autorelease];
    NSRange range;
    
    // Remove all habrahabr tags from post
    while ((range = [summary rangeOfString:@"<[^>]+>"
                                   options:NSRegularExpressionSearch]).location != NSNotFound)
    {
        summary = [summary stringByReplacingCharactersInRange:range withString:@""];
    }
    
    // Remove white spaces
    summary = [summary stringByTrimmingCharactersInSet:
               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return summary;
}

@end
