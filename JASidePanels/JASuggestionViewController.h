//
//  JASuggestionViewController.h
//  JASidePanels
//
//  Created by admin on 14-3-2.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface JASuggestionViewController : UIViewController<UITextViewDelegate>
{
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) UITextField *name;
@property (strong, nonatomic) UITextField *email;
@property (strong, nonatomic) UITextField *textback;
@property (strong, nonatomic) UITextView *textview;
@property (strong, nonatomic) UIButton *submit;

@end
