//
//  MonitorVehicleDetailView.h
//  VehicleTracker
//
//  Created by Iftikhar on 23/09/2015.
//  Copyright (c) 2015 Fazal Ellahi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MonitorVehicleDetailView : UIViewController<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *DetailLabel;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISwitch *engineSwitch;
@property (nonatomic, strong)  NSDictionary *myDictionary;

-(IBAction)backButtonPressed:(id)sender;
- (IBAction)isSwitchEnable:(id)sender;

@end
