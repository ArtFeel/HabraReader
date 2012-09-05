//
// RSSCloudService.m
// RSSKit
//
// Created by Árpád Goretity on 21/12/2011.
// Licensed under a CreativeCommons Attribution 3.0 Unported License
//

#import "RSSCloudService.h"


@implementation RSSCloudService

@synthesize domain;
@synthesize port;
@synthesize path;
@synthesize procedure;
@synthesize protocol;


#pragma mark -
#pragma mark NSCoding Protocol

- (id)initWithCoder:(NSCoder *)decoder {
	if ((self = [super init])) {
        domain = [decoder decodeObjectForKey:@"domain"];
        port = [decoder decodeIntForKey:@"port"];
        path = [decoder decodeObjectForKey:@"path"];
        procedure = [decoder decodeObjectForKey:@"procedure"];
        protocol = [decoder decodeObjectForKey:@"protocol"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:domain forKey:@"domain"];
    [encoder encodeInt:port forKey:@"port"];
    [encoder encodeObject:path forKey:@"path"];
    [encoder encodeObject:procedure forKey:@"procedure"];
    [encoder encodeObject:protocol forKey:@"protocol"];
}

@end

