//
//  ToDoItem.h
//  NickDemoApp
//
//  Created by Nam (Nick) N. HUYNH on 9/7/15.
//  Copyright (c) 2015 Nam (Nick) N. HUYNH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoItem : NSObject

@property NSString *itemName;
@property BOOL completed;
@property NSDate *creationDate;
@property BOOL isTravel;

- (void)markAsCompleted:(BOOL)isCompleted;

@end
