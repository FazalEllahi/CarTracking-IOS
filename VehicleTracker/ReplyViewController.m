//
//  RoutReplyViewController.m
//  VehicleTracker
//
//  Created by Iftikhar on 30/09/2015.
//  Copyright (c) 2015 Fazal Ellahi. All rights reserved.
//

#import "ReplyViewController.h"
#import "RoutReplyHistoryVC.h"
#import "IQActionSheetPickerView.h"
#import "ApiController.h"
#import "AppDelegate.h"
#import "TripViewController.h"

@interface ReplyViewController ()<IQActionSheetPickerViewDelegate>{
    
    int rangeSelector;
    NSString *fromDate;
    NSString *toDate;

    __weak IBOutlet UIButton *tripBtn;
    __weak IBOutlet UIButton *continousBtn;
}

@end

@implementation ReplyViewController


@synthesize myDictionary;

-(void)showTodayHistory{
    RoutReplyHistoryVC *routHistory = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]
                                       instantiateViewControllerWithIdentifier:@"RoutReplyHistoryVC"];
    routHistory.dateselected = 1;
    routHistory.myDictionary = self.myDictionary;

    [self.navigationController pushViewController:routHistory animated:YES];
}
-(void)showYesterdayHistory{
    
    RoutReplyHistoryVC *routHistory = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]
                                       instantiateViewControllerWithIdentifier:@"RoutReplyHistoryVC"];
    routHistory.dateselected = 0;
    routHistory.myDictionary = self.myDictionary;
    [self.navigationController pushViewController:routHistory animated:YES];

}
-(void)showRangeHistory{
    
    
}
-(void)setButtonImage:(int)btnTag{
    
    if(btnTag){
        [tripBtn setBackgroundImage:[UIImage imageNamed:@"Radio_button_on.png"] forState:UIControlStateNormal];//
        [continousBtn setBackgroundImage:[UIImage imageNamed:@"Radio_button_off.png"] forState:UIControlStateNormal];//

    }
    else{
        [tripBtn setBackgroundImage:[UIImage imageNamed:@"Radio_button_off.png"] forState:UIControlStateNormal];//
        [continousBtn setBackgroundImage:[UIImage imageNamed:@"Radio_button_on.png"] forState:UIControlStateNormal];//

    }
    
    
}
- (IBAction)radioBtnTrip:(id)sender {
    [self setButtonImage:1];
    _tripType = Trip;
}

- (IBAction)radioBtnContinues:(id)sender {
    [self setButtonImage:0];
    _tripType = Continous;

}
-(IBAction)backButtonPressed:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)homeButton:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)showSelcetionError:(int)type{
    
    NSString *messageTitle = @"";
    NSString *message = @"";

    switch (type) {
        case 0:{
            messageTitle = @"Error";
            message = @"Please select History Type (today,yesterday,range)";
        }
            break;
        case 1:{
            messageTitle = @"Error";
            message = @"Please select History Type (today,yesterday,range)";
        }
            break;
        case 3:{
            messageTitle = @"Select Date Range";
            message = @"Please also select Date Range (fromDate or toDate)";
        }
            break;
        case 2:{
            messageTitle = @"Select Trip Type";
            message = @"Please also select Trip Type (continous or trip)";
        }
            break;
        case 4:{
            messageTitle =@"Select Trip Type";
            message = @"Please also select Trip Type (continous or trip)";
        }
            break;
        default:
            break;
    }
   
    [[[UIAlertView alloc] initWithTitle:messageTitle message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];

    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    rangeSelector = 0;
    _historyType = None;
    toDate = nil;
    fromDate = nil;
    
}


- (IBAction)todayHistorySelector:(id)sender{
    
    _historyType = TodayHistory;
    [self showSelcetionError:2];
}
- (IBAction)yesterdayHistorySelector:(id)sender{
    
    _historyType = YesterdayHistory;
    [self showSelcetionError:2];

}

- (IBAction)fromDateSelector:(id)sender{
    
    [self showTimePickerView];
    rangeSelector = 1;

}
- (IBAction)toDateSelector:(id)sender{
    [self showTimePickerView];
    rangeSelector = 2;
}
- (IBAction)rangeSelecorPressed:(id)sender{
    [self showSelcetionError:3];
    _historyType = RangeSelection;

}
-(BOOL)isDateRangeSelected{
    
    if (toDate != nil && fromDate != nil)
        return YES;
    return NO;

}
-(BOOL)isTripTypeSelected{
    
    if (_tripType != 0 )
        return YES;
    return NO;
    
}
-(void) setTodayDates{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss.000"];
    NSDate *date = [NSDate date];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat: @"yyyy-MM-dd 00:00:00.000"];
    
    fromDate = [dateFormatter1 stringFromDate:date];
    toDate = [dateFormatter stringFromDate:date];
    
}

-(void) setYesterdayDates{
    
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow: -(60.0f*60.0f*24.0f)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd 00:01:00.000"];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat: @"yyyy-MM-dd 23:59:00.000"];
    
    fromDate = [dateFormatter stringFromDate:yesterday];
    toDate = [dateFormatter1 stringFromDate:yesterday];
    
}
- (IBAction)submitSelector:(id)sender{
    
    switch (_historyType) {
        case TodayHistory:{
            
            if ([self isTripTypeSelected]) {
                
                [self setTodayDates];
                
                if (_tripType == Continous)
                    [self showHistoryDetailViewController];
                else
                    [self showTripDetailViewController];

            }
            else
                [self showSelcetionError:0];
        }
            break;
        case YesterdayHistory:{
            
            if ([self isTripTypeSelected]) {
                
                [self setYesterdayDates];

                if (_tripType == Continous)
                    [self showHistoryDetailViewController];
                else
                    [self showTripDetailViewController];
            }
            else
                [self showSelcetionError:0];
        }
            break;
        case RangeSelection:{
            
            if ([self isDateRangeSelected] ){
                
                if ([self isTripTypeSelected] ){
                    
                    if (_tripType == Continous)
                        [self showHistoryDetailViewController];
                    else
                        [self showTripDetailViewController];
                    
                }
                else
                    [self showSelcetionError:2];
                
            }
            else
                [self showSelcetionError:3];

        }
            break;
        default:
            [self showSelcetionError:0];
            return;
            break;
    }
    
}
-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate *)date
{
    switch (pickerView.tag)
    {
        case 7:
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss.000"];
            switch (rangeSelector) {
                case 1:
                    fromDate = [formatter stringFromDate:date];
                    break;
                case 2:
                    toDate = [formatter stringFromDate:date];
                    break;

                default:
                    break;
            }
           // [buttonDate setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (void)showTimePickerView
{
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Date/Time Picker" delegate:self];
    [picker setTag:7];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDateTimePicker];
    [picker show];
}
-(void)showHistoryDetailViewController{
    
    RoutReplyHistoryVC *routHistory = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]
                                       instantiateViewControllerWithIdentifier:@"RoutReplyHistoryVC"];
    routHistory.startDate = fromDate;
    routHistory.endDate = toDate;
    routHistory.myDictionary = self.myDictionary;
    
    [self.navigationController pushViewController:routHistory animated:YES];

}
-(void)showTripDetailViewController{
    
    [[ApiController sharedManager] getVehicleTripRange:[NSString stringWithFormat:@"%@,%@",fromDate,toDate]  withtrackerid:[self.myDictionary objectForKey:@"TRACKER_GUID"] onLoginResponse:^(BOOL isloggedIn, NSData *responseResulr) {
        
        if (isloggedIn) {
            
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseResulr
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            NSArray  *VehicleData = [[NSArray alloc] initWithArray:[[json objectForKey:@"response"] objectForKey:@"data"]];
            
             NSMutableArray *TripData = [NSMutableArray arrayWithArray:VehicleData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                TripViewController *detailView =
                
                [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]
                 instantiateViewControllerWithIdentifier:@"TripViewController"];

                detailView.VehicleData = TripData;
                detailView.lablesData = [[NSDictionary alloc] initWithDictionary:[[json objectForKey:@"response"] objectForKey:@"labels"]];

                [self.navigationController pushViewController:detailView animated:YES];
                
            });
        }
        else
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No Trip Data Found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];

    }];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end