//
//  LoginViewController.h
//  TutorialBase
//
//  Created by Antonio MG on 6/23/12.
//  Copyright (c) 2012 AMG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate ,UITextViewDelegate, FBLoginViewDelegate>


@property (nonatomic, strong) IBOutlet UITextField *userTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) IBOutlet UIView *loginView;

-(IBAction)logInPressed:(id)sender;
@property (weak, nonatomic) IBOutlet FBLoginView *loginbtn;


-(void)toggleHiddenState:(BOOL)shouldHide;



@end
