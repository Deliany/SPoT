//
//  RecentPhotos.h
//  SPoT
//
//  Created by Deliany Delirium on 28.02.13.
//  Copyright (c) 2013 Clear Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Simple manager for storing and fetching recently viewed photos in NSUserDefaults settings
 **/
@interface RecentPhotosManager : NSObject

/**
 * Fetches several recently viewed photos from NSUserDefaults settings
 * @returns array of recently viewed photos, nil if there is no photos stored
 **/
+ (NSArray *)getFlickrPhotos;

/**
 * Stores photo in internal array at first position
 * If photos count is greater then predefined amount, removes last photo
 **/
+ (void)addFlickrPhoto:(NSDictionary *)photo;

@end
