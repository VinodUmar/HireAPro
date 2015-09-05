//
//  TPUploadImageViewController.m
//  TutorialBase
//
//  Created by Antonio MG on 7/4/12.
//  Copyright (c) 2012 AMG. All rights reserved.
//
/*
 Errors
 
 PFFile cannot be larger than 10485760 bytes
 
 */
#import "UploadImageViewController.h"

#import <Parse/Parse.h>

#import "Constants.h"

@interface UploadImageViewController ()

-(void)showErrorView:(NSString *)errorMsg;

@end

@implementation UploadImageViewController

@synthesize imgToUpload = _imgToUpload;
@synthesize username = _username;
@synthesize commentTextField = _commentTextField;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.imgToUpload = nil;
    self.username = nil;
    self.commentTextField = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark IB Actions

-(IBAction)selectPicturePressed:(id)sender
{
    
    NSLog(@"selectPicturePressed");
    //Open a UIImagePickerController to select the picture
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self.navigationController presentModalViewController:imgPicker animated:YES];
}

-(IBAction)sendPressed:(id)sender
{

    [self.commentTextField resignFirstResponder];
    
    //Disable the send button until we are ready
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    //Place the loading spinner
    UIActivityIndicatorView *loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

    [loadingSpinner setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)];
    [loadingSpinner startAnimating];
    
    [self.view addSubview:loadingSpinner];
    
    //Upload a new picture
    //
    /*
     UIImage *image = YourImageView.image;
     UIImage *tempImage = nil;
     CGSize targetSize = CGSizeMake(80,60);
     UIGraphicsBeginImageContext(targetSize);
     
     CGRect thumbnailRect = CGRectMake(0, 0, 0, 0);
     thumbnailRect.origin = CGPointMake(0.0,0.0);
     thumbnailRect.size.width  = targetSize.width;
     thumbnailRect.size.height = targetSize.height;
     
     [image drawInRect:thumbnailRect];
     
     tempImage = UIGraphicsGetImageFromCurrentImageContext();
     
     UIGraphicsEndImageContext();
     
     YourImageView.image = tempImage;
     */
    

    
    NSLog(@"MyImage width %f height %f size in bytes:%i",self.imgToUpload.image.size.width,self.imgToUpload.image.size.height,[UIImagePNGRepresentation(self.imgToUpload.image) length]);

    NSData *pictureData;
    if([UIImagePNGRepresentation(self.imgToUpload.image) length]> 10485760){

        UIImage *image = self.imgToUpload.image;
        UIImage *tempImage = nil;

        
        if (self.imgToUpload.image.size.width>self.imgToUpload.image.size.height) {
            int yy=0;
            int xx = self.imgToUpload.image.size.width/1000;
            
            yy=self.imgToUpload.image.size.height/xx;
            
            CGSize targetSize = CGSizeMake(1000,yy);
            UIGraphicsBeginImageContext(targetSize);
            
            CGRect thumbnailRect = CGRectMake(0, 0, 0, 0);
            thumbnailRect.origin = CGPointMake(0.0,0.0);
            thumbnailRect.size.width  = targetSize.width;
            thumbnailRect.size.height = targetSize.height;
            
            [image drawInRect:thumbnailRect];
            
            tempImage = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            
            pictureData = UIImagePNGRepresentation(tempImage);
        }else{
            int yy=0;
            int xx = self.imgToUpload.image.size.height/1000;
            
            yy=self.imgToUpload.image.size.width/xx;
            
            CGSize targetSize = CGSizeMake(yy,1000);
            UIGraphicsBeginImageContext(targetSize);
            
            CGRect thumbnailRect = CGRectMake(0, 0, 0, 0);
            thumbnailRect.origin = CGPointMake(0.0,0.0);
            thumbnailRect.size.width  = targetSize.width;
            thumbnailRect.size.height = targetSize.height;
            
            [image drawInRect:thumbnailRect];
            
            tempImage = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            
            pictureData = UIImagePNGRepresentation(tempImage);
        
        }

        
        NSLog(@"after resiing width %f height %f size in bytes:%i",tempImage.size.width,tempImage.size.height,[UIImagePNGRepresentation(tempImage) length]);
        
        
    }else{
        pictureData = UIImagePNGRepresentation(self.imgToUpload.image);
    }
    
    
    PFFile *file = [PFFile fileWithName:@"img" data:pictureData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded){
            //Add the image to the object, and add the comments, the user, and the geolocation (fake)
            PFObject *imageObject = [PFObject objectWithClassName:WALL_OBJECT];
            [imageObject setObject:file forKey:KEY_IMAGE];
            [imageObject setObject:[PFUser currentUser].username forKey:KEY_USER];
            [imageObject setObject:self.commentTextField.text forKey:KEY_COMMENT];
            
            PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:52 longitude:-4];
            [imageObject setObject:point forKey:KEY_GEOLOC];
            
            [imageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if (succeeded){
                    //Go back to the wall
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                    NSString *errorString = [[error userInfo] objectForKey:@"error"];
                    [self showErrorView:errorString];
                }
            }];
        }
        else{
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            [self showErrorView:errorString];
        }
        
        [loadingSpinner stopAnimating];
        [loadingSpinner removeFromSuperview];       
        
    } progressBlock:^(int percentDone) {
        
    }];
}

#pragma mark UIImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo 
{
    
    [picker dismissModalViewControllerAnimated:YES];
    
    //Place the image in the imageview
    self.imgToUpload.image = img;
}

#pragma mark Error View


-(void)showErrorView:(NSString *)errorMsg
{
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorAlertView show];
}


@end
