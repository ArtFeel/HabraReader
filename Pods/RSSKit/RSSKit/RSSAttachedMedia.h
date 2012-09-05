//
// RSSAttachedMedia.h
// RSSKit
//
// Created by Árpád Goretity on 21/12/2011.
// Licensed under a CreativeCommons Attribution 3.0 Unported License
//

#import <Foundation/Foundation.h>


@interface RSSAttachedMedia: NSObject <NSCoding, NSCopying> {
	NSString *url;
    NSString *type;
	int length;
}

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *type;
@property (nonatomic) int length;


@end

