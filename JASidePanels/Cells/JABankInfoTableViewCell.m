//
//  JABankInfoTableViewCell.m
//  JASidePanels
//
//  Created by Stan Zhang on 5/15/14.
//
//

#import "JABankInfoTableViewCell.h"

@interface JABankInfoTableViewCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *keyLabel;

@end

@implementation JABankInfoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"GetQuestionsCustomCell" owner:self options:nil];
        self = [nibArray objectAtIndex:0];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
//    [_cellBg.layer setBorderWidth:1.0f];
//    [_cellBg.layer setBorderColor:[UIColor grayColor].CGColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setKey:(NSString *)key {
    _key = key;
    _keyLabel.text = key;
    if ([key isEqualToString:@"年龄"] || [key isEqualToString:@"手机号"] || [key isEqualToString:@"银行账号"] || [key isEqualToString:@"确认账号"]) {
        _valueTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    if (![key isEqualToString:@"确认账号"]) {
        _valueTextField.placeholder = [NSString stringWithFormat:@"请输入%@", key];
    }
    if ([key isEqualToString:@"账户类型"]) {
        _valueTextField.userInteractionEnabled = NO;
    }
}

- (void)setValue:(NSString *)value {
    _valueTextField.text = value;
}

- (NSString *)value {
    return _valueTextField.text;
}

@end
