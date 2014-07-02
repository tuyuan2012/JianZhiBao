//
//  JACenterCell.m
//  JASidePanels
//
//  Created by syy on 14-3-2.
//
//

#import "JACenterCell.h"
#import "SDImageCache.h"

@interface JACenterCell()

@property (nonatomic) UIImageView *tempImage;

@end

@implementation JACenterCell

@synthesize title;
@synthesize imageView;
@synthesize price;
@synthesize person;
@synthesize cornermark;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 初始化
        self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 60, 60)];
        self.imageView.backgroundColor = [UIColor clearColor];
        self.imageView.layer.cornerRadius = 20;//设置那个圆角的有多圆
        CALayer *l = [self.imageView layer];   //获取ImageView的层
        [l setMasksToBounds:YES];
        [l setCornerRadius:10.0];
        [self addSubview:self.imageView];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 200, 30)];
        self.title.font = [UIFont boldSystemFontOfSize:13.0f];
        self.title.backgroundColor = [UIColor clearColor];
        [self addSubview:self.title];
        
        self.price = [[UILabel alloc] initWithFrame:CGRectMake(100, 40, 200, 30)];
        self.price.font = [UIFont boldSystemFontOfSize:13.0f];
        self.price.backgroundColor = [UIColor clearColor];
        self.price.textColor = [UIColor redColor];
        [self addSubview:self.price];
        
        self.person = [[UILabel alloc] initWithFrame:CGRectMake(250, 0, 70, 20)];
        self.person.font = [UIFont boldSystemFontOfSize:10.0f];
        self.person.backgroundColor = [UIColor clearColor];
        self.person.textColor = [UIColor redColor];
        [self.person setTextAlignment:NSTextAlignmentRight];
        [self addSubview:self.person];
        
        self.cornermark=[[UIImageView alloc]initWithFrame:CGRectMake(300, 60, 20, 20)];
        [self.cornermark setBackgroundColor:[UIColor clearColor]];
        self.cornermark.layer.masksToBounds = YES;//设为NO去试试
        [self addSubview:self.cornermark];
        [self.cornermark setHidden:YES];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
