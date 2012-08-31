//
//  HabrViewController.m
//  HabraReader
//
//  Created by Philip Vasilchenko on 30.08.12.
//  Copyright (c) 2012 Philip Vasilchenko. All rights reserved.
//

#import "HabrViewController.h"
#import "AppDelegate.h"
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
    
    // Set view title
    self.title = @"Хабрахабр";
    
    // Load rss data
    RSSParser *parser = [[RSSParser alloc] initWithUrl:kRSSUrl asynchronous:YES];
    [parser setDelegate:self];
    [parser parse];
}

- (void)dealloc {
    [detailViewController release];
    [self setDataSource:nil];
    [super dealloc];
}


//- (void)insertNewObject:(id)sender
//{
//    if (!objects) {
//        objects = [[NSMutableArray alloc] init];
//    }
//    [objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

#pragma mark -
#pragma mark RSSParser Delegate
- (void)rssParserDidStartParsing:(RSSParser *)parser {
    NSLog(@"Start parsing");
    [[AppDelegate sharedInstance] setNetworkActivityIndicatorVisible:YES];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self dataSource] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }


    RSSEntry *entry = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = entry.title;
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
