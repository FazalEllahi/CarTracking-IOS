//
//  registrationViewController.h
//  uRecorder
//
//  Created by Fazal Ellahi on 18/03/2014.
//  Copyright (c) 2014 Fazal Ellahi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "signInViewController.h"

@protocol RegisterationCompleted;

@interface registrationViewController : UIViewController<UITextFieldDelegate,LoginCompletedDelegate>{
    
    IBOutlet UITextField *nameTextField;
    IBOutlet UITextField *emailTextField;
    IBOutlet UITextField *passTextField;
    IBOutlet UIImageView *nameImageView;
    IBOutlet UIImageView *emailImageView;
    IBOutlet UIImageView *passImageView;
    IBOutlet UILabel *emailLabel;
    BOOL isRecorderSaveCalled;
}
-(IBAction)SignUpSelector:(id)sender;
-(IBAction)LoginPressedSelector:(id)sender;
-(IBAction)valueChanged:(id)sender;
-(IBAction)CustomeTextFielButtonPressed:(id)sender;

@property (nonatomic,assign) NSObject<RegisterationCompleted> *delegate;
@property (nonatomic,readwrite) BOOL isRecorderSaveCalled;

@end

@protocol RegisterationCompleted

- (void)registrationView:(registrationViewController*)registrationView DidRegisterUser:(BOOL)success;

- (void)registrationView:(registrationViewController*)registrationView DidRegisterUserAfterRecording:(BOOL)success;


@end
