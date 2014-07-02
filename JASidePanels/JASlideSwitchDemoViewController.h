//
//  SUNSlideSwitchDemoViewController.h
//  SUNCommonComponent
//
//  Created by 麦志泉 on 13-9-4.
//  Copyright (c) 2013年 中山市新联医疗科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUNSlideSwitchView.h"
#import "JACenterViewController.h"

@interface JASlideSwitchDemoViewController : UIViewController<SUNSlideSwitchViewDelegate>
{
    SUNSlideSwitchView *_slideSwitchView;
    JACenterViewController *_vc1;
    JACenterViewController *_vc2;
}

@property (nonatomic, strong) IBOutlet SUNSlideSwitchView *slideSwitchView;

@property (nonatomic, strong) JACenterViewController *vc1;
@property (nonatomic, strong) JACenterViewController *vc2;
@end
