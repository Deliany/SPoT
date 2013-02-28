//
//  RecentPhotos.m
//  SPoT
//
//  Created by Deliany Delirium on 28.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import "RecentPhotosManager.h"

@implementation RecentPhotosManager

#define RECENT_PHOTOS_KEY @"Recent_photos"

+ (NSArray *)getFlickrPhotos
{
    NSArray *photos = [[NSUserDefaults standardUserDefaults] objectForKey:RECENT_PHOTOS_KEY];
    return photos;
}


+ (void)addFlickrPhoto:(NSDictionary *)photo
{
    NSMutableArray *photos = [[[NSUserDefaults standardUserDefaults] objectForKey:RECENT_PHOTOS_KEY] mutableCopy];
    if (!photos) {
        photos = [NSMutableArray arrayWithObject:photo];
    }
    else if([photos containsObject:photo]) {
        return;
    }
    else if([photos count] >= 10) {
        [photos removeLastObject];
        [photos insertObject:photo atIndex:0];
    }
    else {
        [photos insertObject:photo atIndex:0];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:photos forKey:RECENT_PHOTOS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
