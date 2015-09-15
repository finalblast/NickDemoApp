//
//  ToDoItem.m
//  NickDemoApp
//
//  Created by Nam (Nick) N. HUYNH on 9/7/15.
//  Copyright (c) 2015 Nam (Nick) N. HUYNH. All rights reserved.
//

#import "ToDoItem.h"

@interface ToDoItem ()

@property NSDate *completionDate;

@end

@implementation ToDoItem


- (void)markAsCompleted:(BOOL)isCompleted {
    self.completed = @(isCompleted);
    [self setCompletionDate];
}

- (void)setCompletionDate {
    if (self.completed) {
        self.completionDate = [NSDate date];
    } else {
        self.completionDate = nil;
    }
}

- (NSComparisonResult)compareName:(ToDoItem *)otherObject {
    return [self.itemName compare:otherObject.itemName];
}


@end
