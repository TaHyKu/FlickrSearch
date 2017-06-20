//
//  NetworkManager.h
//  FlickrSearch
//
//  Created by TaHyKu on 17.06.17.
//  Copyright © 2017 IvanoffApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

+ (NetworkManager *)sharedInstance;

- (void)searchFlickrImagesWith:(NSString *)text page:(NSInteger)page success:(void(^)(BOOL success, NSArray *photos))successBlock;

@end
