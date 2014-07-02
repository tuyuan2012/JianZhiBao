//
//  UIViewController+ExtendViewController.m
//  JASidePanels
//
//  Created by Tony on 14-6-30.
//
//

#import "UIViewController+ExtendViewController.h"

@implementation UIViewController (ExtendViewController)
- (void)showAlertWithInfo:(NSString *)str
{
    UILabel *alert = [[UILabel alloc]init];
    alert.bounds = CGRectMake(0, 0, 150, 30);
    alert.center = CGPointMake(kScreen_Width / 2, kScreen_Height - 200);
    alert.backgroundColor = [UIColor colorWithWhite:.2 alpha:.8];
    alert.text = str;
    alert.textColor = [UIColor whiteColor];
    alert.textAlignment = NSTextAlignmentCenter;
    alert.font = [UIFont systemFontOfSize:12];
    alert.alpha = 0.0;
    alert.layer.cornerRadius = 10.0;
    alert.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    alert.layer.shadowRadius = 10.0;
    alert.layer.shadowOpacity = 5;
    alert.clipsToBounds = YES;
    [self.view addSubview:alert];
    [UIView animateWithDuration:.5 animations:^{
        alert.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.5 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
            alert.alpha = 0.0;
        } completion:^(BOOL finished) {
            [alert removeFromSuperview];
        }];
    }];
}
@end
