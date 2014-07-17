/*
 Copyright (c) 2012 Jesse Andersen. All rights reserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 of the Software, and to permit persons to whom the Software is furnished to do
 so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 If you happen to meet one of the copyright holders in a bar you are obligated
 to buy them one pint of beer.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */


#import "JADebugViewController.h"
#import "JALeftCell.h"
#import "MBProgressHUD.h"
#import "JAMeController.h"
#import "JACenterViewController.h"
#import "JASidePanelController.h"
#import "JAMoneyViewController.h"
#import "JAHelpViewController.h"
#import "JACooperationViewController.h"
#import "JASuggestionViewController.h"
#import "JANewIntroViewController.h"
#import "JAPasswordChangeViewController.h"
@interface JALeftViewController : JADebugViewController<UITableViewDataSource,UITableViewDelegate>
{
    MBProgressHUD *HUD;
}

@property(nonatomic) int tabletag;
@property(strong,nonatomic)UITableView *leftView;
@property(strong,nonatomic)NSMutableDictionary *mainListDic;
@property(strong,nonatomic)NSMutableDictionary *incomeListDic;
@property(strong,nonatomic)NSMutableDictionary *CreditListDic;

@end
