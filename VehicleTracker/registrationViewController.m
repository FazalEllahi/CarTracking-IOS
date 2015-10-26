//
//  registrationViewController.m
//  uRecorder
//
//  Created by Fazal Ellahi on 18/03/2014.
//  Copyright (c) 2014 Fazal Ellahi. All rights reserved.
//

#import "registrationViewController.h"
#import "signInViewController.h"
#import "AppDelegate.h"

@interface registrationViewController (){
    bool isSyncAllowed;
}

@end

@implementation registrationViewController

float yOrigionChanged = 1.0;
int validtextFields = 0;

@synthesize isRecorderSaveCalled;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
-(void)registerUser{
    if ([nameTextField.text length]< 4 || ![self NSStringIsValidEmail:emailTextField.text] || [passTextField.text length]< 4 ) {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter the correct information with field '!'" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alertview show];
    }
    else{
        
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                });
    }
}
-(IBAction)SignUpSelector:(id)sender{
    [self registerUser];
}
-(IBAction)LoginPressedSelector:(id)sender{
    signInViewController *signinView = [[signInViewController alloc]initWithNibName:@"signUpViewController" bundle:nil];
    signinView.delegate = self;
    [self.navigationController pushViewController:signinView animated:YES];
}
-(IBAction)valueChanged:(id)sender{
    
    isSyncAllowed = [sender isOn];
}
-(IBAction)CustomeTextFielButtonPressed:(id)sender{
    switch ([sender tag]) {
        case 0:{
            [nameTextField becomeFirstResponder];
        }
            break;
        case 1:{
            [emailTextField becomeFirstResponder];

        }
            break;
        case 2:{
            [passTextField becomeFirstResponder];

        }
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.title = @"SignUp";
    yOrigionChanged = 0;
    validtextFields=0;
    isSyncAllowed = YES;
    
    if ([UIScreen mainScreen].bounds.size.height <568) {
        
        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(DonButtonPressed:)];
        UIBarButtonItem *loginbutton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up" style:UIBarButtonItemStyleDone target:self action:@selector(LoginButtonPressed:)];
        self.navigationItem.leftBarButtonItem = anotherButton;
        self.navigationItem.rightBarButtonItem = loginbutton;

    }
    else{
        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(DonButtonPressed:)];
        self.navigationItem.rightBarButtonItem = anotherButton;
    }
}
-(void)LoginButtonPressed:(id)selector{
    [self registerUser];
}
-(void)DonButtonPressed:(id)selector{
    
   [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma txtViewDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == nameTextField) {
    }
    else if (textField == emailTextField && self.view.frame.origin.y>0) {
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             yOrigionChanged+=50;
                             self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-50, self.view.frame.size.width, self.view.frame.size.height);
                             //here you may add any othe actions, but notice, that ALL of them will do in SINGLE step. so, we setting ONLY xx coordinate to move it horizantly first.
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }
    else if (textField == passTextField && self.view.frame.origin.y>=0) {
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             yOrigionChanged+=100;
                             self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-100, self.view.frame.size.width, self.view.frame.size.height);
                             //here you may add any othe actions, but notice, that ALL of them will do in SINGLE step. so, we setting ONLY xx coordinate to move it horizantly first.
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }

}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == nameTextField) {
        if ([textField.text length]>= 4 ) {
            nameImageView.image = [UIImage imageNamed:@"checkmark.png"];
            validtextFields++;
        }
        else{
            nameImageView.image = [UIImage imageNamed:@"exclamationMark.png"];
            validtextFields-= validtextFields?1:0;
        }

    }
    else if (textField == emailTextField) {
        if ([self NSStringIsValidEmail:textField.text]) {
            emailImageView.image = [UIImage imageNamed:@"checkmark.png"];
            validtextFields++;
        }
        else{
            emailImageView.image = [UIImage imageNamed:@"exclamationMark.png"];
            validtextFields-= validtextFields?1:0;
        }
    }
    else{
        if ([textField.text length]< 4 ) {
            passImageView.image = [UIImage imageNamed:@"exclamationMark.png"];
            validtextFields-= validtextFields?1:0;

        }
        else{
            passImageView.image = [UIImage imageNamed:@"checkmark.png"];
            validtextFields++;
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == nameTextField) {
        [emailTextField becomeFirstResponder];
    }
    else if (textField == emailTextField) {
        [passTextField becomeFirstResponder];
    }
    else{
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+ yOrigionChanged, self.view.frame.size.width, self.view.frame.size.height);
                             yOrigionChanged=0;
                             //here you may add any othe actions, but notice, that ALL of them will do in SINGLE step. so, we setting ONLY xx coordinate to move it horizantly first.
                         }
                         completion:^(BOOL finished){
                             [textField resignFirstResponder];

                         }];


    }
    return YES;
}
#pragma signUpViewController delegate
- (void)loginView:(signInViewController*)loginView DidLoginUser:(BOOL)success{
//    [loginView.navigationController popViewControllerAnimated:YES];
    if (self.isRecorderSaveCalled) {
        [self.delegate registrationView:self DidRegisterUserAfterRecording:YES];

    }
    else{
        [self.delegate registrationView:self DidRegisterUserAfterRecording:NO];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
