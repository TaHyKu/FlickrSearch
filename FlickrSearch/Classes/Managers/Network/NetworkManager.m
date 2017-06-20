//
//  NetworkManager.m
//  FlickrSearch
//
//  Created by TaHyKu on 17.06.17.
//  Copyright © 2017 IvanoffApps. All rights reserved.
//

#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import "FlickrPhoto.h"

static NSString *const baseLink = @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=b47e245ca5a92ced22c3e0cf86bbaa0c";
static NSString *const pageParam = @"&per_page=99&page=";
static NSString *const textParam = @"&format=json&nojsoncallback=1&safe_search=1&text=";

static NSString *const photosWrapperResponseKey = @"photos";
static NSString *const photosResponseKey        = @"photo";

@interface NetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end


@implementation NetworkManager

#pragma mark - LifeCycle
+ (NetworkManager *)sharedInstance {
    static NetworkManager *_networkManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _networkManager = [[self alloc] init];
        _networkManager.manager = [[AFHTTPSessionManager alloc] init];
    });

    return _networkManager;
}


#pragma mark - Interface
- (void)searchFlickrImagesWith:(NSString *)text page:(NSInteger)page success:(void(^)(BOOL success, NSArray *photos))successBlock {
    NSString *fullLink = [NSString stringWithFormat:@"%@%@%ld%@%@", baseLink, pageParam, (long)page, textParam, text];
  
    [self.manager GET:fullLink parameters:nil progress:^(NSProgress *_Nonnull downloadProgress) {
        NSLog(@"loading progress: %@", downloadProgress);
    } success:^(NSURLSessionDataTask *_Nonnull task, id  _Nullable responseObject) {
        if (!responseObject || ![responseObject isKindOfClass:[NSDictionary class]]) { successBlock(NO, nil); }
        
        NSDictionary *response = (NSDictionary *)responseObject;
        NSDictionary *photosWrapper = response[photosWrapperResponseKey];
        if (!photosWrapper || ![photosWrapper isKindOfClass:[NSDictionary class]]) { successBlock(NO, nil); }
        
        NSArray *photos = photosWrapper[photosResponseKey];
        if (!photos || ![photos isKindOfClass:[NSArray class]]) { successBlock(NO, nil); }
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSMutableArray *flickrPhotos = [NSMutableArray array];
            for (NSDictionary *photo in photos) {
                FlickrPhoto *flickrPhoto = [FlickrPhoto flickrPhotoFrom:photo];
                [flickrPhotos addObject:flickrPhoto];
            }
            dispatch_async(dispatch_get_main_queue(), ^(void){
                successBlock(YES, flickrPhotos);
            });
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        successBlock(NO, nil);
    }];
}

@end

