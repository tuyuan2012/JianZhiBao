//
//  JABankInfoTableViewCell.h
//  JASidePanels
//
//  Created by Stan Zhang on 5/15/14.
//
//

#import <UIKit/UIKit.h>

@interface JABankInfoTableViewCell : UITableViewCell

@property (nonatomic) NSString *key;
@property (nonatomic) NSString *value;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;

@end
