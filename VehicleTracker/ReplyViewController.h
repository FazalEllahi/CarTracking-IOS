//
//  RoutReplyViewController.h
//  VehicleTracker
//
//  Created by Iftikhar on 30/09/2015.
//  Copyright (c) 2015 Fazal Ellahi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    TodayHistory = 0,
    YesterdayHistory = 1,
    RangeSelection = 2,
    None = 3,

    
}
HistoryTypeSelection;

typedef enum{
    Non = 0,
    Continous = 1,
    Trip = 2
    
}TripType;

@interface ReplyViewController : UIViewController<UIActionSheetDelegate>{
    UIActionSheet *actionSheet;
}

@property(nonatomic,assign) NSDictionary *myDictionary;
@property(nonatomic,assign) HistoryTypeSelection historyType;
@property(nonatomic,assign) TripType tripType;


-(IBAction)backButtonPressed:(id)sender;
- (IBAction)radioBtnTrip:(id)sender;
- (IBAction)radioBtnContinues:(id)sender;
- (IBAction)homeButton:(id)sender;
- (IBAction)todayHistorySelector:(id)sender;
- (IBAction)yesterdayHistorySelector:(id)sender;
- (IBAction)fromDateSelector:(id)sender;
- (IBAction)toDateSelector:(id)sender;
- (IBAction)submitSelector:(id)sender;
- (IBAction)rangeSelecorPressed:(id)sender;

@end
