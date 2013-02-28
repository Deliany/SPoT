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

- (NSArray *)tagsArray
{
    if (!_tagsArray) {
        if (self.tagsCountedSet) {
            NSMutableArray *tagsArr = [NSMutableArray arrayWithCapacity:[self.tagsCountedSet count]];
            for (NSString *tag in self.tagsCountedSet) {
                [tagsArr addObject:tag];
            }
            [tagsArr sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES]]];
            _tagsArray = tagsArr;
        }
    }
    return _tagsArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tagsCountedSet = [FlickrFetcher filteredTags];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        UITableViewCell *cell = (UITableViewCell*)sender;
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Show Featured"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setPhotos:)]) {
                    
                    NSArray *photos = [FlickrFetcher photosForTag:self.tagsArray[indexPath.row]];
                    NSArray *sortedPhotos = [photos sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:FLICKR_PHOTO_TITLE ascending:YES]]];
                    [segue.destinationViewController performSelector:@selector(setPhotos:) withObject:sortedPhotos];
                    [segue.destinationViewController setTitle:cell.textLabel.text];
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
    static NSString *CellIdentifier = @"TagCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [[self.tagsArray objectAtIndex:indexPath.row] capitalizedString];
    cell.detailTextLabel.text = [@([self.tagsCountedSet countForObject:[self.tagsArray objectAtIndex:indexPath.row]]) stringValue];
    
    return cell;
}

@end
