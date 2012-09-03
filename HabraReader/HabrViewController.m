//
//  HabrViewController.m
//  HabraReader
//
//  Created by Philip Vasilchenko on 30.08.12.
//  Copyright (c) 2012 Philip Vasilchenko. All rights reserved.
//

#import "HabrViewController.h"
#import "AppDelegate.h"
#import "HabraPostCell.h"
#import "TSMiniWebBrowser/TSMiniWebBrowser.h"


#pragma mark HabrViewController (Private methods)
@interface HabrViewController ()
@property (nonatomic, retain) NSArray *dataSource;
@end


#pragma mark -
#pragma mark HabrViewController
@implementation HabrViewController

static NSString *const kRSSUrl = @"http://habrahabr.ru/rss";

@synthesize dataSource;
@synthesize webBrowser;

#pragma mark -
#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Load rss data
    if (!dataSource) {
        RSSParser *parser = [[RSSParser alloc] initWithUrl:kRSSUrl asynchronous:YES];
        [[AppDelegate sharedInstance] setNetworkActivityIndicatorVisible:YES];
        [parser setDelegate:self];
        [parser parse];
    }
}

- (void)dealloc {
    [self setWebBrowser:nil];
    [self setDataSource:nil];
    [super dealloc];
}

#pragma mark -
#pragma mark RSSParser Delegate

- (void)rssParserDidStartParsing:(RSSParser *)parser {
    NSLog(@"Start parsing");
}

- (void)rssParser:(RSSParser *)parser didParseFeed:(RSSFeed *)feed {
    NSLog(@"Parsed successfully!");
    self.dataSource = [feed articles];
    [[AppDelegate sharedInstance] setNetworkActivityIndicatorVisible:NO];
    [self.tableView reloadData];
}

- (void)rssParser:(RSSParser *)parser didFailWithError:(NSError *)error {
    NSLog(@"%@", error.localizedDescription);
    [[AppDelegate sharedInstance] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark -
#pragma mark UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HabraPostCell cellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self dataSource] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"HabraPostCell";
    
    HabraPostCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier
                                                     owner:self
                                                   options:nil];
        cell = [nib objectAtIndex:0];
    }

    RSSEntry *entry = [self.dataSource objectAtIndex:indexPath.row];
    [cell fillCellWithEntry:entry];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RSSEntry *entry = [dataSource objectAtIndex:indexPath.row];
    NSString *encoded = [entry.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encoded];
    
    if (!self.webBrowser) {
        self.webBrowser = [[[TSMiniWebBrowser alloc] initWithUrl:url] autorelease];
        self.webBrowser.mode = TSMiniWebBrowserModeNavigation;
        self.webBrowser.showURLStringOnActionSheetTitle = YES;
        self.webBrowser.showPageTitleOnTitleBar = NO;
    } else {
        [self.webBrowser loadURL:url];
    }
    
    [self.navigationController pushViewController:webBrowser animated:YES];
}

@end
