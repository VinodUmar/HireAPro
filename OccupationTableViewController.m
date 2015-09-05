//
//  OccupationTableViewController.m
//  HireAPro
//
//  Created by Ruben Ramos on 7/30/15.
//  Copyright (c) 2015 Ruben Ramos. All rights reserved.
//

#import "OccupationTableViewController.h"
#import <Parse/Parse.h>
#import "Occupation.h"

@interface OccupationTableViewController ()
    @property (nonatomic, retain) NSArray *resutlArray;
@end

@implementation OccupationTableViewController

@synthesize searchResults;
@synthesize resutlArray = _resutlArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    searchResults = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Occupation"  ];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            self.resutlArray = nil;
            
            self.resutlArray = [[NSArray alloc] initWithArray:objects];
           
            for (PFObject *resutlObject in self.resutlArray){
                
                NSLog(@"Name ::: %@",[resutlObject objectForKey:@"Name"]);
                
                Occupation *occupation = [Occupation new];
                occupation.name = [resutlObject objectForKey:@"Name"];
                
                [searchResults addObject:occupation];
                
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"myRow";
    
    NSLog(@" cellForRowAtIndexPath %@",indexPath);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    Occupation *occupation = [searchResults objectAtIndex:indexPath.row];
    
    NSLog(@"Services :: %@",occupation.name);
    
    UILabel *iOccupation = (UILabel *)[cell viewWithTag:100];
    iOccupation.text = [NSString stringWithFormat:@"%@",occupation.name];
    
    
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Occupation *occupation = [searchResults objectAtIndex:indexPath.row];

    
    self.selectedRow = occupation.name;
    [self.delegate listWasSelected:self];

    
    
    
    
    
}

@end
