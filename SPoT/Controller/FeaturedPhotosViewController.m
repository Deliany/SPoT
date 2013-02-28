//
//  FeaturedPhotosViewController.m
//  SPoT
//
//  Created by Deliany Delirium on 28.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "FeaturedPhotosViewController.h"

@interface FeaturedPhotosViewController ()

@end

@implementation FeaturedPhotosViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FeaturedPhotoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [super titleForRow:indexPath.row];
    cell.detailTextLabel.text = [super subtitleForRow:indexPath.row];
    
    return cell;
}

@end
