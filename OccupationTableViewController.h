//
//  OccupationTableViewController.h
//  HireAPro
//
//  Created by Ruben Ramos on 7/30/15.
//  Copyright (c) 2015 Ruben Ramos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@class OccupationTableViewController;

@protocol OccupationTableViewControllerDelegate
- (void)listWasSelected:(OccupationTableViewController *)controller;
@end


@interface OccupationTableViewController : UITableViewController

    @property (nonatomic, weak) id  delegate;
    @property (strong, nonatomic) NSString *selectedRow;
    @property (nonatomic, retain) NSMutableArray *searchResults;
@end
