//
//  EmailLoginViewController.h
//  HireAPro
//
//  Created by Ruben Ramos on 8/11/15.
//  Copyright (c) 2015 Ruben Ramos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface EmailLoginViewController : UIViewController <UITextFieldDelegate ,UITextViewDelegate>


@property (strong, nonatomic) IBOutlet UITextField *txt_email;

@property (strong, nonatomic) IBOutlet UITextField *txt_pass;

- (IBAction)btn_login:(id)sender;

@end
