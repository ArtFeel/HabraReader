//
// RSSParser.m
// RSSKit
//
// Created by Árpád Goretity on 01/11/2011.
// Licensed under a CreativeCommons Attribution 3.0 Unported License
//

#import "RSSParser.h"
#import "NSMutableString+RSSKit.h"

@implementation RSSParser

@synthesize delegate;
@synthesize url, contentUrl, request, urlConnection, asyncData, async;
@synthesize xmlParser, tagStack, tagPath, feed, entry;
@synthesize parsing, failed, successful;


#pragma mark -
#pragma mark NSObject

- (id) initWithUrl:(NSString *)theUrl asynchronous:(BOOL)sync {
	self = [super init];
	self.url = theUrl;
	self.async = sync;
    return self;
}

- (id) initWithUrl:(NSString *)theUrl {
	self = [self initWithUrl:theUrl asynchronous:NO];  // default is synchronous
	return self;
}

- (id) init {
	self = [self initWithUrl:nil];
	return self;
}

- (void) dealloc {
    [xmlParser setDelegate:nil];
}


#pragma mark - 
#pragma mark Parsing

- (void) reset {
    self.contentUrl = nil;
    self.request = nil;
    self.urlConnection = nil;
    self.asyncData = nil;
    self.tagPath = nil;
    self.tagStack = nil;
    self.entry = nil;
}

- (void) parse {
    
    // reset vars
    [self reset];
    
    // checks before parsing
    if (!delegate || !url) {
        [self parsingFailedWithDescription:@"Delegate or URL not specified" andErrorCode:RSSErrorCodeNotInitialized];
        return;
    }
    if (parsing) {
        [self parsingFailedWithDescription:@"Parsing is already in progress" andErrorCode:RSSErrorCodeNotInitialized];
        return;
    }
    
    // set state
    parsing = YES;
    failed = NO;
    successful = NO;
    
    // create request
    contentUrl = [[NSURL alloc] initWithString:self.url];
    request = [[NSMutableURLRequest alloc] initWithURL:contentUrl
                                           cachePolicy:NSURLRequestReloadRevalidatingCacheData
                                       timeoutInterval:60];
    
    // download the feed
    if (self.async) {
        
        // Asynchronous
        urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		if (urlConnection) {
			asyncData = [[NSMutableData alloc] init];
		} else {
            [self parsingFailedWithDescription:@"Asynchronous connection failed" andErrorCode:RSSErrorCodeConnectionFailed];
		}
        
    } else {
        
		// Synchronous
        NSURLResponse *response = nil;
		NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (data && !error) {
            [self startParsingData:data];  // process
        } else {
            [self parsingFailedWithDescription:@"Synchronous connection failed" andErrorCode:RSSErrorCodeConnectionFailed];
        }
        
    }
}

- (void) startParsingData:(NSData*)data {
    
    if (data) {
        // create parser
        NSXMLParser *newXmlParser = [[NSXMLParser alloc] initWithData:data];
        self.xmlParser = newXmlParser;
        if (xmlParser) { 
        
            // Parse!
            xmlParser.delegate = self;
            [xmlParser parse]; 
            self.xmlParser = nil; // Release after parse
        
        } else {
            [self parsingFailedWithDescription:@"Feed is not a valid XML document" andErrorCode:RSSErrorCodeXmlParser];
        }
    }
    
}

- (void) finishedParsing {
    
    if (!successful) {
    
        // set state
        parsing = NO;
        failed = NO;
        successful = YES;
    
        // inform delegate 
        if ([delegate respondsToSelector:@selector(rssParser:didParseFeed:)]) {
            [delegate rssParser:self didParseFeed:feed];
        }
        
        // reset
        [self reset];
    }
}

- (void) parsingFailedWithDescription:(NSString*)message andErrorCode:(int)code {
    
    // set state
    parsing = NO;
    failed = YES;
    successful = NO;
    
    // reset
    [self reset];
    
    // create error
    NSError *error = [NSError errorWithDomain:RSSErrorDomain 
                                        code:code 
                                    userInfo:[NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey]];
    
    // inform delegate
    if ([delegate respondsToSelector:@selector(rssParser:didFailWithError:)])
        [delegate rssParser:self didFailWithError:error];
}


#pragma mark -
#pragma mark NSURLConnectionDelegate

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[asyncData setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[asyncData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	urlConnection = nil;
	asyncData = nil;
    
    // error
    [self parsingFailedWithDescription:[error localizedDescription] andErrorCode:RSSErrorCodeConnectionFailed];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	[self startParsingData:asyncData]; 	// perform parsing
    urlConnection = nil;
    asyncData = nil;  
}

-(NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
	return nil;
}


#pragma mark -
#pragma mark NSXMLParserDelegate

- (void) parserDidStartDocument:(NSXMLParser *)parser {
	if ([delegate respondsToSelector:@selector(rssParserDidStartParsing:)]) {
		[delegate rssParserDidStartParsing:self];
    }
	feed = [[RSSFeed alloc] init];
    
    //feed.articles = [[NSMutableArray alloc] init];
    //feed.categories = [[NSMutableArray alloc] init];
    
	tagStack = [[NSMutableArray alloc] init];
	tagPath = [[NSMutableString alloc] initWithString:@"/"];
}

- (void) parserDidEndDocument:(NSXMLParser *)parser {
    
    // parsing succeessful
    [self finishedParsing];
}

- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)error {

    // error
    [self parsingFailedWithDescription:[error localizedDescription] andErrorCode:RSSErrorCodeXmlParser];
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)element namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributes {
	// decide type of the feed based on its root element
	if ([element isEqualToString:@"rss"]) {
		feed.type = RSSFeedTypeRSS;
	} else if ([element isEqualToString:@"feed"]) {
		feed.type = RSSFeedTypeAtom;
	} else if ([element isEqualToString:@"item"] || [element isEqualToString:@"entry"]) {
		// or, if it's an article summary tag, create an article object
		entry = [[RSSEntry alloc] init];
	}
	// prepare to successively receive characters
	// then push element onto stack
	NSMutableDictionary *context = [[NSMutableDictionary alloc] init];
	[context setObject:attributes forKey:@"attributes"];
	NSMutableString *text = [[NSMutableString alloc] init];
	[context setObject:text forKey:@"text"];
	[tagStack addObject:context];
	[tagPath appendPathComponent:element];
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)element namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName {
	NSMutableDictionary *context = [tagStack lastObject];
	NSMutableString *text = [context objectForKey:@"text"];
	NSDictionary *attributes = [context objectForKey:@"attributes"];
	if ([tagPath isEqualToString:@"/rss/channel/title"] || [tagPath isEqualToString:@"/feed/title"]) {
		feed.title = text;
	} else if ([tagPath isEqualToString:@"/rss/channel/description"] || [tagPath isEqualToString:@"/feed/subtitle"]) {
		feed.description = text;
	} else if ([tagPath isEqualToString:@"/feed/id"]) {
		feed.uid = text;
	} else if ([tagPath isEqualToString:@"/rss/channel/link"] || [tagPath isEqualToString:@"/feed/link"]) {
		// RSS 2.0 or Atom 1.0?
			NSString *href = [attributes objectForKey:@"href"];
		if (href) {
			// Atom 1.0
			feed.url = href;
		} else {
			// RSS 2.0
			feed.url = text;
		}
	} else if ([tagPath isEqualToString:@"/rss/channel/language"]) {
		feed.language = text;
	} else if ([tagPath isEqualToString:@"/rss/channel/copyright"] || [tagPath isEqualToString:@"/feed/rights"]) {
		feed.copyright = text;
	} else if ([tagPath isEqualToString:@"/rss/channel/category"] || [tagPath isEqualToString:@"/feed/category"]) {
		// RSS 2.0 or Atom 1.0?
		NSString *term = [attributes objectForKey:@"term"];
		if (term) {
			// Atom 1.0
            feed.categories = [feed.articles arrayByAddingObject:term];
		} else {
			// RSS 2.0
            feed.categories = [feed.articles arrayByAddingObject:text];
		}
		
	} else if ([tagPath isEqualToString:@"/rss/channel/generator"] || [tagPath isEqualToString:@"/feed/generator"]) {
		feed.generator = text;
	} else if ([tagPath isEqualToString:@"/rss/channel/ttl"]) {
		feed.validTime = [text floatValue];
	} else if ([tagPath isEqualToString:@"/rss/channel/image/url"] || [tagPath isEqualToString:@"/feed/icon"]) {
		feed.iconUrl = text;
	} else if ([tagPath isEqualToString:@"/rss/channel/cloud"]) {
		RSSCloudService *cloudService = [[RSSCloudService alloc] init];
		cloudService.domain = [attributes objectForKey:@"domain"];
		cloudService.port = [[attributes objectForKey:@"port"] intValue];
		cloudService.path = [attributes objectForKey:@"path"];
		cloudService.procedure = [attributes objectForKey:@"registerProcedure"];
		cloudService.protocol = [attributes objectForKey:@"protocol"];
		feed.cloudService = cloudService;
	} else if ([tagPath isEqualToString:@"/rss/channel/lastBuildDate"] || [tagPath isEqualToString:@"/feed/updated"]) {
		feed.date = text;
	} else if ([tagPath isEqualToString:@"/rss/channel/managingEditor"]) {
		feed.author = text;
	} else if ([tagPath isEqualToString:@"/feed/author/name"]) {
		feed.author = feed.author ? [NSString stringWithFormat:@"%@ (%@)", text, feed.author] : text;
	} else if ([tagPath isEqualToString:@"/feed/author/email"]) {
		feed.author = feed.author ? [NSString stringWithFormat:@"%@ (%@)", feed.author, text] : text;
	} else if ([tagPath isEqualToString:@"/rss/channel/item/title"] || [tagPath isEqualToString:@"/feed/entry/title"]) {
		entry.title = text;
	} else if ([tagPath isEqualToString:@"/rss/channel/item/link"] || [tagPath isEqualToString:@"/feed/entry/link"]) {
		// RSS 2.0 or Atom 1.0?
		NSString *href = [attributes objectForKey:@"href"];
		if (href) {
			// Atom 1.0
			entry.url = href;
		} else {
			// RSS 2.0
			entry.url = text;
		}
	} else if ([tagPath isEqualToString:@"/rss/channel/item/description"] || [tagPath isEqualToString:@"/feed/entry/summary"]) {
		entry.summary = text;
	} else if ([tagPath isEqualToString:@"/rss/channel/item/category"] || [tagPath isEqualToString:@"/feed/entry/category"]) {
		// RSS 2.0 or Atom 1.0?
		NSString *term = [attributes objectForKey:@"term"];
		if (term) {
			// Atom 1.0
            entry.categories = [feed.categories arrayByAddingObject:term];
		} else {
			// RSS 2.0
            entry.categories = [feed.categories arrayByAddingObject:text];
		}
	} else if ([tagPath isEqualToString:@"/rss/channel/item/comments"] || [tagPath isEqualToString:@""]) {
		entry.comments = text;
	} else if ([tagPath isEqualToString:@"/rss/channel/item/author"] || [tagPath isEqualToString:@"/feed/entry/author/name"] || [tagPath isEqualToString:@"/rss/channel/item/dc:creator"]) {
		entry.author = text;
	} else if ([tagPath isEqualToString:@"/feed/entry/content"] || [tagPath isEqualToString:@"/rss/channel/item/content:encoded"]) {
        entry.content = text;
        // scan for first image in content html
        entry.image = [self processImage:entry.content ? entry.content : entry.summary];
	} else if ([tagPath isEqualToString:@"/rss/channel/item/enclosure"]) {	
		RSSAttachedMedia *media = [[RSSAttachedMedia alloc] init];
		media.url = [attributes objectForKey:@"url"];
		media.length = [[attributes objectForKey:@"length"] intValue];
		media.type = [attributes objectForKey:@"type"];
		entry.attachedMedia = media;
	} else if ([tagPath isEqualToString:@"/rss/channel/item/guid"] || [tagPath isEqualToString:@"/feed/entry/id"]) {
		entry.uid = text;
	} else if ([tagPath isEqualToString:@"/rss/channel/item/pubDate"] || [tagPath isEqualToString:@"/feed/entry/updated"]) {
		entry.date = text;
	} else if ([tagPath isEqualToString:@"/feed/entry/rights"]) {
		entry.copyright = text;
	} else if ([tagPath isEqualToString:@"/rss/channel/item"] || [tagPath isEqualToString:@"/feed/entry"]) {
        feed.articles = [feed.articles arrayByAddingObject:entry];
	}
	[tagStack removeLastObject];
	[tagPath deleteLastPathComponent];
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	NSMutableDictionary *context = [tagStack lastObject];
	NSMutableString *text = [context objectForKey:@"text"];
	[text appendString:string];
}

- (void) parser:(NSXMLParser *)parser foundCDATA:(NSData *)data {
	NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSMutableDictionary *context = [tagStack lastObject];
	NSMutableString *text = [context objectForKey:@"text"];
	[text appendString:string];
}

- (NSString *) processImage:(NSString *)htmlString {
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString: htmlString];
    
    // find start of tag
    [theScanner scanUpToString: @"<img src=\"" intoString: NULL];
    if ([theScanner isAtEnd] == NO) {
        NSInteger newLoc = [theScanner scanLocation] + 10;
        [theScanner setScanLocation: newLoc];
        
        // find end of tag
        [theScanner scanUpToString: @"\"" intoString: &text];
    }
    
    // uri contain .jpg ?
    NSString *format = @".jpg";
    NSRange range = [text rangeOfString : format];
    
    if (range.location != NSNotFound) {
        // found it!
        return text;
    }
    
    return nil;
}

@end

