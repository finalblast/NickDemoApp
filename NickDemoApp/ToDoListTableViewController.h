//
//  ToDoListTableViewController.h
//  NickDemoApp
//
//  Created by Nam (Nick) N. HUYNH on 9/7/15.
//  Copyright (c) 2015 Nam (Nick) N. HUYNH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoItem.h"

@interface ToDoListTableViewController : UITableViewController

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;
@property NSMutableArray *sortedItems;

@end
