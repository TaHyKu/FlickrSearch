//
//  SearchTableViewCell.m
//  FlickrSearch
//
//  Created by TaHyKu on 16.06.17.
//  Copyright © 2017 IvanoffApps. All rights reserved.
//

#import "SearchTableViewCell.h"
#import <SDImageCache.h>
#import <SDWebImageManager.h>

@interface SearchTableViewCell ()

@property(strong) IBOutletCollection(UIImageView) NSArray *imageViewsArray;
@property (strong) IBOutletCollection(UILabel) NSArray *labelsArray;

@end

@implementation SearchTableViewCell

#pragma mark - LifeCycle
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


#pragma mark - Interface
- (void)configureWith:(NSArray *)flickrPhotos {
    for (NSInteger i = 0; i < 3; i ++) {
        UIImageView *imageView = self.imageViewsArray[i];
        UILabel *label = self.labelsArray[i];
        if (flickrPhotos.count > i) {
            imageView.hidden = NO;
            label.hidden = NO;
            
            [self configureImageView:imageView with:flickrPhotos[i]];
            label.text = [(FlickrPhoto *)flickrPhotos[i] title];
        } else {
            imageView.hidden = YES;
            label.hidden = NO;
        }
    }
}


#pragma mark - Supprot
- (void)configureImageView:(UIImageView *)imageView with:(FlickrPhoto *)flickrPhoto {
    NSString *imageLink = [flickrPhoto photoLink];
    
    UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:imageLink];
    if (image == nil) {
        imageView.image = [UIImage imageNamed:@"placeholder"];
        
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imageLink]
                                                        options:SDWebImageHandleCookies | SDWebImageRetryFailed
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                           
                                                       } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                           if (error == nil) {
                                                               imageView.image = image;
                                                               [[SDImageCache sharedImageCache] storeImage:image forKey:imageLink];
                                                           }
                                                       }];
    } else {
        imageView.image = image;
    }
}

@end

