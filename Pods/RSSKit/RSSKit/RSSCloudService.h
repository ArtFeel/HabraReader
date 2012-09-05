//
// RSSCloudService.h
// RSSKit
//
// Created by Árpád Goretity on 21/12/2011.
// Licensed under a CreativeCommons Attribution 3.0 Unported License
//

#import <Foundation/Foundation.h>


@interface RSSCloudService: NSObject <NSCoding> {
	NSString *domain;
	int port;
	NSString *path;
	NSString *procedure;
	NSString *protocol;
}

@property (nonatomic, copy) NSString *domain;
@property (nonatomic) int port;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *procedure;
@property (nonatomic, copy) NSString *protocol;

@end

