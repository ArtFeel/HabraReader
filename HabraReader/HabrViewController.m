//
//  HabrViewController.m
//  HabraReader
//
//  Created by Philip Vasilchenko on 30.08.12.
//  Copyright (c) 2012 Philip Vasilchenko. All rights reserved.
//

#import "HabrViewController.h"

#import <RSSKit/RSSKit.h>
#import <SVWebViewController/SVWebViewController.h>
#import <SVPullToRefresh/SVPullToRefresh.h>

#import "AppDelegate.h"
#import "HabraPostCell.h"


#pragma mark HabrViewController (Private methods)
@interface HabrViewController () <RSSParserDelegate>

@property (nonatomic, retain) NSArray *dataSource;
@property (nonatomic, retain) RSSParser *rssParser;

- (void)loadNewPosts;
- (void)customizePullDownToRefresh;
@end


#pragma mark -
#pragma mark HabrViewController
@implementation HabrViewController

static NSString *const kRSSUrl = @"http://habrahabr.ru/rss";

@synthesize dataSource;
@synthesize rssParser;

#pragma mark -
#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Load rss data
    if (!dataSource) {
        [self loadNewPosts];
        [self customizePullDownToRefresh];
    }
}

- (void)dealloc {
    [self setDataSource:nil];
    [super dealloc];
}

#pragma mark -
#pragma mark Private methods

- (void)loadNewPosts {
    if (!self.rssParser) {
        RSSParser *parser = [[RSSParser alloc] initWithUrl:kRSSUrl asynchronous:YES];
        [parser setDelegate:self];
        self.rssParser = parser;
        [parser release];
    }
    
    [[AppDelegate sharedInstance] setNetworkActivityIndicatorVisible:YES];
    [self.rssParser parse];
}

- (void)customizePullDownToRefresh {
    // Setup date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    self.tableView.pullToRefreshView.dateFormatter = dateFormatter;
    [dateFormatter release];
    
    // Setup pullToRefresh action block
    [self.tableView addPullToRefreshWithActionHandler:^{
        NSLog(@"Load new posts");
        [self loadNewPosts];
    }];
}

#pragma mark -
#pragma mark RSSParser Delegate

- (void)rssParserDidStartParsing:(RSSParser *)parser {
    NSLog(@"Start parsing");
}

- (void)rssParser:(RSSParser *)parser didParseFeed:(RSSFeed *)feed {
    NSLog(@"Parsed successfully!");
    self.dataSource = [feed articles];
    self.tableView.pullToRefreshView.lastUpdatedDate = [NSDate date];
    [self.tableView.pullToRefreshView stopAnimating];
    [[AppDelegate sharedInstance] setNetworkActivityIndicatorVisible:NO];
    [self.tableView reloadData];
}

- (void)rssParser:(RSSParser *)parser didFailWithError:(NSError *)error {
    NSLog(@"%@", error.localizedDescription);
    [self.tableView.pullToRefreshView stopAnimating];
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
    
    SVWebViewController *browser = [[SVWebViewController alloc] initWithAddress:encoded];
    [browser setCustomTitle:@""];
    
    [self.tableView.pullToRefreshView stopAnimating];
    [self.navigationController pushViewController:browser animated:YES];
    [browser release];
}

@end