//
//  JALoginViewController.h
//  JASidePanels
//
//  Created by admin on 14-3-1.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "JARegisterViewController.h"

@interface JALoginViewController : UIViewController <UITextFieldDelegate>
{
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) UITextField *username;
@property (strong, nonatomic) UITextField *password;
@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UIButton *registerButton;
@property (strong, nonatomic) NSNumber *frameSet;

@end
