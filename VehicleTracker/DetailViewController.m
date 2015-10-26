//
//  DetailViewController.m
//  VehicleTracker
//
//  Created by Iftikhar on 14/09/2015.
//  Copyright (c) 2015 Fazal Ellahi. All rights reserved.
//

#import "DetailViewController.h"
#import "MBProgressHUD.h"
#import "ApiController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize myDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[ApiController sharedManager] getAllVehivlesData:[ApiController sharedManager].userID onLoginResponse:^(BOOL isloggedIn, NSData *responseResulr) {
        
        if (isloggedIn) {
            
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseResulr
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            NSLog(@" data = %@",[json objectForKey:@"response"]);
        }
    }];
    if([myDict allKeys].count >0){
//        "TrackerName":"testing2","NumberPlate":"testing2","Speed":0,"Latitute":"28.451810","Langtitute":"-81.408280","Mileage":"0.015000","Time":"01-09-2015 12:10:40 am","Engine":"Off","AlarmTitle":"Signal","Alert":0,"IMEI":"11111111111","deviceID":9
        
        
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" TrackerName: \t %@\n NumberPlate\t%@\n Speed\t%@\n Mileage\t%@\n Engine\t%@\n website\t%@",[myDict objectForKey:@"TrackerName"],[myDict objectForKey:@"NumberPlate"],[myDict objectForKey:@"Speed"],[myDict objectForKey:@"Mileage"],[myDict objectForKey:@"Engine"],[myDict objectForKey:@"AlarmTitle"]] attributes:nil];
        NSLog(@"%@",str);
        [self.detailLabel setAttributedText: str];
        [self.detailLabel setTextColor:[UIColor whiteColor]];


        
    }
}
- (IBAction)backButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)refreshButtonPressed:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

@end
