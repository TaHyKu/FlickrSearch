//
//  FlickrPhoto.m
//  FlickrSearch
//
//  Created by TaHyKu on 18.06.17.
//  Copyright © 2017 IvanoffApps. All rights reserved.
//

#import "FlickrPhoto.h"

static NSString *const identifierKey = @"id";
static NSString *const ownerKey = @"owner";
static NSString *const secretKey = @"secret";
static NSString *const serverKey = @"server";
static NSString *const farmKey = @"farm";
static NSString *const titleKey = @"title";
static NSString *const isPublicKey = @"ispublic";
static NSString *const isFriendKey = @"isfriend";
static NSString *const isFamilyKey = @"isfamily";

@interface FlickrPhoto ()

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *owner;
@property (nonatomic, strong) NSString *secret;
@property (nonatomic, strong) NSString *server;
@property (nonatomic, strong) NSNumber *farm;
@property (nonatomic, strong) NSString *title;

@property (nonatomic) BOOL isPublic;
@property (nonatomic) BOOL isFriend;
@property (nonatomic) BOOL isFamily;

@end


@implementation FlickrPhoto

#pragma mark - LifeCycle
+ (FlickrPhoto *)flickrPhotoFrom:(NSDictionary *)dictionary {
    FlickrPhoto *flickrObject = [[FlickrPhoto alloc] init];
    
    flickrObject.identifier = dictionary[identifierKey];
    flickrObject.owner = dictionary[ownerKey];
    flickrObject.secret = dictionary[secretKey];
    flickrObject.server = dictionary[serverKey];
    flickrObject.title = dictionary[titleKey];
    
    flickrObject.farm = (NSNumber *)dictionary[farmKey];
    flickrObject.isPublic = (BOOL)dictionary[isPublicKey];
    flickrObject.isFriend = (BOOL)dictionary[isFriendKey];
    flickrObject.isFamily = (BOOL)dictionary[isFamilyKey];

    return flickrObject;
}


#pragma mark - Intreface
- (NSString *)photoLink {
    return [NSString stringWithFormat:@"https://farm%@.static.flickr.com/%@/%@_%@.jpg", self.farm, self.server, self.identifier, self.secret];
}

@end

