/*

 Copyright (c) 2013 Joan Lluch <joan.lluch@sweetwilliamsl.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 Original code:
 Copyright (c) 2011, Philip Kluz (Philip.Kluz@zuui.org)
*/

#import "FrontViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#

@interface FrontViewController()<MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray *mapAnnotations;
@property (nonatomic, strong) UIPopoverController *bridgePopoverController;
@property (nonatomic, strong) NSMutableArray *DataArray;
@property (nonatomic, strong) MKPolyline *polyline;
@property (nonatomic, strong) MKPolylineView *lineView;
- (IBAction)backButtonPressed:(id)sender;



// Private Methods:
- (IBAction)pushExample:(id)sender;

@end

#define METERS_PER_MILE 1609.344


@implementation FrontViewController

@synthesize TripDictionary;

#pragma mark - View lifecycle


- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title = NSLocalizedString(@"Trip Detail", nil);

    self.mapView.delegate = self;

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"TestNotification"
                                               object:nil];
  
    SWRevealViewController *revealController = [self revealViewController];
  
    self.mapAnnotations = [[NSMutableArray alloc] initWithCapacity:1];
    self.DataArray = [[NSMutableArray alloc] initWithCapacity:1];
    self.mapView.delegate = self;

    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
        style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    UIBarButtonItem *rightRevealButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightRevealToggle:)];
    
    self.navigationItem.rightBarButtonItem = rightRevealButtonItem;
    
    if ([self.TripDictionary allKeys].count) {
        
        NSArray *array = [self.TripDictionary allKeys];
        
        self.TripDictionary = [NSDictionary dictionaryWithDictionary:[self.TripDictionary objectForKey:[array objectAtIndex:0]]];
        
        if (array.count) {
            
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[self.TripDictionary objectForKey:@"startLatitude"],@"Latitute", [self.TripDictionary objectForKey:@"startLongitude"],@"Langtitute",nil];
            NSDictionary *dict1 =[[NSDictionary alloc] initWithObjectsAndKeys:[self.TripDictionary objectForKey:@"endLatitude"],@"Latitute", [self.TripDictionary objectForKey:@"endLongitude"],@"Langtitute",nil];
            NSArray *arry = @[dict,dict1];
            [self drawLine:arry];
            
        }
    }
}
//{"Trip1":{"startTime":"18-08-2015 05:02:41 am","endTime":"18-08-2015 05:02:55 am","startLatitude":"25.268378","startLongitude":"55.328268","endLatitude":"25.269663","endLongitude":"55.328082","distanceTravel":0.155,"driveTime":" 14 Seconds ","minimumSpeed":null,"maximumSpeed":37.7,"averageSpeed":24.9666666667,"tripSignal":[{"tripNumber":1,"trackerID":3,"NumberPlate":"1","Speed":37.2,"Latitute":"25.268378","Langtitute":"55.328268","Mileage":1.99,"Time":"18-08-2015 05:02:41 am","Engine":"On","AlarmTitle":"Signal"},{"tripNumber":1,"trackerID":3,"NumberPlate":"1","Speed":37.7,"Latitute":"25.269663","Langtitute":"55.328082","Mileage":2.145,"Time":"18-08-2015 05:02:55 am","Engine":"On","AlarmTitle":"No Battery"}]}}

- (void) receiveTestNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"TestNotification"])
        NSLog (@"Successfully received the test notification!");
    
    self.TripDictionary = [[NSDictionary alloc] initWithDictionary:[[[AppDelegate sharedAppDelegate].TripData objectAtIndex:0] objectForKey:@"Trip1"]];
   
    if ([self.TripDictionary allKeys].count) {
        
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[self.TripDictionary objectForKey:@"startLatitude"],@"Latitute", [self.TripDictionary objectForKey:@"startLongitude"],@"Langtitute",nil];
        NSDictionary *dict1 =[[NSDictionary alloc] initWithObjectsAndKeys:[self.TripDictionary objectForKey:@"endLatitude"],@"Latitute", [self.TripDictionary objectForKey:@"endLongitude"],@"Langtitute",nil];
        NSArray *arry = @[dict,dict1];
        [self drawLine:arry];

    }

}

#pragma mark - Example Code

- (IBAction)pushExample:(id)sender
{
	UIViewController *stubController = [[UIViewController alloc] init];
	stubController.view.backgroundColor = [UIColor whiteColor];
	[self.navigationController pushViewController:stubController animated:YES];
}


- (IBAction)rightRevealToggle:(id)sender
{
    [[AppDelegate sharedAppDelegate].viewController.navigationController popViewControllerAnimated:YES];
}
- (void)drawLine:( NSArray *)VehicleData {
    
    [self.mapView removeOverlay:self.polyline];
    

    for (NSDictionary *dict in VehicleData) {
        
        [self addPinWithTitle:[self.TripDictionary objectForKey:@"NumberPlate"] AndCoordinate:[NSString stringWithFormat:@"%@,%@",[dict objectForKey:@"Latitute"],[dict objectForKey:@"Langtitute"]]];
        
    }
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
}
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
    // CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude,longitude);
    
    mapPin.title = title;
    mapPin.coordinate = coordinate;
    [self.mapAnnotations addObject:mapPin];
    [self.mapView addAnnotation:mapPin];
}


- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end