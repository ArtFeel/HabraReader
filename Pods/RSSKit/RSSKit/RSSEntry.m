//
// RSSEntry.m
// RSSKit
//
// Created by Árpád Goretity on 01/11/2011.
// Licensed under a CreativeCommons Attribution 3.0 Unported License
//

#import "RSSEntry.h"


@implementation RSSEntry

@synthesize title;
@synthesize url;
@synthesize uid;
@synthesize date;
@synthesize summary;
@synthesize categories;
@synthesize comments;
@synthesize content;
@synthesize copyright;
@synthesize attachedMedia;
@synthesize author;
@synthesize image;


- (id) init {
	self = [super init];
	NSArray *theCategories = [[NSArray alloc] init];
	self.categories = theCategories;
	return self;
}



#pragma mark -
#pragma mark NSCoding Protocol

- (id)initWithCoder:(NSCoder *)decoder {
	if ((self = [super init])) {
        title = [decoder decodeObjectForKey:@"title"];
        url = [decoder decodeObjectForKey:@"url"];
        uid = [decoder decodeObjectForKey:@"uid"];
        date = [decoder decodeObjectForKey:@"date"];
        summary = [decoder decodeObjectForKey:@"summary"];
        categories = [decoder decodeObjectForKey:@"categories"];
        comments = [decoder decodeObjectForKey:@"comments"];
        content = [decoder decodeObjectForKey:@"content"];
        copyright = [decoder decodeObjectForKey:@"copyright"];
        attachedMedia = [decoder decodeObjectForKey:@"attachedMedia"];
        author = [decoder decodeObjectForKey:@"author"];
        image = [decoder decodeObjectForKey:@"image"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:title forKey:@"title"];
    [encoder encodeObject:url forKey:@"uid"];
    [encoder encodeObject:uid forKey:@"url"];
    [encoder encodeObject:date forKey:@"date"];
    [encoder encodeObject:summary forKey:@"summary"];
    [encoder encodeObject:categories forKey:@"categories"];
    [encoder encodeObject:comments forKey:@"comments"];
    [encoder encodeObject:content forKey:@"content"];
    [encoder encodeObject:copyright forKey:@"copyright"];
    [encoder encodeObject:attachedMedia forKey:@"attachedMedia"];
    [encoder encodeObject:author forKey:@"author"];
    [encoder encodeObject:image forKey:@"image"];
}

@end

