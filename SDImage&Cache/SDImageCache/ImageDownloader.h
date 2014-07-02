//
//  UIImage+WebCache.h
//  SunboxSoft
//
//  Created by 雷 克 on 12-1-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SDWebImageCompat.h"
#import "SDWebImageManagerDelegate.h"

@protocol ImageDownloaderDelegate;
@interface ImageDownloader:NSObject <SDWebImageManagerDelegate>
{
    int index;
    id <ImageDownloaderDelegate> delegate;
}
@property (nonatomic, assign) int index;
@property (nonatomic, assign) id <ImageDownloaderDelegate> delegate;

- (void)setImageWithURL:(NSURL *)url;
- (void)cancelCurrentImageLoad;

- (UIImage *)getImageFromCache:(NSURL *)url;
@end


@protocol ImageDownloaderDelegate <NSObject>

- (void)getImageBack:(UIImage *)image withImageDownloader:(ImageDownloader *)imageDownloader;

@end
