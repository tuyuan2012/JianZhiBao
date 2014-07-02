//
//  JAPasswordChangeViewController.h
//  JASidePanels
//
//  Created by admin on 14-3-2.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface JAPasswordChangeViewController : UIViewController <UITextFieldDelegate>
{
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) UITextField *oldpassword;
@property (strong, nonatomic) UITextField *password;
@property (strong, nonatomic) UITextField *repeatpassword;
@property (strong, nonatomic) UIButton *submit;
@end
