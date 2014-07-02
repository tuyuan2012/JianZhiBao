//
//  ImageViewController.h
//  DeeperOAForIphone
//
//  Created by 雷 克 on 12-2-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownloader.h"

@interface ImageViewController : UIViewController<ImageDownloaderDelegate,UIScrollViewDelegate>
{
    UIImageView *imageView;
    NSMutableArray *downloads;
    UIScrollView *zoomScrollView;
    
    NSString *topTitle;
    //BOOL ishiden;
}
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIScrollView *zoomScrollView;
@property (nonatomic, retain) NSString *topTitle;

- (id)initWithImageUrl:(NSString *)imageUrl andtoptittle:(NSString *)tittle;
- (void)showbacktoolbar;

@end
