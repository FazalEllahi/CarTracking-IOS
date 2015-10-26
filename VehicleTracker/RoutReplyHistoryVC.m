//
//  RoutReplyHistoryVC.m
//  VehicleTracker
//
//  Created by fazal on 10/7/15.
//  Copyright (c) 2015 Fazal Ellahi. All rights reserved.
//

#import "RoutReplyHistoryVC.h"
#import "ApiController.h"
#import "DetailViewController.h"
#import <MapKit/MapKit.h>

@interface RoutReplyHistoryVC ()

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray *mapAnnotations;
@property (nonatomic, strong) UIPopoverController *bridgePopoverController;
@property (nonatomic, strong) NSMutableArray *DataArray;
@property (nonatomic, strong) MKPolyline *polyline;
@property (nonatomic, strong) MKPolylineView *lineView;


@end

#define METERS_PER_MILE 1609.344


@implementation RoutReplyHistoryVC

@synthesize myDictionary;

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
    
    
    self.mapAnnotations = [[NSMutableArray alloc] initWithCapacity:1];
    self.DataArray = [[NSMutableArray alloc] initWithCapacity:1];
    self.mapView.delegate = self;

    
    [[ApiController sharedManager] getVehicleTrips:[NSString stringWithFormat:@"%@,%@",_startDate,_endDate] withtrackerid:[self.myDictionary objectForKey:@"TRACKER_GUID"] onLoginResponse:^(BOOL isloggedIn, NSData *responseResulr) {
        
        if (isloggedIn) {
            
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseResulr
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];

            NSArray  *VehicleData = [[NSArray alloc] initWithArray:[[json objectForKey:@"response"] objectForKey:@"data"]];
            
            [self drawLine:VehicleData];
            
        }
        else
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No Trip History Found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];

        
    }];
    
}
- (void)drawLine:( NSArray *)VehicleData {
    
    [self.mapView removeOverlay:self.polyline];
        
    for (NSDictionary *dict in VehicleData) {
        
        if([self.mapAnnotations count]>20)
        break;
        
        [self addPinWithTitle:[dict objectForKey:@"NumberPlate"] AndCoordinate:[NSString stringWithFormat:@"%@,%@",[dict objectForKey:@"Langtitute"],[dict objectForKey:@"Latitute"]]];
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // create an array of coordinates from allPins
        CLLocationCoordinate2D coordinates[self.mapAnnotations.count];
        int i = 0;
        for (MKPointAnnotation *currentPin in self.mapAnnotations) {
            coordinates[i] = currentPin.coordinate;
            i++;
        }
        
        MKPolygon *polygon = [MKPolygon polygonWithCoordinates:coordinates count:self.mapAnnotations.count];
        [self.mapView addOverlay:polygon];
        [self.mapView showAnnotations:self.mapAnnotations animated:YES];
        
    });
  

//    
//    // create a polyline with all cooridnates
//    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coordinates count:self.mapAnnotations.count];
//    [self.mapView addOverlay:polyline];
//    self.polyline = polyline;
//    
//    // create an MKPolylineView and add it to the map view
//    self.lineView = [[MKPolylineView alloc]initWithPolyline:self.polyline];
//    self.lineView.strokeColor = [UIColor redColor];
//    self.lineView.lineWidth = 5;
    
}

#pragma mark - Button Actions

- (void)gotoByAnnotationClass:(Class)annotationClass
{
    // user tapped "City" button in the bottom toolbar
    for (id annotation in self.mapAnnotations)
    {
        if ([annotation isKindOfClass:annotationClass])
        {
            // remove any annotations that exist
            [self.mapView removeAnnotations:self.mapView.annotations];
            // add just the city annotation
            [self.mapView addAnnotation:annotation];
            
            [self gotoDefaultLocation];
        }
    }
}


- (IBAction)allAction:(id)sender
{
    // user tapped "All" button in the bottom toolbar
    
    // remove any annotations that exist
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    // add all 3 annotations
    [self.mapView addAnnotations:self.mapAnnotations];
    
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
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    MKPolylineRenderer *lineView = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        lineView.strokeColor = [UIColor greenColor];
        
        return lineView;
}
- (MKAnnotationView *)mapView:(MKMapView*)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (annotation == mapView.userLocation) {
        return nil;
    }
    
    MKAnnotationView *annotationView;
    NSString *identifier = @"Pin";
    annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (nil == annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.image = [UIImage imageNamed:@"car.png"];    //as suggested by Squatch
        
        
    }
    
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    NSInteger annotationValue = [self.DataArray indexOfObject:annotation];
//    rightButton.tag = annotationValue;
//    [rightButton addTarget:self action:@selector(showDetailView:) forControlEvents:UIControlEventTouchUpInside];
//    [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
//    ((MKPinAnnotationView *)annotationView).rightCalloutAccessoryView = rightButton;
    
    
    return annotationView;
}

-(IBAction)showDetailView:(UIView*)sender {
    // get the tag value from the sender
    NSInteger selectedIndex = sender.tag;
    NSLog(@"selectedIndex %ld",(long)selectedIndex);
    
    DetailViewController *detailView = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]
                                        instantiateViewControllerWithIdentifier:@"DetailViewController"];
    detailView.myDict = [self.mapAnnotations objectAtIndex:selectedIndex];
    [self.navigationController pushViewController:detailView animated:YES];
    
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
   // CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(longitude,latitude);

    mapPin.title = title;
    mapPin.coordinate = coordinate;
    [self.mapAnnotations addObject:mapPin];
    [self.mapView addAnnotation:mapPin];
}

@end
