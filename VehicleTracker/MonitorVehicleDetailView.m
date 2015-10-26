//
//  MonitorVehicleDetailView.m
//  VehicleTracker
//
//  Created by Iftikhar on 23/09/2015.
//  Copyright (c) 2015 Fazal Ellahi. All rights reserved.
//

#define METERS_PER_MILE 1609.344

#import "MonitorVehicleDetailView.h"
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
#import "ApiController.h"

@interface MonitorVehicleDetailView ()

@property (nonatomic, strong) NSMutableArray *mapAnnotations;

@end

@implementation MonitorVehicleDetailView

@synthesize mapView;

@synthesize myDictionary;

@synthesize engineSwitch;

@synthesize DetailLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapAnnotations = [[NSMutableArray alloc] initWithCapacity:1];
    self.mapView.delegate = self;
    
    [self addPinWithTitle:[myDictionary objectForKey:@"TrackerName"] AndCoordinate:[NSString stringWithFormat:@"%@,%@",[myDictionary objectForKey:@"Langtitute"],[myDictionary objectForKey:@"Latitute"]]];
    
    if([[myDictionary objectForKey:@"Engine"] isEqual:@"Off"]){
        [engineSwitch setOn:false];
    }
    
    if([myDictionary allKeys].count >0){
          
        NSString *str = [NSString stringWithFormat:@" TrackerName:\t%@ \n\n NumberPlate:\t%@\n\n Speed:\t%@\n\n Mileage:\t%@\n\n Time:\t%@\n\n Engine:\t%@",[myDictionary objectForKey:@"TrackerName"],[myDictionary objectForKey:@"NumberPlate"],[myDictionary objectForKey:@"Speed"],[myDictionary objectForKey:@"Mileage"],[myDictionary objectForKey:@"Time"],[myDictionary objectForKey:@"Engine"]];
        NSLog(@"%@",str);
        [self.DetailLabel setText: str];
        
        
    }
}
- (IBAction)isSwitchEnable:(id)sender{
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        NSString *postValue;
        UISwitch *uiswitch = (UISwitch*)sender;
        if (uiswitch.isOn)
        postValue = @"turnOn";
        else
        postValue = @"turnoff";
        
        
        [[ApiController sharedManager] PostSwitchOnOff:postValue trackerId:[myDictionary objectForKey:@"TRACKER_GUID"] onLoginResponse:^(BOOL isloggedIn, NSData *responseResulr) {
            
            if(isloggedIn){
                
                NSError *jsonError;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseResulr
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&jsonError];
                
                if([[[json objectForKey:@"response"] objectForKey:@"code"] isEqualToString:@"2"]){
                    
                    NSString *str = [[json objectForKey:@"response"] objectForKey:@"message"];
                    [[[UIAlertView alloc] initWithTitle:@"Success" message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                    if([str isEqualToString:@"Switched On Successfully"]){
                        [engineSwitch setOn:YES];
                    }
                    else
                    [engineSwitch setOn:false];

                    

                }
                NSLog(@"%@",json);
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                
            }
            else
            {
                NSLog(@"Error");
                [MBProgressHUD hideHUDForView:self.view animated:YES];

            }
            
        }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    // 1
    [super viewWillAppear:animated];
    
    [self.mapView showAnnotations:self.mapAnnotations animated:YES];
}
- (MKAnnotationView *)mapView:(MKMapView*)mapview
            viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (annotation == mapview.userLocation) {
        return nil;
    }
    
    MKAnnotationView *annotationView;
    NSString *identifier = @"Pin";
    annotationView = (MKAnnotationView *)[mapview dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (nil == annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        if([[myDictionary objectForKey:@"Engine"] isEqual:@"Off"])
            annotationView.image = [UIImage imageNamed:@"car.png"];
        else
            annotationView.image = [UIImage imageNamed:@"car-green.png"];

        
    }
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    NSInteger annotationValue = [self.mapAnnotations indexOfObject:annotation];
    rightButton.tag = annotationValue;
    [rightButton addTarget:self action:@selector(showDetailView:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    ((MKPinAnnotationView *)annotationView).rightCalloutAccessoryView = rightButton;
    
    
    return annotationView;
}
-(IBAction)showDetailView:(UIView*)sender {
    // get the tag value from the sender
    NSInteger selectedIndex = sender.tag;
    NSLog(@"selectedIndex %ld",(long)selectedIndex);
    
}
-(void)addPinWithTitle:(NSString *)title AndCoordinate:(NSString *)strCoordinate
{
    MKPointAnnotation *mapPin = [[MKPointAnnotation alloc] init];
    
    // clear out any white space
    strCoordinate = [strCoordinate stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // convert string into actual latitude and longitude values
    NSArray *components = [strCoordinate componentsSeparatedByString:@","];
    
    double latitude = [components[0] doubleValue];
    double longitude = [components[1] doubleValue];
    
    // setup the map pin with all data and add to map view
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(longitude,latitude);
    
    mapPin.title = title;
    mapPin.coordinate = coordinate;
    [self.mapAnnotations addObject:mapPin];
    [self.mapView addAnnotation:mapPin];
}
- (IBAction)RefreshBtnPressed:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

    [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

@end
