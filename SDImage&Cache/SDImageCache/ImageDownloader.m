//
//  UIImage+WebCache.m
//  SunboxSoft
//
//  Created by 雷 克 on 12-1-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ImageDownloader.h"
#import "SDWebImageManager.h"

@implementation ImageDownloader
@synthesize index;
@synthesize delegate;

- (void)setImageWithURL:(NSURL *)url
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    if (url)
    {
        [manager downloadWithURL:url delegate:self];
    }
}

- (UIImage *)getImageFromCache:(NSURL *)url
{
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    UIImage *cachedImage = [manager imageWithURL:url];
    
    return cachedImage;

}

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    if ([delegate respondsToSelector:@selector(getImageBack:withImageDownloader:)])
    {
        [delegate getImageBack:image withImageDownloader:self];
    }
}

@end