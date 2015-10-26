//
//  RoutReplyHistoryVC.h
//  VehicleTracker
//
//  Created by fazal on 10/7/15.
//  Copyright (c) 2015 Fazal Ellahi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

typedef NS_ENUM(NSInteger, DatesSelected) {
    Today = 0,
    YesterDay,
    Range ,
};

@interface RoutReplyHistoryVC : UIViewController<MKMapViewDelegate>

@property(nonatomic,assign) NSDictionary *myDictionary;
@property(nonatomic,assign) NSString *startDate;
@property(nonatomic,assign) NSString *endDate;


-(IBAction)backButtonPressed:(id)sender;

@property(nonatomic,assign) DatesSelected dateselected;

@end
