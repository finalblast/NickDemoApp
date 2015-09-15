//
//  AddToDoItemViewController.m
//  NickDemoApp
//
//  Created by Nam (Nick) N. HUYNH on 9/7/15.
//  Copyright (c) 2015 Nam (Nick) N. HUYNH. All rights reserved.
//

#import "AddToDoItemViewController.h"
#import "SearchTableViewController.h"
#import "SmileWeatherDownLoader.h"
#import <CoreData/CoreData.h>
#import "ToDoListTableViewController.h"

@interface AddToDoItemViewController () <UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate>

@property BOOL isTravel;
@property BOOL isSnooze;

@property (nonatomic, strong) SearchTableViewController *searchTableVC;
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, weak) CLPlacemark *place;

@end

@implementation AddToDoItemViewController

#define IS_OS_7    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
static NSString * const reuseIdentifier = @"searchCell";
static NSString * const searchTableIdentifier = @"SearchTable";

# pragma TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_searchTableVC.tableView]) {
        if (self.searchResults) {
            return self.searchResults.count;
        } else {
            return 0;
        }
        
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if ([tableView isEqual:_searchTableVC.tableView]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        if (self.searchResults.count > 0) {
            CLPlacemark *placemark = self.searchResults[indexPath.row];
            cell.textLabel.text = [SmileWeatherDownLoader placeNameForSearchDisplay:placemark];
        } else {
            cell.textLabel.text = @"";
        }
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
        
        
        UISwitch *sSwitch = [[UISwitch alloc] init];
        sSwitch.frame = CGRectMake(0.0f, 0.0f, 150.0f, 25.0f);
        [sSwitch addTarget:self action:@selector(sSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        
        UISwitch *tSwitch = [[UISwitch alloc] init];
        tSwitch.frame = CGRectMake(0.0f, 0.0f, 150.0f, 25.0f);
        
        [tSwitch addTarget:self action:@selector(tSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        
        switch (indexPath.row) {
                
            case 0:
                cell.textLabel.text = @"Travel";
                cell.accessoryView = tSwitch;
                break;
                
            case 1:
                cell.textLabel.text = @"Snooze";
                cell.accessoryView = sSwitch;
                break;
                
            default:
                break;
        }
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ([tableView isEqual:_searchTableVC.tableView]) {
        
        CLPlacemark *placeMark = self.searchResults[indexPath.row];
        _place = placeMark;
        self.textPlace.text = [SmileWeatherDownLoader placeNameForSearchDisplay:placeMark];
        self.searchController.active = NO;
        
    }
    
}

/* Switch change when the TO-DO task is travel */

- (void)tSwitchChanged:(id)sender {
    UISwitch* switchControl = sender;
    if (![switchControl isOn]) {
        self.textPlace.hidden = YES;
        _isTravel = NO;
        _place = nil;
        NSArray *viewsToRemove = [self.searchView subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
        
    } else {
        self.textPlace.hidden = NO;
        [self.textPlace setEnabled:NO];
        _isTravel = YES;
        if (!IS_OS_7) {
            [self configureSearchControllerAndSearchResultsController];
        }
    }
}

/* Switch change when user want to snooze */

- (void)sSwitchChanged:(id)sender {
    UISwitch* switchControl = sender;
    if ([switchControl isOn]) {
        _isSnooze = YES;
    } else {
        _isSnooze = NO;
    }
}

/* Tap Gesture On Screen Clicked */

- (IBAction)tapGestureClicked:(id)sender {
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

/* Search Controller config for iOS 8.0 and later */

- (void)configureSearchControllerAndSearchResultsController {
    
    self.searchTableVC = [self.storyboard instantiateViewControllerWithIdentifier:searchTableIdentifier];
    self.searchTableVC.tableView.delegate = self;
    self.searchTableVC.tableView.dataSource = self;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchTableVC];
    self.searchController.searchResultsUpdater = self;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    [self.searchView addSubview:_searchController.searchBar];
    
    [_searchController.searchBar sizeToFit];
    
    self.definesPresentationContext = true;
    
}


#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = searchController.searchBar.text;
    [[SmileWeatherDownLoader sharedDownloader] getPlacemarksForSearchDisplayFromString:searchString completion:^(NSArray *placeMarks, NSError *error) {
        self.searchResults = placeMarks;
        [self.searchTableVC.tableView reloadData];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma CoreData

- (NSManagedObjectContext *)manageObjectContext {
    NSManagedObjectContext *context = nil;
    
    id delegate = [[UIApplication sharedApplication] delegate];
    
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    
    return context;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSDate *pickedDate = [self.datePicker date];
    
    if (sender != self.saveButton) {
        return;
    }
    
    if (self.textField.text.length > 0) {
        
        NSManagedObjectContext *context = [self manageObjectContext];
        NSManagedObject *newToDoItem = [NSEntityDescription insertNewObjectForEntityForName:@"ToDoItem" inManagedObjectContext:context];
        [newToDoItem setValue:self.textField.text forKey:@"itemName"];
        [newToDoItem setValue:[self.datePicker date] forKey:@"creationDate"];
        [newToDoItem setValue:@(NO) forKey:@"completed"];
        [newToDoItem setValue:@(_isTravel) forKey:@"isTravel"];
        [newToDoItem setValue:_place forKey:@"travelPlace"];
        
        NSError *error = nil;
        
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        
        [self.textField resignFirstResponder];
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = pickedDate;
        localNotification.alertBody = self.textField.text;
        localNotification.alertAction = @"Notification";
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        if (_isSnooze) {
            localNotification.repeatInterval = NSCalendarUnitHour;
        }
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
    }
    
}

@end
