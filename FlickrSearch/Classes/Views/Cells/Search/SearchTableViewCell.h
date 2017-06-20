//
//  SearchTableViewCell.h
//  FlickrSearch
//
//  Created by TaHyKu on 16.06.17.
//  Copyright © 2017 IvanoffApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrPhoto.h"

@interface SearchTableViewCell : UITableViewCell

- (void)configureWith:(NSArray *)flickrPhotos;

@end
