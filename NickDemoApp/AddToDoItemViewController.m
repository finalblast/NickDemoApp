//
//  AddToDoItemViewController.m
//  NickDemoApp
//
//  Created by Nam (Nick) N. HUYNH on 9/7/15.
//  Copyright (c) 2015 Nam (Nick) N. HUYNH. All rights reserved.
//

#import "AddToDoItemViewController.h"
#import "ToDoItem.h"

@interface AddToDoItemViewController ()

@property BOOL isTravel;

@end

@implementation AddToDoItemViewController

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    
    
    UISwitch *mSwitch = [[UISwitch alloc] init];
    mSwitch.frame = CGRectMake(0.0f, 0.0f, 150.0f, 25.0f);
    
    
    UISwitch *tSwitch = [[UISwitch alloc] init];
    tSwitch.frame = CGRectMake(0.0f, 0.0f, 150.0f, 25.0f);
    
    [tSwitch addTarget:self action:@selector(tSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Repeat";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        case 1:
            cell.textLabel.text = @"Travel";
            cell.accessoryView = tSwitch;
            break;
        
        case 2:
            cell.textLabel.text = @"Snooze";
            cell.accessoryView = mSwitch;
            break;
            
        default:
            break;
    }
    return cell;
    
}


- (void) tSwitchChanged:(id)sender {
    UISwitch* switchControl = sender;
    if (![switchControl isOn]) {
        self.searchBar.hidden = YES;
        _isTravel = NO;
    } else {
        self.searchBar.hidden = NO;
        _isTravel = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSDate *pickedDate = [self.datePicker date];
    
    if (sender != self.saveButton) {
        return;
    }
    
    if (self.textField.text.length > 0) {
        self.toDoItem = [[ToDoItem alloc] init];
        self.toDoItem.itemName = self.textField.text;
        self.toDoItem.creationDate = [self.datePicker date];
        self.toDoItem.completed = NO;
        self.toDoItem.isTravel = _isTravel;
        
        [self.textField resignFirstResponder];
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = pickedDate;
        localNotification.alertBody = self.textField.text;
        localNotification.alertAction = @"Notification";
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        UISwitch *mySwitch = (UISwitch *)[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] accessoryView];
        
        if (![mySwitch isOn]) {
            self.searchBar.hidden = YES;
        } else {
            self.searchBar.hidden = NO;
        }
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
    }
    
}

@end
