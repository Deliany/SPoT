//
//  RecentPhotosViewController.m
//  SPoT
//
//  Created by Deliany Delirium on 28.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "RecentPhotosViewController.h"
#import "RecentPhotosManager.h"

@interface RecentPhotosViewController ()

@end

@implementation RecentPhotosViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RecentPhotoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [super titleForRow:indexPath.row];
    cell.detailTextLabel.text = [super subtitleForRow:indexPath.row];
    
    return cell;
}

- (void)viewDidAppear:(BOOL)animated
{
    self.photos = [RecentPhotosManager getFlickrPhotos];
}

@end
