//
//  AddToDoItemViewController.h
//  NickDemoApp
//
//  Created by Nam (Nick) N. HUYNH on 9/7/15.
//  Copyright (c) 2015 Nam (Nick) N. HUYNH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddToDoItemViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *textPlace;
@property (weak, nonatomic) IBOutlet UIView * searchView;

@end
