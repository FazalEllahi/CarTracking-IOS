//
//  RootViewController.m
//  VehicleTracker
//
//  Created by Iftikhar on 13/09/2015.
//  Copyright (c) 2015 Fazal Ellahi. All rights reserved.
//

#import "RootViewController.h"
#import "ApiController.h"
#import "signInViewController.h"
#import "MonitorVehiclesController.h"
#import "SettingsViewController.h"
#import "MapViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"

@interface RootViewController ()<SignoutDelegate>{

    __weak IBOutlet UIButton *BottomTitle;
    __weak IBOutlet UILabel *titleLable;
}

@end

@implementation RootViewController

@synthesize lblCollection,btnCollection;

-(IBAction)backButtonPressed:(id)sender{
    
}
-(IBAction)SubButtonPressed:(id)sender{
    
}
-(void)showLoginViewController{
    
    if (![[ApiController sharedManager] isSessionAlive]) {
        
        signInViewController *signInView =
        [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]
         instantiateViewControllerWithIdentifier:@"signInViewController"];
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:signInView];
        [navController.navigationBar setHidden:YES];
        
        // signInViewController *signInView = [[signInViewController alloc] init];
        [self.navigationController presentViewController:navController animated:NO completion:nil];
    }
    else{
        [self.SpinnView setHidden:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    
    [self showLoginViewController];
    
    for (UIButton *btn in btnCollection) {
        [btn addTarget:self action:@selector(dashBoardItemDiDTaP:) forControlEvents:UIControlEventTouchUpInside];
    }
   
   
       // Do any additional setup after loading the view.
}
-(IBAction)dashBoardItemDiDTaP:(id)sender{
    
    switch ([sender tag]) {
        case 0:{
            MonitorVehiclesController *detailView =
            
            [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]
             instantiateViewControllerWithIdentifier:@"MonitorVehiclesController"];
            // signInViewController *signInView = [[signInViewController alloc] init];
            [self.navigationController pushViewController:detailView animated:YES];
            
        }
            break;
        case 1:{
            MapViewController *detailView =
            
            [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]
             instantiateViewControllerWithIdentifier:@"MapViewController"];
            // signInViewController *signInView = [[signInViewController alloc] init];
            [self.navigationController pushViewController:detailView animated:YES];
            
        }
            break;
        case 2:{
            MonitorVehiclesController *detailView =
            
            [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]
             instantiateViewControllerWithIdentifier:@"MonitorVehiclesController"];
            detailView.myString = @"Route Replay";
            [self.navigationController pushViewController:detailView animated:YES];
            
        }
            break;
            
        case 3:{
            DetailViewController *detailView =
            
            [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]
             instantiateViewControllerWithIdentifier:@"DetailViewController"];
            [self.navigationController pushViewController:detailView animated:YES];
            
        }
            break;
        case 4:{
            DetailViewController *detailView =
            
            [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]
             instantiateViewControllerWithIdentifier:@"DetailViewController"];
            [self.navigationController pushViewController:detailView animated:YES];
            
        }
            break;
        case 5:{
            DetailViewController *detailView =
            
            [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]
             instantiateViewControllerWithIdentifier:@"DetailViewController"];
            [self.navigationController pushViewController:detailView animated:YES];
            
        }
            break;
        case 6:{
            DetailViewController *detailView =
            
            [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]
             instantiateViewControllerWithIdentifier:@"DetailViewController"];
            [self.navigationController pushViewController:detailView animated:YES];
            
        }
            break;
        case 11:{
            [[ApiController sharedManager] prepareForLogout];
            [self showLoginViewController];
            
        }
            break;


            
        default:
        {
            SettingsViewController *detailView =            [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]
             instantiateViewControllerWithIdentifier:@"SettingsViewController"];
            detailView.adelegate = self;
            // signInViewController *signInView = [[signInViewController alloc] init];
            [self.navigationController pushViewController:detailView animated:YES];
            
        }
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    
    [[ApiController sharedManager] getAllLabels:@"dashboard" onLoginResponse:^(BOOL isloggedIn, NSData *responseResulr) {
        if (!isloggedIn) {
            return ;
        }
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseResulr
                                                             options:NSJSONReadingMutableContainers
                                                               error:&jsonError];
        
        NSDictionary *dict = [[json objectForKey:@"response"] objectForKey:@"data"];
        
        NSArray *allkeys = @[@"coreTracking",@"monitorVechiles",@"routeReplay",@"reports",@"alerts",@"poi",@"followUp",@"geoFencing",@"maintenance",@"signOut",@"pushNotification",@"setting"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            int i = 0;
            for (UILabel *lbl in lblCollection) {
                
                if([dict objectForKey:[allkeys objectAtIndex:i]])
                    [lbl setText:[dict objectForKey:[allkeys objectAtIndex:i]]];
                i++;
            }
            if([dict objectForKey:@"pageTitle"])
                [titleLable setText:[dict objectForKey:@"pageTitle"]];
            

        });
        
    }];
}
-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    if ([[ApiController sharedManager] isSessionAlive] && ![self.SpinnView isHidden]) {
        [self.SpinnView setHidden:YES];
    }
}
-(void)SettingsViewControler:(SettingsViewController*)SettingsView didSelectSignoutSelector:(BOOL)success{
    [[ApiController sharedManager] prepareForLogout];
    [self showLoginViewController];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SettingsView.navigationController popViewControllerAnimated:YES];
    });
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
