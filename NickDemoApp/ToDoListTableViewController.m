//
//  ToDoListTableViewController.m
//  NickDemoApp
//
//  Created by Nam (Nick) N. HUYNH on 9/7/15.
//  Copyright (c) 2015 Nam (Nick) N. HUYNH. All rights reserved.
//

#import "ToDoListTableViewController.h"
#import "ToDoItem.h"
#import "AddToDoItemViewController.h"
#import "SmileWeatherDownloader.h"
#import "ToDoItemDetailViewController.h"
#import <CoreData/CoreData.h>
#import "PopoverContentViewController.h"

@interface ToDoListTableViewController () <UIAlertViewDelegate, PopoverProtocol, UIPopoverControllerDelegate>

@property NSMutableArray *toDoItems;
@property ToDoItem *selectedItem;
@property (nonatomic, strong) UIPopoverController *myPopoverController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sortItem;


@end

@implementation ToDoListTableViewController

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

/* Do after storyboard segue finished and source controller dismissed */

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    self.sortedItems = [NSMutableArray new];
    [self loadInitialData];
}


/* Load initial data and update tableview */

- (void)loadInitialData {
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ToDoItem"];
    self.toDoItems = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.tableView reloadData];
    
}

/* Perform sort with alertview when user idiom is iphone */

- (void)performSortWithAlertView:(id) sender {
    
    // Showing alertview on iphone screen
    
    [[[UIAlertView alloc] initWithTitle:nil message:@"Sort..." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Name", @"Date", @"Type", @"Clear", nil] show];
}

/* Perform sort with popover when user idiom is ipad */

- (void)performSortWithPopover:(id) sender {
    
    // Initial popover from left barbuttonitem
    
    [self.myPopoverController presentPopoverFromBarButtonItem:self.sortItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


/*Override method on PopoverProtocol*/
- (void)sortBySelectedFromPopover:(NSInteger) selectedItem {
    
    switch (selectedItem) {
        case 0:
            [self sortByName];
            break;
        case 1:
            [self sortByDate];
            break;
        case 2:
            [self sortByType];
            break;
        case 3:
            self.sortedItems = [NSMutableArray new];
            [self.tableView reloadData];
            break;
        default:
            break;
    }
    
}

/*Sorting methods*/

- (void)sortByName {
    self.sortedItems = [[self.toDoItems sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *first = [(ToDoItem *)obj1 itemName];
        NSString *second = [(ToDoItem *)obj2 itemName];
        return [first compare:second];
    }] mutableCopy];
    
    [self.tableView reloadData];
}


- (void)sortByDate {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    self.sortedItems = [[self.toDoItems sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    [self.tableView reloadData];
}

- (void)sortByType {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"isTravel" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    self.sortedItems = [[self.toDoItems sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.toDoItems = [[NSMutableArray alloc] init];
    self.sortedItems = [[NSMutableArray alloc] init];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:
                                     [UIImage imageNamed:@"Background"]];
    [self loadInitialData];
    
    /* See if this class exists on the iOS running the app */
    
    Class popoverClass = NSClassFromString(@"UIPopoverController");
    
    if (popoverClass != nil && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        PopoverContentViewController *content = [[PopoverContentViewController alloc] initWithNibName:nil bundle:nil];
        
        self.myPopoverController = [[UIPopoverController alloc]
                                    initWithContentViewController:content];
        
        content.myPopoverController = self.myPopoverController;
        content.delegate = self;
        
        self.sortItem.target = self;
        self.sortItem.action = @selector(performSortWithPopover:);
    } else {
        self.sortItem.target = self;
        self.sortItem.action = @selector(performSortWithAlertView:);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Name"]) {
        // Sort by Name
        [self sortByName];
        
    } else if ([buttonTitle isEqualToString:@"Date"]) {
        // Sort by Date
        [self sortByDate];
        
    } else if ([buttonTitle isEqualToString:@"Type"]) {
        // Sort by Type
        [self sortByType];
        
    } else if ([buttonTitle isEqualToString:@"Clear"]) {
        // Clear sorting
        self.sortedItems = [NSMutableArray new];
        [self.tableView reloadData];
        
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.toDoItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell"];
    
    
    ToDoItem *todoItem = nil;
    
    if ([self.sortedItems count] > 0) {
        todoItem = [self.sortedItems objectAtIndex:indexPath.row];
    } else {
        todoItem = [self.toDoItems objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = todoItem.itemName;
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd/MMM/yyyy hh:mm a"];
    
    if ([todoItem.isTravel boolValue]) {
        cell.imageView.image = [UIImage imageNamed:@"Travel"];
        NSString *result = [NSString stringWithFormat:@"%@ to %@", [df stringFromDate:todoItem.creationDate], [SmileWeatherDownLoader placeNameForDisplay:todoItem.travelPlace]];
        cell.detailTextLabel.text = result;
    } else {
        cell.imageView.image = [UIImage imageNamed:@"Non-Travel"];
        NSString *result = [NSString stringWithFormat:@"%@", [df stringFromDate:todoItem.creationDate]];
        cell.detailTextLabel.text = result;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Checking if there is sorting data
    
    if ([self.sortedItems count] > 0) {
        _selectedItem = [self.sortedItems objectAtIndex:indexPath.row];
    } else {
        _selectedItem = [self.toDoItems objectAtIndex:indexPath.row];
    }

    if ([_selectedItem.isTravel boolValue]) {
        [self performSegueWithIdentifier:@"showDetails" sender:nil];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66.0f;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if there is sorting
    if ([self.sortedItems count] > 0) {
        return NO;
    } else {
        return YES;
    }
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the row from the database
        [context deleteObject:[self.toDoItems objectAtIndex:indexPath.row]];
        NSError *error = nil;
        
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
        }
        
        // Delete object from data array
        
        [self.toDoItems removeObjectAtIndex:indexPath.row];
        
        // Delete row on tableView
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"showDetails"]) {
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        ToDoItemDetailViewController *desView = (ToDoItemDetailViewController *)[navController topViewController];
        desView.itemToShow = _selectedItem;
    }
}

@end
