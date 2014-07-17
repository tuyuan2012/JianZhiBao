//
//  JASlideSwitchDemoViewController.m
//  JASidePanels
//
//  Created by Stan Zhang on 5/8/14.
//
//

#import "JASlideSwitchDemoViewController.h"

@interface JASlideSwitchDemoViewController ()

@end

@implementation JASlideSwitchDemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] isEqualToString:@""]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"登录"] style:UIBarButtonItemStylePlain target:self action:@selector(loginIn)];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"登录"] style:UIBarButtonItemStylePlain target:self action:@selector(togglerightPanel)];
    }
    self.navigationController.navigationBar.translucent = NO;
    JALeftViewController *left = (JALeftViewController *)self.sidePanelController.leftPanel;
    JARightViewController *right = (JARightViewController *)self.sidePanelController.rightPanel;
    left.tabletag = 1;
    [left viewWillAppear:YES];
    [right viewWillAppear:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"所有工作";
    self.slideSwitchView.tabItemNormalColor = [SUNSlideSwitchView colorFromHexRGB:@"868686"];
    self.slideSwitchView.tabItemSelectedColor = [SUNSlideSwitchView colorFromHexRGB:@"bb0b15"];
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    
    
    self.vc1 = [[JACenterViewController alloc] initWithType:0];
    self.vc1.title = @"所有兼职";
    
    self.vc2 = [[JACenterViewController alloc] initWithType:1];
    self.vc2.title = @"所有全职";

    
    [self.slideSwitchView buildUI];
}

#pragma mark - 滑动tab视图代理方法

- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view
{
    return 2;
}

- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number == 0) {
        return self.vc1;
    } else if (number == 1) {
        return self.vc2;
    } else {
        return nil;
    }
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
{
    [self.sidePanelController _handlePan:panParam];
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view panRightEdge:(UIPanGestureRecognizer *)panParam
{
    [self.sidePanelController _handlePan:panParam];
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    JACenterViewController *vc = nil;
    if (number == 0) {
        vc = self.vc1;
    } else if (number == 1) {
        vc = self.vc2;
    }
    
    [view setNeedsLayout];
}

#pragma mark - Helper Functions

- (void)togglerightPanel{
    [self.sidePanelController toggleRightPanel];
}

- (void)loginIn{
    JALoginViewController * nextpage=[[JALoginViewController alloc]init];
    [self.navigationController pushViewController:nextpage animated:YES];
}

#pragma mark - 内存报警

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
