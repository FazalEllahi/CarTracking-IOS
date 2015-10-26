//
//  signUpViewCellType.m
//  uRecorder
//
//  Created by Fazal Ellahi on 18/03/2014.
//  Copyright (c) 2014 Fazal Ellahi. All rights reserved.
//

#import "signInViewController.h"
#import "ApiController.h"
#import "contactViewController.h"
#import "AppDelegate.h"
#import "CompanyInfoViewController.h"
#import "MBProgressHUD.h"

@implementation signInViewController


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

- (void)viewDidLoad
{
    [super viewDidLoad];

    emailTextField.text = @"TestUser";//@"pamatransport";
    passTextField.text = @"123456";//@"123456";
//
//    emailTextField.text = /*@"autogroup";*/@"fernandoTest";
//    passTextField.text = /*@"camilo123";*/@"123456kashif";
//    
    validtextFields=0;
    emailTextField.delegate = self;
    passTextField.delegate = self;
    
    [passSwitch addTarget:self action:@selector(passSwitchPressed:) forControlEvents:UIControlEventValueChanged];
    //    validtextFields=0;
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    savedLogins = [[NSMutableArray alloc ] initWithArray:[df objectForKey:@"savedLogins"]];
    
    // Do any additional setup after loading the view.
}
- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    [emailTextField resignFirstResponder];
    [passTextField resignFirstResponder];
    
}
-(void)DonButtonPressed:(id)selector
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)passSwitchPressed:(id)selector
{
    //[self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)contactButtonPressed:(id)sender
{
    contactViewController *contactView =
    [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]
     instantiateViewControllerWithIdentifier:@"contactViewController"];
    // signInViewController *signInView = [[signInViewController alloc] init];
    [self.navigationController pushViewController:contactView animated:YES];
}
-(IBAction)registerButtonPressed:(id)sender
{
    CompanyInfoViewController *contactView =
    [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]
     instantiateViewControllerWithIdentifier:@"CompanyInfoViewController"];
    // signInViewController *signInView = [[signInViewController alloc] init];
    [self.navigationController pushViewController:contactView animated:YES];

}
-(IBAction)LoginPressedSelector:(id)sender
{
    if (validtextFields<0)
    {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter the correct information with field '!'" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
        [alertview show];
    }
    else{
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[ApiController sharedManager] loginUserWithUserName:emailTextField.text andPassword:passTextField.text onLoginResponse:^(BOOL isloggedIn, NSData *responseResult) {
            if (isloggedIn) {
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
                if ([passSwitch isOn]) {
                    
                    BOOL isAlreadySaved = false;
                    
                    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
                    
                    NSMutableArray *array = [df objectForKey:@"savedLogins"];
                    
                    if ([array count] > 0) {
                        
                        for (NSDictionary *dict in array) {
                            
                            if ([[dict objectForKey:@"login"] isEqualToString:@""]) {
                                
                                isAlreadySaved = true;
                            }
                        }
                    }
                    if (!isAlreadySaved) {
                        
                        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:emailTextField.text,@"login",passTextField.text,@"password", nil];
                        [array addObject:dict];
                        
                        [df setObject:array forKey:@"savedLogins"];

                        [df synchronize];
                    }
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                                        
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
                
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseResult
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:nil];
                    
                    if ([[[json objectForKey:@"response"] objectForKey:@"code"] isEqualToString:@"4"]) {
                        
                        
                        [[[UIAlertView alloc] initWithTitle:@"Faild" message:[[json objectForKey:@"response"]  objectForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                    }
                   else if ([[[json objectForKey:@"response"] objectForKey:@"code"] isEqualToString:@"3"]) {
                        
                        
                        [[[UIAlertView alloc] initWithTitle:@"Faild" message:[[json objectForKey:@"response"]  objectForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                    }
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            }

        }];
    }
    
}
#pragma txtViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == emailTextField) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"login CONTAINS[cd] %@",
                                  emailTextField.text];
        if ([savedLogins count]) {
           
            NSArray *filteredArray = [savedLogins filteredArrayUsingPredicate:predicate];
            

        }

        [passTextField becomeFirstResponder];
    }
    else{
        [textField resignFirstResponder];
    }
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
