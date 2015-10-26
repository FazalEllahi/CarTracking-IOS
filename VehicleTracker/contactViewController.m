//
//  contactViewController.m
//  VehicleTracker
//
//  Created by Iftikhar on 15/09/2015.
//  Copyright (c) 2015 Fazal Ellahi. All rights reserved.
//

#import "contactViewController.h"
#import "ApiController.h"

@interface contactViewController ()<UIGestureRecognizerDelegate>

@end

@implementation contactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
    
    // Do any additional setup after loading the view.
}
- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    [self.nametxt resignFirstResponder];
    [self.companytxt resignFirstResponder];
    [self.emailtxt resignFirstResponder];
    [self.subjtxt resignFirstResponder];
    [self.messagetxt resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.subjtxt) {
        
        [self.messagetxt becomeFirstResponder];
    }
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-150, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+150, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
    return YES;
}
-(IBAction)backButtonPressed:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)SubButtonPressed:(id)sender{
    
    [self.nametxt resignFirstResponder];
    [self.companytxt resignFirstResponder];
    [self.emailtxt resignFirstResponder];
    [self.subjtxt resignFirstResponder];
    [self.messagetxt resignFirstResponder];

    if ([self.nametxt.text length] > 0 && [self.companytxt.text length] > 0 && [self.emailtxt.text length] > 0 && [self.subjtxt.text length] > 0 && [self.messagetxt.text length] > 0) {
        
        [[ApiController sharedManager] submitContactData:self.nametxt.text Phone:self.companytxt.text Email:self.emailtxt.text Subject:self.subjtxt.text Message:self.messagetxt.text onLoginResponse:^(BOOL isloggedIn, NSData *responseResulr) {
            if (isloggedIn) {
                
                NSError *jsonError;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseResulr
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&jsonError];
                
                [[[UIAlertView alloc] initWithTitle:@"Submitted" message:[[json objectForKey:@"response"] objectForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                
                [self.nametxt setText:@""];
                [self.companytxt setText:@""];
                [self.emailtxt setText:@""];
                [self.subjtxt setText:@""];
                [self.messagetxt setText:@""];

                
            }
            else
                [[[UIAlertView alloc] initWithTitle:@"Faild" message:@"Unable to Submit Data.. "delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            
        }];
    }
    else{
        [[[UIAlertView alloc] initWithTitle:@"Missing Fields" message:@"All Fields are required to fill"delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
