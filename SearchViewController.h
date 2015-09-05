//
//  SearchViewController.h
//  HireaPro
//
//  Created by Ruben Ramos on 7/10/15.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"


@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,FBLoginViewDelegate>


@property ( strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property ( strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, retain) NSMutableArray *searchResults;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)LogOut:(id)sender;



@end
