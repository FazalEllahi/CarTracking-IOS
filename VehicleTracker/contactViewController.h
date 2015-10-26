//
//  contactViewController.h
//  VehicleTracker
//
//  Created by Iftikhar on 15/09/2015.
//  Copyright (c) 2015 Fazal Ellahi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface contactViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic,retain)IBOutlet UITextField *nametxt;
@property (nonatomic,retain)IBOutlet UITextField *emailtxt;
@property (nonatomic,retain)IBOutlet UITextField *companytxt;
@property (nonatomic,retain)IBOutlet UITextField *subjtxt;
@property (nonatomic,retain)IBOutlet UITextView *messagetxt;

-(IBAction)backButtonPressed:(id)sender;
-(IBAction)SubButtonPressed:(id)sender;



@end
