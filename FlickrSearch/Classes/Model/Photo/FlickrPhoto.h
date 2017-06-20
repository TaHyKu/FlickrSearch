//
//  FlickrPhoto.h
//  FlickrSearch
//
//  Created by TaHyKu on 18.06.17.
//  Copyright © 2017 IvanoffApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrPhoto : NSObject

@property (nonatomic, strong, readonly) NSString *title;

+ (FlickrPhoto *)flickrPhotoFrom:(NSDictionary *)dictionary;

- (NSString *)photoLink;

@end
