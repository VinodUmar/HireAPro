//
//  ProfileViewController.m
//  HireAPro
//
//  Created by Ruben Ramos on 7/28/15.
//  Copyright (c) 2015 Ruben Ramos. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "Constants.h"
#import "Person.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize user;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSLog(@"viewDidLoad - wallPics - pass %@",    app.currentUser);
    
    user = app.currentUser;
    
    
    PFQuery *query3 = [PFUser query];
    [query3 whereKey:@"username" equalTo:user]; // find all the women

    NSArray *users = [query3 findObjects];
    Person *person = [Person new];
    
    for (PFUser *resutlUsers in users){
        NSLog(@"First name %@",[resutlUsers objectForKey:@"FirstName"]);

        person.userid = [resutlUsers objectForKey:@"ObjectId"];
        
        person.username = [resutlUsers objectForKey:@"username"];
        person.firstname = [resutlUsers objectForKey:@"FirstName"];
        person.email = [resutlUsers objectForKey:@"email"];
        person.lastname = [resutlUsers objectForKey:@"LastName"];
        person.address = [resutlUsers objectForKey:@"Address"];
        person.city = [resutlUsers objectForKey:@"City"];
        person.state = [resutlUsers objectForKey:@"State"];
        person.zip = [resutlUsers objectForKey:@"Zip"];
        person.country = [resutlUsers objectForKey:@"Country"];
        person.phone = [resutlUsers objectForKey:@"Phone"];
        person.website = [resutlUsers objectForKey:@"Website"];
        person.facebookid = [resutlUsers objectForKey:@"FacebookId"];
        person.profileid = [resutlUsers objectForKey:@"ProfileId"];
        person.profilestatus = [resutlUsers objectForKey:@"ProfileStatus"];
        person.status = [resutlUsers objectForKey:@"Status"];
        person.comments = [resutlUsers objectForKey:@"Comments"];
        //ProfPicture
        
    }

    
    self.txt_username.text = person.firstname;
    self.txt_address.text = person.address;
    self.txt_city.text = person.city;
    self.txt_state.text = person.state;
    self.txt_zip.text = person.zip;
    self.txt_country.text = person.country;
    self.txt_email.text = person.email;
    self.txt_phone.text = person.phone;
    

    [[self txt_username ]setDelegate:self];
    [[self txt_address ]setDelegate:self];
    [[self txt_city ]setDelegate:self];
    [[self txt_state ]setDelegate:self];
    [[self txt_zip ]setDelegate:self];
    [[self txt_country ]setDelegate:self];
    [[self txt_email ]setDelegate:self];
    [[self txt_phone ]setDelegate:self];
    
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    
    [self.view addGestureRecognizer:tgr];
    

    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.tag == 8 ){
        [textField resignFirstResponder];
        return YES;
    }
    else{

        NSInteger nextTag = textField.tag + 1;
        if (nextTag==8) {
            [self.txt_email becomeFirstResponder];
            
        }else{
            UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
            if (nextResponder) {
                // Found next responder, so set it.
                [nextResponder becomeFirstResponder];
            } else {
                // Not found, so remove keyboard.
                [textField resignFirstResponder];
            }
        }
        
        return NO; // We do not want UITextField to insert line-breaks.
    }
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"shouldChangeTextInRange");
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
        [self.scrollView setContentOffset:CGPointMake(0, -64) animated:YES];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    if(textField.tag == 1 ){
        [self.scrollView setContentOffset:CGPointMake(0, -70) animated:YES];
        
    }else if (textField.tag == 2){
        [self.scrollView setContentOffset:CGPointMake(0, -40) animated:YES];
    }else if (textField.tag == 3){
        [self.scrollView setContentOffset:CGPointMake(0, -10) animated:YES];
    }else if (textField.tag == 4){
        [self.scrollView setContentOffset:CGPointMake(0, 20) animated:YES];
    }else if (textField.tag == 5){
        [self.scrollView setContentOffset:CGPointMake(0, 50) animated:YES];
    }else if (textField.tag == 6){
        [self.scrollView setContentOffset:CGPointMake(0, 80) animated:YES];
    }else if (textField.tag == 7){
        [self.scrollView setContentOffset:CGPointMake(0, 110) animated:YES];
    }else if (textField.tag == 8){
        [self.scrollView setContentOffset:CGPointMake(0, 140) animated:YES];
        
    }
    
    
    
   
}

- (void)dismissKeyboard {
    [self.view endEditing:TRUE];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)Save:(id)sender {
    
//    PFQuery *query = [PFQuery queryWithClassName:@"UserStats"];
//    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:user]; // find all the women
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
        if (!error) {
            NSLog(@"Found UserStats");
            
            [userStats setObject:self.txt_username.text forKey:@"FirstName"];
            [userStats setObject:self.txt_address.text forKey:@"Address"];
            [userStats setObject:self.txt_city.text forKey:@"City"];
            [userStats setObject:self.txt_state.text forKey:@"State"];
            [userStats setObject:self.txt_zip.text forKey:@"Zip"];
            [userStats setObject:self.txt_country.text forKey:@"Country"];
            [userStats setObject:self.txt_phone.text forKey:@"Phone"];
            [userStats setObject:self.txt_email.text forKey:@"email"];

            
            // Save
            [userStats saveInBackground];
        } else {
            // Did not find any UserStats for the current user
            NSLog(@"Error: %@", error);
        }
    }];
    
}
@end
