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
#import "DetailViewController.h"


#pragma mark HabrViewController (Private methods)
@interface HabrViewController ()
@property (nonatomic, retain) NSArray *dataSource;
@end


#pragma mark -
#pragma mark HabrViewController
@implementation HabrViewController

static NSString *const kRSSUrl = @"http://habrahabr.ru/rss";

@synthesize dataSource;
@synthesize detailViewController;

#pragma mark -
#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Load rss data
    RSSParser *parser = [[RSSParser alloc] initWithUrl:kRSSUrl asynchronous:YES];
    [[AppDelegate sharedInstance] setNetworkActivityIndicatorVisible:YES];
    [parser setDelegate:self];
    [parser parse];
}

- (void)dealloc {
    [detailViewController release];
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

// Customize the appearance of table view cells.
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
//    if (!self.detailViewController) {
//        self.detailViewController = [[[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil] autorelease];
//    }
//    NSDate *object = [objects objectAtIndex:indexPath.row];
//    self.detailViewController.detailItem = object;
//    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

@end
