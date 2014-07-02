//
//  JALeftCell.m
//  JASidePanels
//
//  Created by syy on 14-3-2.
//
//

#import "JALeftCell.h"

@implementation JALeftCell

@synthesize title;
@synthesize image;
@synthesize allmark;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [UIColor grayColor];
        self.image=[[UIImageView alloc]initWithFrame:CGRectMake(8, 13, 16, 16)];
        self.image.backgroundColor = [UIColor clearColor];
        self.image.layer.cornerRadius = 10;//设置那个圆角的有多圆
        CALayer *l = [self.image layer];   //获取ImageView的层
        [l setMasksToBounds:YES];
        [l setCornerRadius:10.0];
        [self addSubview:self.image];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(33, 11, 100, 20)];
        self.title.font = [UIFont boldSystemFontOfSize:12.0f];
        self.title.backgroundColor = [UIColor clearColor];
         self.title.textColor = [UIColor whiteColor];
        [self addSubview:self.title];
        
        self.allmark = [[UILabel alloc] initWithFrame:CGRectMake(150, 11, 80, 20)];
        self.allmark.font = [UIFont boldSystemFontOfSize:12.0f];
        self.allmark.backgroundColor = [UIColor clearColor];
        self.allmark.textColor = [UIColor whiteColor];
        [self.allmark setTextAlignment:NSTextAlignmentRight];
        [self addSubview:self.allmark];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
