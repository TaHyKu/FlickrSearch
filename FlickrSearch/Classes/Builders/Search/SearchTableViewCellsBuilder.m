//
//  SearchTableViewCellsBuilder.m
//  FlickrSearch
//
//  Created by TaHyKu on 16.06.17.
//  Copyright © 2017 IvanoffApps. All rights reserved.
//

#import "SearchTableViewCellsBuilder.h"

static NSString *const searchReuseIdentifier = @"SearchTableViewCell";
static NSString *const autocompleteReuseIdentifier = @"AutocompleteTableVewCell";

@interface SearchTableViewCellsBuilder ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) CGFloat searchCellHeight;

@end


@implementation SearchTableViewCellsBuilder

#pragma mark - LifeCycle
- (id)initWith:(UITableView *)tableView {
    self = [super init];
    
    if (self != nil) {
        self.tableView = tableView;
        self.searchCellHeight = floor([UIScreen mainScreen].bounds.size.width / 3);
    }
    return self;
}


#pragma mark - Interface
- (CGFloat)searchCellHeight {
    if (_searchCellHeight == 0) {
        _searchCellHeight = floor([UIScreen mainScreen].bounds.size.width / 3);
    }
    
    return _searchCellHeight;
}

- (CGFloat)autocompleteCellHeight {
    return 44.0f;
}

- (SearchTableViewCell *)searchCellWith:(NSArray *)flickrPhotos {
    SearchTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:searchReuseIdentifier];
    [cell configureWith:flickrPhotos];
    
    return cell;
}

- (UITableViewCell *)autocompleteCellWith:(NSString *)searchRequest boldLenght:(NSInteger)boldLength {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:autocompleteReuseIdentifier];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:searchRequest];
    [string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17.0] range:NSMakeRange(0, boldLength)];
    cell.textLabel.attributedText = string;
    
    return cell;
}

@end


