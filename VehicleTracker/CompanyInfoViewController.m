//
//  ViewController.m
//  LASharekitExample
//
//  Created by Luis Ascorbe on 12/11/12.
//  Copyright (c) 2012 Luis Ascorbe. All rights reserved.
//

#import "CompanyInfoViewController.h"
#import "ApiController.h"
#import "AppDelegate.h"

#define PINTEREST_IMAGE_URL         @"https://raw.github.com/Lascorbe/LASharekit/master/captura.png"

@interface CompanyInfoViewController ()

@end

@implementation CompanyInfoViewController

@synthesize lbl;

-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//{"appTitle":"Althuraya","info":"Althuraya provides the best tracking devices and software solutions that enable customers to improve productivity by enabling the effective management of a fleet of cars all over the world. We also provide the best e-solutions for personal safety and internal security.\r\nWe have a team with a high level of expertise in wired and wireless (GPS \/ RF) devices and digital data for the allocation of these experiences and we put them together with the advanced technology to get the best performance for the provision of all your needs.","phone":"+971 41122555","email":"info@althuraya-usa.com","mobile":"971564743831","website":"www.dowalthuraya.com"}}}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[ApiController sharedManager] getCompanyInfoData:@"lables" onLoginResponse:^(BOOL isloggedIn, NSData *responseResulr) {
        if (!isloggedIn) {
            return ;
        }
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseResulr
                                                             options:NSJSONReadingMutableContainers
                                                               error:&jsonError];
        
        NSDictionary *dict = [[json objectForKey:@"response"] objectForKey:@"data"];
        
        NSString *str = [NSString stringWithFormat:@"\t\t\t\t%@\n\n\n\n%@\n phone\t%@\n email\t%@\n mobile\t%@\n website\t%@",[dict objectForKey:@"appTitle"],[dict objectForKey:@"info"],[dict objectForKey:@"phone"],[dict objectForKey:@"email"],[dict objectForKey:@"mobile"],[dict objectForKey:@"website"]];
        NSLog(@"%@",str);
        [self.lbl setText: str];
        
    }];
}
-(void)DonButtonPressed:(id)selector{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
