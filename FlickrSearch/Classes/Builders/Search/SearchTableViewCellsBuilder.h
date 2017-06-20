//
//  SearchTableViewCellsBuilder.h
//  FlickrSearch
//
//  Created by TaHyKu on 16.06.17.
//  Copyright © 2017 IvanoffApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SearchTableViewCell.h"

@interface SearchTableViewCellsBuilder : NSObject

@property (nonatomic, readonly) CGFloat cellHeight;

- (id)initWith:(UITableView *)tableView;

- (CGFloat)searchCellHeight;
- (CGFloat)autocompleteCellHeight;
- (SearchTableViewCell *)searchCellWith:(NSArray *)flickrPhotos;
- (UITableViewCell *)autocompleteCellWith:(NSString *)searchRequest boldLenght:(NSInteger)boldLength;

@end
