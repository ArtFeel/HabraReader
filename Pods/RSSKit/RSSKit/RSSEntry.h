//
// RSSEntry.h
// RSSKit
//
// Created by Árpád Goretity on 01/11/2011.
// Licensed under a CreativeCommons Attribution 3.0 Unported License
//

#import <Foundation/Foundation.h>
#import "RSSAttachedMedia.h"


@interface RSSEntry: NSObject <NSCoding> {
	NSString *title;
	NSString *url;
	NSString *uid;
	NSString *date;
	NSString *summary;
	NSArray *categories;
	NSString *comments;
	NSString *content;
	NSString *copyright;
	RSSAttachedMedia *attachedMedia;
	NSString *author;
    NSString *image;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSArray *categories;
@property (nonatomic, copy) NSString *comments;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *copyright;
@property (nonatomic, copy) RSSAttachedMedia *attachedMedia;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *image;

@end

