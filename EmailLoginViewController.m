//
//  EmailLoginViewController.m
//  HireAPro
//
//  Created by Ruben Ramos on 8/11/15.
//  Copyright (c) 2015 Ruben Ramos. All rights reserved.
//

#import "EmailLoginViewController.h"
#import <Parse/Parse.h>

@interface EmailLoginViewController ()
{
    NSString * cUser ;
    NSString * cUserId ;

}
@end

@implementation EmailLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self txt_email]setDelegate:self];
    [[self txt_pass]setDelegate:self];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tgr setCancelsTouchesInView:NO];
    
    [self.view addGestureRecognizer:tgr];
    
    
}
- (void)dismissKeyboard {
    NSLog(@"dismissKeyboard");
    [self.view endEditing:TRUE];
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

- (IBAction)btn_login:(id)sender {
    
    [PFUser logInWithUsernameInBackground:self.txt_email.text password:self.txt_pass.text block:^(PFUser *user, NSError *error) {
        if (user) {
            //Open the wall
            
            // self.userTextField.text= [fbuser objectForKey:@"email"];
            cUser = self.txt_email.text;
            
            NSLog(@"logInWithUsernameInBackground %@   email:%@   ",user,self.txt_email.text);
            
            
            
            [self performSegueWithIdentifier:@"EmailLoginSuccesful" sender:self];
        } else {
            
            
            NSLog(@"Create USer %@",cUser);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Email/Password is incorrect"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];


        }
    }];
}




- (void) prepareForSegue: (UIStoryboardSegue *)segue sender:(id) sender{
    
    NSLog(@"prepareForSegue %@",segue.identifier);
    
    if ([segue.identifier isEqualToString:@"EmailLoginSuccesful"])
    {
        
        
        
        NSLog(@"cUser %@",cUser);
        
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        app.currentUser = cUser;
        app.loginWith = @"email";
        
        
        
    }
}

@end
