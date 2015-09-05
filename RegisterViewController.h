//
//  RegisterViewController.h
//  TutorialBase
//
//  Created by Antonio MG on 6/27/12.
//  Copyright (c) 2012 AMG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"




@interface RegisterViewController : UIViewController<UITextFieldDelegate ,UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UITextField *userRegisterTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordRegisterTextField;


- (IBAction)SaveBasicInfo:(id)sender;

//-(IBAction)signUpUserPressed:(id)sender;


@property (strong, nonatomic) IBOutlet UITextField *txt_street;
@property (strong, nonatomic) IBOutlet UITextField *txt_city;
@property (strong, nonatomic) IBOutlet UITextField *txt_state;
@property (strong, nonatomic) IBOutlet UITextField *txt_zip;
@property (strong, nonatomic) IBOutlet UITextField *txt_country;

@property (strong, nonatomic) IBOutlet UITextField *txt_phone;

@property (strong, nonatomic) IBOutlet UITextField *txt_email;

@property (strong, nonatomic) IBOutlet UITextField *txt_pass1;

@property (strong, nonatomic) IBOutlet UITextField *txt_pass2;

@end
