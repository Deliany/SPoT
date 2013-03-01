//
//  TagsViewController.m
//  SPoT
//
//  Created by Deliany Delirium on 28.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "TagsViewController.h"
#import "FlickrFetcher.h"

@interface TagsViewController ()
@property (strong, nonatomic) NSCountedSet *tagsCountedSet;
@property (strong, nonatomic) NSArray *tagsArray;
@end

@implementation TagsViewController

- (void)setTagsCountedSet:(NSCountedSet *)tagsCountedSet
{
    _tagsCountedSet = tagsCountedSet;
    
    NSArray *tagsArr = [tagsCountedSet allObjects];
    NSArray *sortedTags = [tagsArr sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES]]];
    
    self.tagsArray = sortedTags;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.refreshControl addTarget:self action:@selector(loadTags) forControlEvents:UIControlEventValueChanged];   
    [self loadTags];
}

- (void)loadTags
{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t fetchTagsQueue = dispatch_queue_create("fetching tags", NULL);
    dispatch_async(fetchTagsQueue, ^{
        self.tagsCountedSet = [FlickrFetcher filteredTags];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
        [self.refreshControl endRefreshing];
    });
}

#pragma mark - Segue

#define FEATURED_SEGUE_ID @"Show Featured"

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:FEATURED_SEGUE_ID]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setTag:)]) {
                    NSString *tag = self.tagsArray[indexPath.row];
                    [segue.destinationViewController performSelector:@selector(setTag:) withObject:tag];
                    [segue.destinationViewController setTitle:[tag capitalizedString]];
                }
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.tagsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    NSString *capitalizedTag = [[self.tagsArray objectAtIndex:indexPath.row] capitalizedString];
    NSUInteger photosCount = [self.tagsCountedSet countForObject:[self.tagsArray objectAtIndex:indexPath.row]];
    NSString *photosCountLabel = [NSString stringWithFormat:@"%d photo%@", photosCount, photosCount > 1 ? @"s" : @""];
    
    cell.textLabel.text = capitalizedTag;
    cell.detailTextLabel.text = photosCountLabel;
    
    return cell;
}

@end
