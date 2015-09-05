//
//  GuestSearchViewController.h
//  HireAPro
//
//  Created by Ruben Ramos on 7/27/15.
//  Copyright (c) 2015 Ruben Ramos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuestSearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
