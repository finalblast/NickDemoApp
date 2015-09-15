//
//  PopoverContentViewController.h
//  NickDemoApp
//
//  Created by Nam (Nick) N. HUYNH on 9/11/15.
//  Copyright (c) 2015 Nam (Nick) N. HUYNH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopoverProtocol <NSObject>

- (void)sortBySelectedFromPopover:(NSInteger) selectedItem;

@end

@interface PopoverContentViewController : UIViewController

@property (nonatomic, weak) UIPopoverController *myPopoverController;
@property (nonatomic, weak) id<PopoverProtocol> delegate;
- (void) performSelectedItemPopover;

@end
