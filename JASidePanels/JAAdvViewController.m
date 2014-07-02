//
//  JAAdvViewController.m
//  JASidePanels
//
//  Created by admin on 14-3-2.
//
//

#import "JAAdvViewController.h"

@interface JAAdvViewController ()

@end

@implementation JAAdvViewController
@synthesize webview;

- (id)initWithURL:(NSURL *)url
{
    if (self) {
        self.title = @"广告";
        // Do any additional setup after loading the view from its nib.
        self.webview = [[UIWebView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:self.webview];
    }
    return self;
}

- (void)addHTML:(NSString *)html
{
    [self.webview loadHTMLString:html baseURL:[[NSURL alloc] init]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.webview setFrame:self.view.bounds];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
