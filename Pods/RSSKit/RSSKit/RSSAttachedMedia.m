//
// RSSAttachedMedia.m
// RSSKit
//
// Created by Árpád Goretity on 21/12/2011.
// Licensed under a CreativeCommons Attribution 3.0 Unported License
//

#import "RSSAttachedMedia.h"


@implementation RSSAttachedMedia

@synthesize url;
@synthesize length;
@synthesize type;


#pragma mark -
#pragma mark NSCoding Protocol

- (id)initWithCoder:(NSCoder *)decoder {
	if ((self = [super init])) {
        url = [decoder decodeObjectForKey:@"url"];
        type = [decoder decodeObjectForKey:@"type"];
        length = [decoder decodeIntForKey:@"length"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:url forKey:@"url"];
    [encoder encodeObject:type forKey:@"type"];
    [encoder encodeInt:length forKey:@"length"];
}

-(id)copyWithZone:(NSZone *)zone {
    RSSAttachedMedia *copy = [[[self class] alloc] init];
    copy.url = [self.url copyWithZone:zone];
    copy.type = [self.type copyWithZone:zone];
    copy.length = self.length;
    
    return copy;
}
@end

