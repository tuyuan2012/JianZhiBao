//
//  JAEditInfoTableViewController.m
//  JASidePanels
//
//  Created by Stan Zhang on 5/12/14.
//
//

#import "JAEditInfoTableViewController.h"
#import "JABasicInfoTableViewController.h"

@interface JAEditInfoTableViewController ()

@property (strong, nonatomic) IBOutlet UITableViewCell *c0;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation JAEditInfoTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *numberTypeKey = @[@"手机号", @"电话号码", @"qq号", @"年龄"];
    
    _textField.placeholder = self.prevText;
    _textField.text = self.prevText;
    
    if ([numberTypeKey containsObject:self.title]) {
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    } else {
        NSLog(@"Not Number!");
    }
    
    [_textField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (![_textField.text isEqualToString:_prevText]) {
        
        // Tell the parent ViewController to Refresh data
        __block __weak UIViewController *vc = nil;
        NSArray *viewControllers = [[self navigationController] viewControllers];
        if ([viewControllers count] > 1) {
            vc = viewControllers[[viewControllers count] - 1];
        }
        if (vc && [vc respondsToSelector:@selector(updateInfoForKey:value:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [vc performSelector:@selector(updateInfoForKey:value:) withObject:self.title withObject:_textField.text];
            });
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _c0;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

@end
