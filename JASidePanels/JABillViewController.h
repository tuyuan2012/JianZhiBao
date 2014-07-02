//
//  JABillViewController.h
//  JASidePanels
//
//  Created by syy on 14-3-4.
//
//

#import <UIKit/UIKit.h>
#import "JABillCell.h"


@interface JABillViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *merank;
}
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)NSMutableDictionary *mainListDic;
@end
