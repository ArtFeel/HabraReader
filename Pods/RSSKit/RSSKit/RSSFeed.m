//
// RSSFeed.m
// RSSKit
//
// Created by Árpád Goretity on 01/11/2011.
// Licensed under a CreativeCommons Attribution 3.0 Unported License
//

#import "RSSFeed.h"


@implementation RSSFeed

@synthesize type;
@synthesize title;
@synthesize description;
@synthesize url;
@synthesize date;
@synthesize author;
@synthesize articles;
@synthesize uid;
@synthesize language;
@synthesize copyright;
@synthesize categories;
@synthesize generator;
@synthesize validTime;
@synthesize iconUrl;
@synthesize cloudService;


- (id) init {
	if (self = [super init]) {
        NSArray *theArticles = [[NSArray alloc] init];
        self.articles = theArticles;
        NSArray *theCategories = [[NSArray alloc] init];
        self.categories = theCategories;

    }
	return self;
}



#pragma mark -
#pragma mark NSCoding Protocol

- (id)initWithCoder:(NSCoder *)decoder {
	if ((self = [super init])) {
        type = [decoder decodeIntForKey:@"type"];
        title = [decoder decodeObjectForKey:@"title"];
        description = [decoder decodeObjectForKey:@"description"];
        url = [decoder decodeObjectForKey:@"url"];
        date = [decoder decodeObjectForKey:@"date"];
        author = [decoder decodeObjectForKey:@"author"];
        articles = [decoder decodeObjectForKey:@"articles"];
        uid = [decoder decodeObjectForKey:@"uid"];
        language = [decoder decodeObjectForKey:@"language"];
        copyright = [decoder decodeObjectForKey:@"copyright"];
        categories = [decoder decodeObjectForKey:@"categories"];
        generator = [decoder decodeObjectForKey:@"generator"];
        validTime = [decoder decodeFloatForKey:@"validTime"];
        iconUrl = [decoder decodeObjectForKey:@"iconUrl"];
        cloudService = [decoder decodeObjectForKey:@"cloudService"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:type forKey:@"type"];
    [encoder encodeObject:title forKey:@"title"];
    [encoder encodeObject:description forKey:@"description"];
    [encoder encodeObject:url forKey:@"url"];
    [encoder encodeObject:date forKey:@"date"];
    [encoder encodeObject:author forKey:@"author"];
    [encoder encodeObject:articles forKey:@"articles"];
    [encoder encodeObject:uid forKey:@"uid"];
    [encoder encodeObject:language forKey:@"language"];
    [encoder encodeObject:copyright forKey:@"copyright"];
    [encoder encodeObject:categories forKey:@"categories"];
    [encoder encodeObject:generator forKey:@"generator"];
    [encoder encodeFloat:validTime forKey:@"validTime"];
    [encoder encodeObject:iconUrl forKey:@"inconUrl"];
    [encoder encodeObject:cloudService forKey:@"cloudService"];
}

@end

