//
//  JABillCell.m
//  JASidePanels
//
//  Created by syy on 14-3-4.
//
//

#import "JABillCell.h"

@implementation JABillCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(40, 8, 240, 20)];
        self.name.font = [UIFont boldSystemFontOfSize:12.0f];
        self.name.backgroundColor = [UIColor clearColor];
        self.name.textColor = [UIColor blackColor];
        [self.name setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.name];
        
        self.rank = [[UILabel alloc] initWithFrame:CGRectMake(13, 8, 50, 20)];
        self.rank.font = [UIFont boldSystemFontOfSize:12.0f];
        self.rank.backgroundColor = [UIColor clearColor];
        self.rank.textColor = [UIColor blackColor];
        [self.rank setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.rank];
        
        self.money = [[UILabel alloc] initWithFrame:CGRectMake(227, 8, 100, 20)];
        self.money.font = [UIFont boldSystemFontOfSize:12.0f];
        self.money.backgroundColor = [UIColor clearColor];
        self.money.textColor = [UIColor blackColor];
        [self.money setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.money];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
