//
//  PopoverContentViewController.m
//  NickDemoApp
//
//  Created by Nam (Nick) N. HUYNH on 9/11/15.
//  Copyright (c) 2015 Nam (Nick) N. HUYNH. All rights reserved.
//

#import "PopoverContentViewController.h"
#import "ToDoListTableViewController.h"
#import "ToDoItem.h"

@interface PopoverContentViewController ()

@property (nonatomic, strong) UIButton *buttonName;
@property (nonatomic, strong) UIButton *buttonDate;
@property (nonatomic, strong) UIButton *buttonType;
@property (nonatomic, strong) UIButton *buttonClear;

@property NSInteger selectedItem;

@end

@implementation PopoverContentViewController

- (BOOL)isInPopover {
    Class popoverClass = NSClassFromString(@"UIPopoverController");
    
    if (popoverClass != nil && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && self.myPopoverController != nil) {
        return YES;
    } else {
        return NO;
    }
    
}

- (void)sortByName:(id)paramSender {
    if ([self isInPopover]) {
        /* Sort data list and then dismiss popover */
        
        self.selectedItem = 0;
        [self performSelectedItemPopover];
        [self.myPopoverController dismissPopoverAnimated:YES];
        
    } else {
        /* Handle case for iPhone */
    }
}

- (void)sortByDate:(id)paramSender {
    if ([self isInPopover]) {
        /* Sort data list and then dismiss popover */
        
        self.selectedItem = 1;
        [self performSelectedItemPopover];
        [self.myPopoverController dismissPopoverAnimated:YES];
        
    } else {
        /* Handle case for iPhone */
    }
}

- (void)sortByType:(id)paramSender {
    if ([self isInPopover]) {
        /* Sort data list and then dismiss popover */
        
        self.selectedItem = 2;
        [self performSelectedItemPopover];
        [self.myPopoverController dismissPopoverAnimated:YES];
        
    } else {
        /* Handle case for iPhone */
    }
}

- (void)clearClicked:(id)paramSender {
    if ([self isInPopover]) {
        /* Clear sorting */
        
        self.selectedItem = 3;
        [self performSelectedItemPopover];
        [self.myPopoverController dismissPopoverAnimated:YES];
        
    } else {
        /* Handle case for iPhone */
    }
}

- (void)performSelectedItemPopover {
    NSLog(@"%ld", (long)self.selectedItem);
    [self.delegate sortBySelectedFromPopover:self.selectedItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.preferredContentSize = CGSizeMake(200.0f, 225.0f);
    
    CGRect buttonRect = CGRectMake(20.0f, 20.0f, 160.0f, 37.0f);
    
    self.buttonName = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.buttonName setTitle:@"Name" forState:UIControlStateNormal];
    
    [self.buttonName addTarget:self action:@selector(sortByName:) forControlEvents:UIControlEventTouchUpInside];
    
    self.buttonName.frame = buttonRect;
    
    [self.view addSubview:self.buttonName];
    
    buttonRect.origin.y += 50.0f;
    
    self.buttonDate = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.buttonDate setTitle:@"Date" forState:UIControlStateNormal];
    
    [self.buttonDate addTarget:self action:@selector(sortByDate:) forControlEvents:UIControlEventTouchUpInside];
    
    self.buttonDate.frame = buttonRect;
    
    [self.view addSubview:self.buttonDate];
    
    buttonRect.origin.y += 50.0f;
    
    self.buttonType = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.buttonType setTitle:@"Type" forState:UIControlStateNormal];
    
    [self.buttonType addTarget:self action:@selector(sortByType:) forControlEvents:UIControlEventTouchUpInside];
    
    self.buttonType.frame = buttonRect;
    
    [self.view addSubview:self.buttonType];
    
    buttonRect.origin.y += 50.0f;
    
    self.buttonClear = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.buttonClear setTitle:@"Clear" forState:UIControlStateNormal];
    
    [self.buttonClear addTarget:self action:@selector(clearClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.buttonClear.frame = buttonRect;
    
    [self.view addSubview:self.buttonClear];
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
