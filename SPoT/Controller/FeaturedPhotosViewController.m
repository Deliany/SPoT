//
//  FeaturedPhotosViewController.m
//  SPoT
//
//  Created by Deliany Delirium on 28.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "FeaturedPhotosViewController.h"
#import "FlickrFetcher.h"

@interface FeaturedPhotosViewController ()

@end

@implementation FeaturedPhotosViewController

- (void)setTag:(NSString *)tag
{
    _tag = tag;
    [self loadPhotoForTag];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.refreshControl addTarget:self action:@selector(loadPhotoForTag) forControlEvents:UIControlEventValueChanged];
    [self loadPhotoForTag];
}

- (void)loadPhotoForTag
{
    [self.refreshControl beginRefreshing];
    
    dispatch_queue_t fetchTagsQueue = dispatch_queue_create("fetching photos for tag", NULL);
    dispatch_async(fetchTagsQueue, ^{
        NSArray *photos = [FlickrFetcher photosForTag:self.tag];
        NSArray *sortedPhotos = [photos sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:FLICKR_PHOTO_TITLE ascending:YES]]];
        
        [self.refreshControl endRefreshing];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photos = sortedPhotos;
        });
    });    
}

@end
