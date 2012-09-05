//
// RSSFeed.h
// RSSKit
//
// Created by Árpád Goretity on 01/11/2011.
// Licensed under a CreativeCommons Attribution 3.0 Unported License
//

#import <Foundation/Foundation.h>
#import "RSSCloudService.h"
#import "RSSDefines.h"


@interface RSSFeed: NSObject <NSCoding> {
	RSSFeedType type;
	NSString *title;
	NSString *description;
	NSString *url;
	NSString *date;
	NSString *author;
    NSArray *articles;
	NSString *uid;
	NSString *language;
	NSString *copyright;
    NSArray *categories;
	NSString *generator;
	float validTime;
	NSString *iconUrl;
	RSSCloudService *cloudService;
}

@property (nonatomic) RSSFeedType type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSArray *articles;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *copyright;
@property (nonatomic, copy) NSArray *categories;
@property (nonatomic, copy) NSString *generator;
@property (nonatomic) float validTime;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) RSSCloudService *cloudService;


@end

