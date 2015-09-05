//
//  LoginViewController.m
//  TutorialBase
//
//  Created by Antonio MG on 6/23/12.
//  Copyright (c) 2012 AMG. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "WallPicturesViewController.h"

#import <Parse/Parse.h>
@interface LoginViewController (){

    NSString * cUser ;
    NSString * cUserId ;
}
@end

@implementation LoginViewController

@synthesize userTextField = _userTextField, passwordTextField = _passwordTextField;




- (void)toggleHiddenState:(BOOL)shouldHide{
    NSLog(@"   toggleHiddenState ");

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
        NSLog(@"viewDidLoad");
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Delete me
//    self.userTextField.text = @"222";
  //  self.passwordTextField.text = @"222";
    cUser   = @"";
    cUserId = @"";
    
    
    [[self userTextField]setDelegate:self];
    [[self passwordTextField]setDelegate:self];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];

    self.loginbtn.readPermissions = @[@"public_profile", @"email"];

    
    self.loginbtn.delegate = self;
    
  //  [self toggleHiddenState:YES];
//    self.lblLoginStatus.text = @"";
    
}
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
   NSLog(@"You are logged in.");
    
    [self toggleHiddenState:NO];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
        NSLog(@"textFieldShouldReturn");
    if(textField.tag == 2 ){
        [textField resignFirstResponder];
        return YES;
    }
    else{
        //    return [textField resignFirstResponder];
        NSInteger nextTag = textField.tag + 1;
        // Try to find next responder
        
        UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
        if (nextResponder) {
            // Found next responder, so set it.
            [nextResponder becomeFirstResponder];
        } else {
            // Not found, so remove keyboard.
            [textField resignFirstResponder];
        }
        return NO; // We do not want UITextField to insert line-breaks.
    }
    
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)fbuser{
    NSLog(@"%@", fbuser);
   // self.profilePicture.profileID = user.id;
   // self.lblUsername.text = user.name;
   // self.lblEmail.text = [user objectForKey:@"email"];
    NSLog(@"Email  %@",[fbuser objectForKey:@"email"]);
    NSLog(@"NAme  %@",fbuser.name);
    
    [PFUser logInWithUsernameInBackground:[fbuser objectForKey:@"email"] password:[fbuser objectForKey:@"email"] block:^(PFUser *user, NSError *error) {
        if (user) {
            //Open the wall

            // self.userTextField.text= [fbuser objectForKey:@"email"];
            cUser = [fbuser objectForKey:@"email"];
            
            NSLog(@"logInWithUsernameInBackground %@   email:%@   textField:%@",user,[fbuser objectForKey:@"email"],cUser);
            

            
            [self performSegueWithIdentifier:@"LoginSuccesful" sender:self];
        } else {

            
            NSLog(@"Create USer %@",cUser);
            
            if ([cUser isEqual:@""]) {

                PFUser *user = [PFUser user];
                user.username = [fbuser objectForKey:@"email"];
                user.password = [fbuser objectForKey:@"email"];
                

                
 //                user.objectId
                NSLog(@"validate USer");
                [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        //The registration was succesful, go to the wall
                        //self.userTextField.text= [fbuser objectForKey:@"email"];
                        cUser = [fbuser objectForKey:@"email"];
                        [self performSegueWithIdentifier:@"LoginSuccesful" sender:self];
                        
                    } else {
                        //Something bad has ocurred
                        NSString *errorString = [[error userInfo] objectForKey:@"error"];
                        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [errorAlertView show];
                    }
                }];
            }
            

        
        }
    }];

    
    
}
-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
  //  self.lblLoginStatus.text = @"You are logged out";
    NSLog(@"You are logged out");
    
    [self toggleHiddenState:YES];
}
-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error{
    NSLog(@"handleError --- %@", [error localizedDescription]);
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textFieldDidEndEditing");

    [self.loginView setFrame:CGRectMake(self.loginView.frame.origin.x
                                        ,self.view.frame.size.height-465
                                        ,self.loginView.frame.size.width
                                        ,self.loginView.frame.size.height
                                        )];

    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing");
    
    if(textField.tag == 1 ){
        [self.loginView setFrame:CGRectMake(self.loginView.frame.origin.x
                                            ,self.view.frame.size.height-660
                                            ,self.loginView.frame.size.width
                                            ,self.loginView.frame.size.height
                                            )];

        
    }else{
        [self.loginView setFrame:CGRectMake(self.loginView.frame.origin.x
                                            ,self.view.frame.size.height-680
                                            ,self.loginView.frame.size.width
                                            ,self.loginView.frame.size.height
                                            )];

    }

    NSLog(@" tag: %ld",(long)textField.tag);

}
- (void)dismissKeyboard {
    NSLog(@"dismissKeyboard");
    [self.view endEditing:TRUE];
}
- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"viewWillAppear");
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    
    
    [self.loginView setFrame:CGRectMake(self.loginView.frame.origin.x,
                                        self.view.frame.size.height-465,self.loginView.frame.size.width,self.loginView.frame.size.height)];


}
- (void)viewDidUnload{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
//    self.userTextField = nil;
  //  self.passwordTextField = nil;
}


#pragma mark IB Actions

//Login button pressed
-(IBAction)logInPressed:(id)sender{
    /*
    [PFUser logInWithUsernameInBackground:self.userTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
        if (user) {
            //Open the wall
             [self performSegueWithIdentifier:@"LoginSuccesful" sender:self];
        } else {
            //Something bad has ocurred
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
     */
}
- (void) prepareForSegue: (UIStoryboardSegue *)segue sender:(id) sender{
    
    NSLog(@"prepareForSegue %@",segue.identifier);
    
    if ([segue.identifier isEqualToString:@"LoginSuccesful"])
    {
        
        

        NSLog(@"cUser %@",cUser);
        
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        app.currentUser = cUser;
        app.loginWith = @"facebook";
        
        
        
    }
}

@end
