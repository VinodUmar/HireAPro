//
//  SearchViewController.m
//  HireaPro
//
//  Created by Ruben Ramos on 7/10/15.
//
//

#import "SearchViewController.h"
#import <Parse/Parse.h>
#import "Constants.h"
#import "Person.h"
#import "LoginViewController.h"

@interface SearchViewController ()
@property (nonatomic, retain) NSArray *resutlArray;
@property (nonatomic, retain) NSArray *resutlArraySec;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) FBLoginView* loginView;

-(void)loadWallViews;
-(void)showErrorView:errorString;
@end



@implementation SearchViewController

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize fetchedResultsController = __fetchedResultsController;

@synthesize searchResults;
@synthesize activityIndicator = _loadingSpinner;


@synthesize resutlArray = _resutlArray;
-(void)showErrorView:(NSString *)errorMsg{
    
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorAlertView show];
}
-(void)loadWallViews{
    //Clean the scroll view

//    searchResults=self.resutlArray;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
    searchResults = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:SKILL_OBJECT  ];
    [query orderByDescending:KEY_CREATION_DATE];
            NSLog(@"1");
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            NSLog(@"2");
            self.resutlArray = nil;
            self.resutlArray = [[NSArray alloc] initWithArray:objects];

            //NSLog(@"objects :: %@",objects);
            
            for (PFObject *resutlObject in self.resutlArray){
                
                PFQuery *query3 = [PFUser query];
                [query3 whereKey:@"objectId" equalTo:[resutlObject objectForKey:@"UserId"]]; // find all the women
                NSArray *users = [query3 findObjects];

                for (PFUser *resutlUsers in users){
                    NSLog(@"First name %@",[resutlUsers objectForKey:@"FirstName"]);
                    Person *person = [Person new];
                    person.userid = [resutlUsers objectForKey:@"FirstName"];
                    
                    [searchResults addObject:person];
                }
                
                
            }
            
            

            
            [self.tableView reloadData];
            
            //Remove the activity indicator
            [self.activityIndicator stopAnimating];
            [self.activityIndicator removeFromSuperview];
            
            
        } else {
            //Remove the activity indicator
            [self.activityIndicator stopAnimating];
            [self.activityIndicator removeFromSuperview];
            
            //Show the error
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            [self showErrorView:errorString];
        }
    }];
    
    NSLog(@"3");
    NSLog(@"%@",self.resutlArray);
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    

    
    if ([app.loginWith isEqualToString:@"facebook"]) {
        self.loginView = [[FBLoginView alloc] init];
        self.loginView.frame = CGRectMake(-500, -500, 0, 0);
        [self.view addSubview:self.loginView];
        self.loginView.delegate = self;
        
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload{
    searchResults = nil;
    
}
#pragma mark - Fetching
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"myRow";
    
    NSLog(@" cellForRowAtIndexPath %@",indexPath);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    Person *person = [searchResults objectAtIndex:indexPath.row];
    
    cell.textLabel.text = person.userid ;
    
     //   cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
    
    return cell;
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"myRow";
    
    
    NSLog(@" cellForRowAtIndexPath %@",indexPath);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
        cell.textLabel.text =@"hoo";
    
    
    // Configure the cell...
    
    return cell;
}
 
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSLog(@" numberOfRowsInSection ");
    
//    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
    NSLog(@"%lu",(unsigned long)[searchResults count]);
    return [searchResults count];

    
}


- (IBAction)LogOut:(id)sender {

    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if ([app.loginWith isEqualToString:@"facebook"]) {
        for(id object in self.loginView.subviews){
            if([[object class] isSubclassOfClass:[UIButton class]]){
                UIButton* button = (UIButton*)object;
                [button sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }

    }else{
        [PFUser logOut];
        
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"main"
                                                             bundle:nil];
        LoginViewController *add = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        [self presentViewController:add
                           animated:YES
                         completion:nil];
        
    
    }
    
    NSLog(@"end code");
    
    
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    // see https://developers.facebook.com/docs/reference/api/errors/ for general guidance on error handling for Facebook API
    // our policy here is to let the login view handle errors, but to log the results
    NSLog(@"FBLoginView encountered an error=%@", error);
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    // test to see if we can use the share dialog built into the Facebook application
    /*
    FBLinkShareParams *p = [[FBLinkShareParams alloc] init];
    p.link = [NSURL URLWithString:@"http://developers.facebook.com/ios"];
    BOOL canShareFB = [FBDialogs canPresentShareDialogWithParams:p];
    BOOL canShareiOS6 = [FBDialogs canPresentOSIntegratedShareDialogWithSession:nil];
    BOOL canShareFBPhoto = [FBDialogs canPresentShareDialogWithPhotos];
    */
 
    
    NSLog(@"loginViewShowingLoggedOutUser");
    
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"main"
                                                         bundle:nil];
    LoginViewController *add = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    [self presentViewController:add
                       animated:YES
                     completion:nil];
    
}


@end
