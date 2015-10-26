//
//  LoginViewController.h
//  VehicleTracker
//
//  Created by Iftikhar on 05/09/2015.
//  Copyright (c) 2015 Fazal Ellahi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak,nonatomic) IBOutlet UITextField *userNametxt;
@property (weak,nonatomic) IBOutlet UITextField *passwortxt;

-(IBAction)loginButtonPressed:(id)sender;
-(IBAction)contactButtonPressed:(id)sender;
-(IBAction)registerButtonPressed:(id)sender;
-(IBAction)companyInfoButtonPressed:(id)sender;

@end
