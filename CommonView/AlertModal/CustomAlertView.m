//
//  CustomAlertView.m
//  JieXinIphone
//
//  Created by tony on 14-2-21.
//  Copyright (c) 2014年 sunboxsoft. All rights reserved.
//

#import "CustomAlertView.h"
#define GroupChartCreate 11111
#define SendMessage  22222

//背景颜色
#define kMAIN_BACKGROUND_COLOR [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]

#define kDarkerGray [UIColor colorWithRed:35.0/255.0 green:24.0/255.0 blue:20.0/255.0 alpha:1.0]

#define kDarkGray [UIColor colorWithRed:113.0/255.0 green:113.0/255.0 blue:113.0/255.0 alpha:1.0]

#define klighterGray [UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1.0]

#define klightGray [UIColor colorWithRed:76.0/255.0 green:73.0/255.0 blue:72.0/255.0 alpha:1.0]
#define kCommonFont  15.0f

#import "SDImageCache.h"
@implementation CustomAlertView
{
    UIImageView *_enlargView;
}
@synthesize delegate = _delegate;
@synthesize groupInfo;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithAlertStyle:(CustomAlertStyle)style withObject:(id)object
{
    self = [super init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShow:) name:KGModalWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didShow:) name:KGModalDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHide:) name:KGModalWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didHide:) name:KGModalDidHideNotification object:nil];
    
    if(self)
    {
        switch (style) {
            case Update_Style:
            {
                NSString *updateInfo = (NSString *)object;
                [self initUpdateAlertViewWithInfomation:updateInfo];
            }break;
            case MustUpdate_style:
            {
                NSString *updateInfo = (NSString *)object;
                [self initMustUpdateAlertViewWithInfomation:updateInfo];
            }break;
            case Update_NoStyl:
            {
                NSString *updateInfo = (NSString *)object;
                [self initNoUpdateAlertViewWithInfomation:updateInfo];
            }
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)dealloc
{
    self.groupInfo = nil;
    RELEASE_SAFELY(_enlargView);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

-(void)initUpdateAlertViewWithInfomation:(NSString *)info
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 250)];
    contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat margin = 15.0f;
    CGFloat labelHeigth = 45.0f;
    CGFloat textViewHeight = 130.0f;
    CGFloat buttonWidth = 120.0f;
    CGFloat buttonHeight = 45.0f;
    
    //背景
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, labelHeigth, CGRectGetWidth(contentView.frame), 1)];
    imageView.image = [UIImage imageNamed:@"line_green.png"];
    [contentView addSubview:imageView];
    [imageView release];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), CGRectGetWidth(contentView.frame), textViewHeight)];
    textView.editable = NO;
    NSString *msg = info;
    textView.text = msg;

    textView.textColor = kDarkerGray;
    textView.font =[UIFont systemFontOfSize:kCommonFont+2];
    [contentView addSubview:textView];
    [textView release];
    
//    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    selectBtn.frame = CGRectMake(5, CGRectGetMaxY(textView.frame), 20, 20);
//    [selectBtn setImage:[UIImage imageNamed:@"fuxuan_1.png"] forState:UIControlStateNormal];
//    [selectBtn setImage:[UIImage imageNamed:@"fuxuan_2.png"] forState:UIControlStateSelected];
//    [selectBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [contentView addSubview:selectBtn];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(textView.frame), 240, 20)];
//    label.text = @"以后不再提示";
//    label.textColor = kDarkerGray;
//    label.font = [UIFont systemFontOfSize:kCommonFont];
//    [contentView addSubview:label];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(textView.frame), CGRectGetWidth(contentView.frame), 1)];
    imageView2.image = [UIImage imageNamed:@"line_gray.png"];
    [contentView addSubview:imageView2];
    
    UIButton *updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    updateBtn.frame = CGRectMake(margin, CGRectGetMaxY(imageView2.frame)+margin, buttonWidth, buttonHeight);
    [updateBtn setImage:[UIImage imageNamed:@"shengji.png"] forState:UIControlStateNormal];
    [updateBtn addTarget:self action:@selector(update:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:updateBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(CGRectGetMaxX(updateBtn.frame)+margin, CGRectGetMaxY(imageView2.frame)+margin, buttonWidth, buttonHeight);
    [cancelBtn setImage:[UIImage imageNamed:@"shaohou.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelBtn];
    
    //标题
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, 120.0f, labelHeigth)];
    nameLabel.textColor = kMAIN_THEME_COLOR;
    nameLabel.font =[UIFont fontWithName:@"MicrosoftYaHei" size:kCommonFont + 4];
    nameLabel.text = @"兼职宝升级提醒";
    nameLabel.backgroundColor = [UIColor clearColor];
    [contentView addSubview:nameLabel];
    [nameLabel release];
    
    [[KGModal sharedInstance] setCloseButtonLocation:KGModalCloseButtonLocationRight];
    [[KGModal sharedInstance] setModalBackgroundColor:kMAIN_BACKGROUND_COLOR];
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
}

-(void)initNoUpdateAlertViewWithInfomation:(NSString *)info
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 200)];
    contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat margin = 15.0f;
    CGFloat labelHeigth = 45.0f;
    CGFloat textViewHeight = 130.0f;
    
    //背景
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, labelHeigth, CGRectGetWidth(contentView.frame), 1)];
    imageView.image = [UIImage imageNamed:@"line_green.png"];
    [contentView addSubview:imageView];
    [imageView release];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), CGRectGetWidth(contentView.frame), textViewHeight)];
    textView.editable = NO;
    NSString *msg = info;
    textView.text = msg;
    
    textView.textColor = kDarkerGray;
    textView.font =[UIFont systemFontOfSize:kCommonFont+2];
    [contentView addSubview:textView];
    [textView release];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(textView.frame), CGRectGetWidth(contentView.frame), 1)];
    imageView2.image = [UIImage imageNamed:@"line_gray.png"];
    [contentView addSubview:imageView2];
    
    //标题
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, 120.0f, labelHeigth)];
    nameLabel.textColor = kMAIN_THEME_COLOR;
    nameLabel.font =[UIFont fontWithName:@"MicrosoftYaHei" size:kCommonFont + 4];
    nameLabel.text = @"兼职宝升级提醒";
    nameLabel.backgroundColor = [UIColor clearColor];
    [contentView addSubview:nameLabel];
    [nameLabel release];
    
    [[KGModal sharedInstance] setCloseButtonLocation:KGModalCloseButtonLocationRight];
    [[KGModal sharedInstance] setModalBackgroundColor:kMAIN_BACKGROUND_COLOR];
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
}

-(void)initMustUpdateAlertViewWithInfomation:(NSString *)info
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 270)];
    contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat margin = 15.0f;
    CGFloat labelHeigth = 45.0f;
    CGFloat textViewHeight = 130.0f;
    CGFloat buttonWidth = 120.0f;
    CGFloat buttonHeight = 45.0f;
    
    //背景
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, labelHeigth, CGRectGetWidth(contentView.frame), 1)];
    imageView.image = [UIImage imageNamed:@"line_green.png"];
    [contentView addSubview:imageView];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), CGRectGetWidth(contentView.frame), textViewHeight)];
    textView.editable = NO;
    NSString *msg = info;
    textView.text = msg;
    
    textView.textColor = kDarkerGray;
    textView.font =[UIFont systemFontOfSize:kCommonFont+2];
    [contentView addSubview:textView];
    [textView release];
    
//    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    selectBtn.frame = CGRectMake(5, CGRectGetMaxY(textView.frame), 20, 20);
//    [selectBtn setImage:[UIImage imageNamed:@"fuxuan_1.png"] forState:UIControlStateNormal];
//    [selectBtn setImage:[UIImage imageNamed:@"fuxuan_2.png"] forState:UIControlStateSelected];
//    [selectBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [contentView addSubview:selectBtn];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(textView.frame), 240, 20)];
//    label.text = @"以后不再提示";
//    label.textColor = kDarkerGray;
//    label.font = [UIFont systemFontOfSize:kCommonFont];
//    [contentView addSubview:label];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(textView.frame)+1, CGRectGetWidth(contentView.frame), 1)];
    imageView2.image = [UIImage imageNamed:@"line_gray.png"];
    [contentView addSubview:imageView2];
    [imageView2 release];
    
    UIButton *updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    updateBtn.frame = CGRectMake(buttonWidth/2, CGRectGetMaxY(imageView2.frame)+margin, CGRectGetWidth(contentView.frame)/2, buttonHeight);
    [updateBtn setImage:[UIImage imageNamed:@"shengji.png"] forState:UIControlStateNormal];
    [updateBtn addTarget:self action:@selector(update:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:updateBtn];
    
//    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancelBtn.frame = CGRectMake(CGRectGetMaxX(updateBtn.frame)+margin, CGRectGetMaxY(imageView2.frame)+margin, buttonWidth, buttonHeight);
//    [cancelBtn setImage:[UIImage imageNamed:@"shaohou.png"] forState:UIControlStateNormal];
//    [cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [contentView addSubview:cancelBtn];
    
    //标题
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, 120.0f, labelHeigth)];
    nameLabel.textColor = kMAIN_THEME_COLOR;
    nameLabel.font =[UIFont fontWithName:@"MicrosoftYaHei" size:kCommonFont + 4];
    nameLabel.text = @"兼职宝强制升级提醒";
    nameLabel.backgroundColor = [UIColor clearColor];
    [contentView addSubview:nameLabel];
    [nameLabel release];
    
    
    [[KGModal sharedInstance] setCloseButtonLocation:KGModalCloseButtonLocationRight];
    [[KGModal sharedInstance] setModalBackgroundColor:kMAIN_BACKGROUND_COLOR];
    [[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
}


- (void)cancelBtn:(UIButton *)sender
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"KGModalGradientViewTapped" object:nil];
}

- (void)selectBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [self.delegate hintOrNotTransmission:sender.selected];
}

- (void)update:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KGModalGradientViewTapped" object:nil];
    [self.delegate update];
}

#pragma mark - notification method
- (void)willShow:(NSNotification *)notification{
    NSLog(@"will show");
}

- (void)didShow:(NSNotification *)notification{
    NSLog(@"did show");
}

- (void)willHide:(NSNotification *)notification{
    NSLog(@"will hide");
}

- (void)didHide:(NSNotification *)notification{
    NSLog(@"did Hide");
    self.tag = kAlertUnShowTag;
   // [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
