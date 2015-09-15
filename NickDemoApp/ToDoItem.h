//
//  ToDoItem.h
//  NickDemoApp
//
//  Created by Nam (Nick) N. HUYNH on 9/7/15.
//  Copyright (c) 2015 Nam (Nick) N. HUYNH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmileWeatherDownloader.h"

@interface ToDoItem : NSObject

@property NSString *itemName;
@property NSNumber *completed;
@property NSDate *creationDate;
@property NSNumber *isTravel;
@property CLPlacemark *travelPlace;

- (void)markAsCompleted:(BOOL)isCompleted;
- (NSComparisonResult)compareName:(ToDoItem *)otherObject;

@end
