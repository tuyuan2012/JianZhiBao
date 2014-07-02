//
//  JAAdvViewController.h
//  JASidePanels
//
//  Created by admin on 14-3-2.
//
//

#import <UIKit/UIKit.h>

@interface JAAdvViewController : UIViewController
@property (strong, nonatomic) UIWebView *webview;


- (id)initWithURL:(NSURL *)adURL;
- (void)addHTML:(NSString *)html;
@end
