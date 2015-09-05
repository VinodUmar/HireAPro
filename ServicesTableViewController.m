//
//  ServicesTableViewController.m
//  HireAPro
//
//  Created by Ruben Ramos on 7/29/15.
//  Copyright (c) 2015 Ruben Ramos. All rights reserved.
//

#import "ServicesTableViewController.h"
#import <Parse/Parse.h>
#import "Skills.h"

#import "OccupationTableViewController.h"

@interface ServicesTableViewController ()
    @property (nonatomic, retain) NSArray *resutlArray;

@end

@implementation ServicesTableViewController

@synthesize searchResults;
@synthesize resutlArray = _resutlArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    searchResults = [[NSMutableArray alloc] init];
    
    PFUser *currentUser = [PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Skills"  ];
    [query whereKey:@"UserId" equalTo:currentUser.objectId];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {

            self.resutlArray = nil;
            self.resutlArray = [[NSArray alloc] initWithArray:objects];
            
            for (PFObject *resutlObject in self.resutlArray){

                NSLog(@"UserId::: %@",[resutlObject objectForKey:@"UserId"]);
                
                Skills *skill = [Skills new];
                skill.objectId = [resutlObject objectForKey:@"objectId"];
                skill.userId = [resutlObject objectForKey:@"userId"];
                skill.services = [resutlObject objectForKey:@"Occupation"];

                [searchResults addObject:skill];
                
            }
            
            [self.tableView reloadData];
            
        } else {
            
            //Show the error
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            //[self showErrorView:errorString];
            NSLog(@" %@",errorString);
        }
    }];
    
    NSLog(@"%@",self.resutlArray);
    
    
    
}
- (void)viewDidUnload{
    searchResults = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"myRow";
    
    NSLog(@" cellForRowAtIndexPath %@",indexPath);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    Skills *skill = [searchResults objectAtIndex:indexPath.row];
    
    NSLog(@"Services :: %@",skill.services);
    
    UILabel *iServices = (UILabel *)[cell viewWithTag:100];
    iServices.text = [NSString stringWithFormat:@"%@",skill.services];

  
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@" %lu", (unsigned long)[searchResults count]);
    return [searchResults count];

}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    OccupationTableViewController *destViewController = (OccupationTableViewController*)segue.destinationViewController;
    
    destViewController.delegate = self;


}

- (void)listWasSelected:(OccupationTableViewController *)controller{
  
    PFUser *currentUser = [PFUser currentUser];
    
    [controller.navigationController popViewControllerAnimated:YES];
    NSLog(@"Value selected %@",controller.selectedRow);
    
    PFObject *saveObject = [PFObject objectWithClassName:@"Skills"];
    
    [saveObject setObject:currentUser.objectId forKey:@"UserId"];
    [saveObject setObject:controller.selectedRow forKey:@"Occupation"];
    
    [saveObject save];
    
    
    searchResults = [[NSMutableArray alloc] init];
    
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Skills"  ];
    [query whereKey:@"UserId" equalTo:currentUser.objectId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            self.resutlArray = nil;
            self.resutlArray = [[NSArray alloc] initWithArray:objects];
            
            for (PFObject *resutlObject in self.resutlArray){
                
                NSLog(@"UserId::: %@",[resutlObject objectForKey:@"UserId"]);
                
                Skills *skill = [Skills new];
                skill.objectId = [resutlObject objectForKey:@"objectId"];
                skill.userId = [resutlObject objectForKey:@"userId"];
                skill.services = [resutlObject objectForKey:@"Occupation"];
                
                [searchResults addObject:skill];
                
            }
            
            [self.tableView reloadData];
            
        } else {
            
            //Show the error
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            //[self showErrorView:errorString];
            NSLog(@" %@",errorString);
        }
    }];
    
    NSLog(@"%@",self.resutlArray);
    
    
    
}

@end
