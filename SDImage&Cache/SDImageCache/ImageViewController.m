//
//  ImageViewController.m
//  DeeperOAForIphone
//
//  Created by 雷 克 on 12-2-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ImageViewController.h"

@implementation ImageViewController

@synthesize imageView;
@synthesize zoomScrollView;
@synthesize topTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark http request waiting
-(void)removeWaiting
{
    UIView *bgView = (UIView *)[self.view viewWithTag:346];
    if (bgView)
    {
        [bgView removeFromSuperview];
    }
}

- (void)showWaiting
{
	[self removeWaiting];
	UIView *waitingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];// self.bounds];
	waitingView.backgroundColor = [UIColor clearColor];
	waitingView.userInteractionEnabled = NO;
	waitingView.alpha = 1.0;
	waitingView.tag = 346;
    [self.view addSubview:waitingView];
	[waitingView release];
    
    UIView *colorView = [[[UIView alloc] initWithFrame:waitingView.bounds] autorelease];
    colorView.alpha = 0.3;
    colorView.backgroundColor =[UIColor blackColor];
    [waitingView addSubview:colorView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(waitingView.center.x, waitingView.center.y, 320, 30)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setCenter:CGPointMake(waitingView.bounds.size.width /2.0, waitingView.bounds.size.height/2.0-10)];
    [label setTextAlignment:UITextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:17.0f]];
    [label setTextColor:[UIColor darkGrayColor]];
    [label setText:@"正在加载..."];
    [waitingView addSubview:label];
    [label release];
	
	UIActivityIndicatorView *active = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	active.center = CGPointMake(waitingView.bounds.size.width/2.0,waitingView.bounds.size.height/2.0-40);
	[waitingView addSubview:active];
	[active startAnimating];
	[active release];
}

- (id)initWithImageUrl:(NSString *)imageUrl andtoptittle:(NSString *)tittle
{
    self = [super init];
    if (self) {
        // Custom initialization
        NSURL *url = [NSURL URLWithString:imageUrl];
        if(url)
        {
            zoomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
            //zoomScrollView.userInteractionEnabled = YES;
            //zoomScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
            zoomScrollView.delegate = self;
            [self.view addSubview:zoomScrollView];
            zoomScrollView.backgroundColor = [UIColor clearColor];
            //zoomScrollView.multipleTouchEnabled = YES;
            zoomScrollView.minimumZoomScale = 1.0;
            zoomScrollView.maximumZoomScale = 5.0;
            zoomScrollView.contentSize = CGSizeMake(1024, 768);
            
            UIImageView *aImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
            //aImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
            //[aImageView setImageWithURL:url refreshCache:NO placeholderImage:nil];
            self.imageView = aImageView;
            [zoomScrollView addSubview:aImageView];
            [aImageView release];
            
            
            [self showWaiting];
            ImageDownloader *aDownloader = [[ImageDownloader alloc] init];
            aDownloader.delegate = self;
            [aDownloader setImageWithURL:url];
            
            self.topTitle = tittle;
            //ishiden = YES;
            
            [self showbacktoolbar];
        }
        
    }
    return self;
}

- (void)getImageBack:(UIImage *)image withImageDownloader:(ImageDownloader *)imageDownloader
{
    [self removeWaiting];
    if(image)
    {
        CGFloat rate = 768.0/1024.0;
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        if(height * rate >= width)
        {
            if(height > self.view.bounds.size.height)
            {
                width = self.view.bounds.size.height *(width/height);
                height = self.view.bounds.size.height;
            }

        }
        else
        {
            if(width > self.view.bounds.size.width)
            {
                height = self.view.bounds.size.width *(height/width);
                width = self.view.bounds.size.width;
            }
        }
        
        zoomScrollView.frame = self.view.bounds;
        zoomScrollView.center = self.view.center;
        self.imageView.frame = CGRectMake(0, 0, width, height);
        self.imageView.center = zoomScrollView.center;
    
        
        self.imageView.image = image;
        [imageDownloader release];
    }
   
    
}
- (void)dealloc
{
    [topTitle release];
    [imageView release];
    [zoomScrollView release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)showbacktoolbar
{
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    toolBar.tag = 1101;
	[toolBar setBarStyle:UIBarStyleBlack];
	toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:toolBar];
	////--Raik Add--
	UIImage *buttonImage = [UIImage imageNamed:@"返回.png"];
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 0, 53, 44);
	[button setImage:buttonImage forState:UIControlStateNormal];
	[button addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:button];	
	////--end--
	
	
	UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-300, 2, 600, 40)] autorelease];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	titleLabel.text = @"图片示例";
	titleLabel.textAlignment = UITextAlignmentCenter;
	[toolBar addSubview:titleLabel];
}

-(void)doBack
{
	//isCanceled = YES;
	//[self dismissModalViewControllerAnimated:YES];
	[self.navigationController popViewControllerAnimated:YES];
//	if(_searchPopover)
//	{
//		[_searchPopover dismissPopoverAnimated:NO];
//	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if (ishiden) 
//    {
//        UIView *toolview = [self.view viewWithTag:1101];
//        toolview.hidden = YES;
//    }
//    else
//    {
//        UIView *toolview = [self.view viewWithTag:1101];
//        toolview.hidden = NO;
//    }
//    
//    ishiden = !ishiden;
//}

#pragma mark-
#pragma mark- scrollView delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return zoomScrollView; 
}
//完成放大缩小时调用
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale; 
//{
//    zoomScrollView.center = self.view.center;
//    imageView.center = zoomScrollView.center;
//    
//    NSLog(@"scale between minimum and maximum. called after any 'bounce' animations");
//}// scale between minimum and maximum. called after any 'bounce' animations

@end
