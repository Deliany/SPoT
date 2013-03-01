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

- (void)viewDidAppear:(BOOL)animated
{
    self.photos = [RecentPhotosManager getFlickrPhotos];
}

@end
