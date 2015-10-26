//
//  RoutReplyViewController.m
//  VehicleTracker
//
//  Created by Iftikhar on 30/09/2015.
//  Copyright (c) 2015 Fazal Ellahi. All rights reserved.
//

#import "RoutReplyViewController.h"
#import "RoutReplyHistoryVC.h"
#import "ApiController.h"
#import "AppDelegate.h"

@interface RoutReplyViewController ()

@end

@implementation RoutReplyViewController


@synthesize lbl;
@synthesize myDictionary;

-(IBAction)yestButtonPressed:(id)sender{
    RoutReplyHistoryVC *routHistory = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]
                                       instantiateViewControllerWithIdentifier:@"RoutReplyHistoryVC"];
    routHistory.dateselected = 1;
    routHistory.myDictionary = self.myDictionary;

    [self.navigationController pushViewController:routHistory animated:YES];
}
-(IBAction)todayButtonPressed:(id)sender{
    
    RoutReplyHistoryVC *routHistory = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]
                                       instantiateViewControllerWithIdentifier:@"RoutReplyHistoryVC"];
    routHistory.dateselected = 0;
    routHistory.myDictionary = self.myDictionary;
    [self.navigationController pushViewController:routHistory animated:YES];
}
-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//[{"TRACKER_GUID":8,"TrackerName":"testing2","NumberPlate":"testing2","Speed":0,"Latitute":"28.451810","Langtitute":"-81.408280","Mileage":"0.015000","Time":"01-09-2015 12:10:40 am","Engine":"Off","AlarmTitle":"Signal","Alert":0,"IMEI":"11111111111","deviceID":9}],

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Trip",@"Continue", nil];
    
    NSDictionary *dict = self.myDictionary;
    NSString *str = [NSString stringWithFormat:@"TrackerName \t%@\nNumberPlate %@\n Speed\t%@\n Mileage\t%@\n Time\t%@\n IMEI\t%@",[dict objectForKey:@"TrackerName"],[dict objectForKey:@"NumberPlate"],[dict objectForKey:@"Speed"],[dict objectForKey:@"Mileage"],[dict objectForKey:@"mobile"],[dict objectForKey:@"IMEI"]];
    NSLog(@"%@",str);
    [self.lbl setText: str];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    
    if (buttonIndex == 1) {
        [self rangeButtonPressed:nil];
    }
    else{
        [self rangeButtonPressed:nil];

    }
    
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

@end
