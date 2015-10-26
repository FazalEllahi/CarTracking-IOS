/*
 File: MapViewController.m
 Abstract: n/a
 Version: 1.5
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 
 */

#import "MapViewController.h"
#import "DetailViewController.h"
#import "ApiController.h"
#import "DetailViewController.h"

#import "SFAnnotation.h"            // annotation for the city of San Francisco
#import "BridgeAnnotation.h"        // annotation for the Golden Gate bridge
#import "CustomAnnotation.h"        // annotation for the Tea Garden

@interface MapViewController () <MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray *mapStopAllAnnotations;
@property (nonatomic, strong) NSMutableArray *mapStartAllAnnotations;
@property (nonatomic, strong) NSMutableArray *AllAnnotations;
@property (nonatomic, strong) NSMutableArray *stopAllData;
@property (nonatomic, strong) NSMutableArray *startAllData;
@property (nonatomic, strong) NSMutableArray *AllData;
@property (nonatomic, strong) UIPopoverController *bridgePopoverController;
@property (nonatomic, strong) NSMutableArray *DataArray;


@end
#define METERS_PER_MILE 1609.344

#pragma mark -

@implementation MapViewController


-(IBAction)backButtonPressed:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)gotoDefaultLocation
{
    // start off by default in San Francisco
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = 37.786996;
    newRegion.center.longitude = -122.440100;
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    
    [self.mapView setRegion:newRegion animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    
    // create a custom navigation bar button and set it to always says "Back"
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"Back";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [self.navigationController setNavigationBarHidden:NO];
    
    self.mapStopAllAnnotations = [[NSMutableArray alloc] initWithCapacity:1];
    self.mapStartAllAnnotations = [[NSMutableArray alloc] initWithCapacity:1];
    self.AllAnnotations = [[NSMutableArray alloc] initWithCapacity:1];

    self.AllData = [[NSMutableArray alloc] initWithCapacity:1];
    self.startAllData = [[NSMutableArray alloc] initWithCapacity:1];
    self.stopAllData = [[NSMutableArray alloc] initWithCapacity:1];

    
    self.DataArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    _selectedType = 0;
    
    
    [[ApiController sharedManager] getAllVehivlesData:@"AllVehicles" onLoginResponse:^(BOOL isloggedIn, NSData *responseResulr) {
        
        if (isloggedIn) {
            
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseResulr
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            // NSLog(@" data = %@",[json objectForKey:@"response"]);
            NSArray  *VehicleData = [[NSArray alloc] initWithArray:[[json objectForKey:@"response"] objectForKey:@"data"]];
            
            for (NSDictionary *dict in VehicleData) {
                
                NSString *Langtitute = [dict objectForKey:@"Langtitute"];
                NSString *Latitute = [dict objectForKey:@"Latitute"] ;
                
                if(![Langtitute isKindOfClass:[NSNull class]])
                {
                    if ([[dict objectForKey:@"Engine"] isEqualToString:@"Off"]){
                        [self addPinWithTitle:[dict objectForKey:@"TrackerName"] AndCoordinate:[NSString stringWithFormat:@"%@,%@",Langtitute,Latitute] withEngineVlueIsOn:NO];
                        
                        [self.stopAllData addObject:dict];

                    }
                    else{
                        
                        [self addPinWithTitle:[dict objectForKey:@"TrackerName"] AndCoordinate:[NSString stringWithFormat:@"%@,%@",Langtitute,Latitute] withEngineVlueIsOn:YES];
                        
                        [self.startAllData addObject:dict];

                    }
                    [self.AllData addObject:dict];
                    
                }
            }
            [self.mapView showAnnotations:self.AllAnnotations animated:YES];

            
        }
    }];
    
}


#pragma mark - Button Actions


- (IBAction)cityAction:(id)sender //stopOnly
{
    _selectedType = 1;

    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.mapStopAllAnnotations];
    
}

- (IBAction)bridgeAction:(id)sender //StartOnly
{
    _selectedType = 2;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:self.mapStartAllAnnotations];
}



- (IBAction)allAction:(id)sender //StartOnly
{
    // user tapped "All" button in the bottom toolbar
    
    // remove any annotations that exist
    _selectedType = 0;

    [self.mapView removeAnnotations:self.mapView.annotations];
    
    // add all 3 annotations
    [self.mapView addAnnotations:self.AllAnnotations];
    
    //  [self gotoDefaultLocation];
}


#pragma mark - MKMapViewDelegate

// user tapped the disclosure button in the bridge callout
//
//- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
//{
//    // here we illustrate how to detect which annotation type was clicked on for its callout
//    id <MKAnnotation> annotation = [view annotation];
//    if ([annotation isKindOfClass:[BridgeAnnotation class]])
//    {
//        NSLog(@"clicked Golden Gate Bridge annotation");
//
//        DetailViewController *detailViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"DetailViewController"];
//        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//        {
//            // for iPad, we use a popover
//            if (self.bridgePopoverController == nil)
//            {
//                _bridgePopoverController = [[UIPopoverController alloc] initWithContentViewController:detailViewController];
//            }
//            [self.bridgePopoverController presentPopoverFromRect:control.bounds
//                                                          inView:control
//                                        permittedArrowDirections:UIPopoverArrowDirectionLeft
//                                                        animated:YES];
//        }
//        else
//        {
//            // for iPhone we navigate to a detail view controller using UINavigationController
//            [self.navigationController pushViewController:detailViewController animated:YES];
//        }
//    }
//}
- (MKAnnotationView *)mapView:(MKMapView*)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (annotation == mapView.userLocation) {
        return nil;
    }
    
    MKAnnotationView *annotationView;
    NSString *identifier = @"Pin";
    annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    
    NSInteger annotationValue ;
    NSDictionary *dict;
    
    switch ( _selectedType ) {
        case allCar:
            annotationValue = [self.AllAnnotations indexOfObject:annotation];
            dict = [self.AllData objectAtIndex:annotationValue];
            break;
        case stopCar:
            annotationValue = [self.mapStopAllAnnotations indexOfObject:annotation];
            dict = [self.stopAllData objectAtIndex:annotationValue];
            break;
        case startcar:
            annotationValue = [self.mapStartAllAnnotations indexOfObject:annotation];
            dict = [self.startAllData objectAtIndex:annotationValue];
            break;
            
        default:
            break;
    }

    if (nil == annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        if([[dict objectForKey:@"Engine"] isEqual:@"Off"])
            annotationView.image = [UIImage imageNamed:@"car.png"];
        else
            annotationView.image = [UIImage imageNamed:@"car-green.png"];
        
        
    }
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
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
    
    DetailViewController *detailView = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]
                                        instantiateViewControllerWithIdentifier:@"DetailViewController"];
    
    switch ( _selectedType ) {
        case allCar:
            detailView.myDict = [self.AllData objectAtIndex:selectedIndex];
            break;
        case stopCar:
            detailView.myDict = [self.stopAllData objectAtIndex:selectedIndex];
            break;
        case startcar:
            detailView.myDict = [self.startAllData objectAtIndex:selectedIndex];
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:detailView animated:YES];
    
}
-(void)addPinWithTitle:(NSString *)title AndCoordinate:(NSString *)strCoordinate withEngineVlueIsOn:(BOOL)isOn
{
    MKPointAnnotation *mapPin = [[MKPointAnnotation alloc] init];
    
    // clear out any white space
    strCoordinate = [strCoordinate stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // convert string into actual latitude and longitude values
    NSArray *components = [strCoordinate componentsSeparatedByString:@","];
    
    double latitude = [components[0] doubleValue];
    double longitude = [components[1] doubleValue];
    
    // setup the map pin with all data and add to map view
    //   CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(longitude,latitude);
    
    mapPin.title = title;
    mapPin.coordinate = coordinate;
    if (isOn)
        [self.mapStartAllAnnotations addObject:mapPin];
    else
        [self.mapStopAllAnnotations addObject:mapPin];
    
    [self.AllAnnotations addObject:mapPin];
    [self.mapView addAnnotation:mapPin];
}
@end
