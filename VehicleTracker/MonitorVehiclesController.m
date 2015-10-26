//
//  MonitorVehiclesController.m
//  VehicleTracker
//
//  Created by fazal on 9/19/15.
//  Copyright (c) 2015 Fazal Ellahi. All rights reserved.
//

#import "MonitorVehiclesController.h"
#import "MonitorVehiclesCell.h"
#import "ApiController.h"
#import "MonitorVehicleDetailView.h"
#import "RoutReplyViewController.h"
#import "ReplyViewController.h"
#import "MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>

@interface MonitorVehiclesController (){
    NSArray *dictfonts;
    NSArray *tableData;
    NSDictionary *lablesData;
    NSMutableArray *locationArray;
}

@end

@implementation MonitorVehiclesController

@synthesize myTableView;
@synthesize VehicleData;
@synthesize myString;
@synthesize mylbl;
@synthesize mySearchBar;

-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)SubButtonPressed:(id)sender{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[ApiController sharedManager] getAllVehivlesData:@"AllVehicles" onLoginResponse:^(BOOL isloggedIn, NSData *responseResulr) {
        
        if (isloggedIn) {
            
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseResulr
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
            // NSLog(@" data = %@",[json objectForKey:@"response"]);
            self.VehicleData = [[NSArray alloc] initWithArray:[[json objectForKey:@"response"] objectForKey:@"data"]];
            lablesData = [[NSDictionary alloc] initWithDictionary:[[json objectForKey:@"response"] objectForKey:@"labels"]];
            tableData = [self.VehicleData mutableCopy];
            [myTableView reloadData];
            
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableData = [[NSArray alloc] init];
    locationArray = [[NSMutableArray alloc] init];
    if (self.myString && [self.myString length] >0) {
        self.mylbl.text = self.myString;
    }
    
    UIFont *titlefont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0];
    UIFont *txtfont = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
    
    UIFont *detailfont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    UIFont *detailtxtfont = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
    
    
    dictfonts = @[[NSDictionary dictionaryWithObject:titlefont forKey:NSFontAttributeName],
                           [NSDictionary dictionaryWithObject:txtfont forKey:NSFontAttributeName],
                           [NSDictionary dictionaryWithObject:detailfont forKey:NSFontAttributeName],
                           [NSDictionary dictionaryWithObject:detailtxtfont forKey:NSFontAttributeName],
                           [NSDictionary dictionaryWithObject:detailfont forKey:NSFontAttributeName],
                           [NSDictionary dictionaryWithObject:detailtxtfont forKey:NSFontAttributeName],
                           [NSDictionary dictionaryWithObject:detailfont forKey:NSFontAttributeName],
                           [NSDictionary dictionaryWithObject:detailtxtfont forKey:NSFontAttributeName],
                           [NSDictionary dictionaryWithObject:detailfont forKey:NSFontAttributeName],
                           [NSDictionary dictionaryWithObject:detailtxtfont forKey:NSFontAttributeName]];
    
    

    [[ApiController sharedManager] getAllVehivlesData:@"AllVehicles" onLoginResponse:^(BOOL isloggedIn, NSData *responseResulr) {
        
        if (isloggedIn) {
            
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseResulr
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&jsonError];
            
           // NSLog(@" data = %@",[json objectForKey:@"response"]);
            self.VehicleData = [[NSArray alloc] initWithArray:[[json objectForKey:@"response"] objectForKey:@"data"]];
            lablesData = [[NSDictionary alloc] initWithDictionary:[[json objectForKey:@"response"] objectForKey:@"labels"]];
            tableData = [self.VehicleData mutableCopy];
            [myTableView reloadData];
            
            [self.VehicleData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                NSDictionary *dict = (NSDictionary*)obj;
                CLGeocoder *ceo = [[CLGeocoder alloc]init];
                CLLocation *loc = [[CLLocation alloc]initWithLatitude:[[dict objectForKey:@"Latitute"] doubleValue] longitude:[[dict objectForKey:@"Langtitute"] doubleValue]]; //insert your coordinates
                
                [ceo reverseGeocodeLocation:loc
                          completionHandler:^(NSArray *placemarks, NSError *error) {
                              CLPlacemark *placemark = [placemarks objectAtIndex:0];
                             // NSLog(@"placemark %@",placemark);
                              //String to hold address
                              NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                            //  NSLog(@"addressDictionary %@", placemark.addressDictionary);
                              /*
                              NSLog(@"placemark %@",placemark.region);
                              NSLog(@"placemark %@",placemark.country);  // Give Country Name
                              NSLog(@"placemark %@",placemark.locality); // Extract the city name
                              NSLog(@"location %@",placemark.name);
                              NSLog(@"location %@",placemark.ocean);
                              NSLog(@"location %@",placemark.postalCode);
                              NSLog(@"location %@",placemark.subLocality);
                              
                              NSLog(@"location %@",placemark.location);*/
                              //Print the location to console
                              NSLog(@"I am currently at %@",locatedAt);
                              [locationArray addObject:locatedAt];
                             
                              if ([locationArray count] == [self.VehicleData count]) {
                                
                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                      [self.myTableView reloadData];
                                  });
                              }
                          }];

            }];
            
        }
    }];
    self.myTableView.tableFooterView = [[UIView alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"MonitorVehiclesCell";
    

    MonitorVehiclesCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        
        cell = [[MonitorVehiclesCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
        
        
    }
    [cell.stopCarBtn addTarget:self action:@selector(stopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (![[[tableData objectAtIndex:indexPath.row] objectForKey:@"Engine"] isEqual:@"Off"]) {
        [cell.stopCarBtn setBackgroundImage:[UIImage imageNamed:@"EngineOn.png"] forState:UIControlStateNormal];
    }
    else{
        [cell.stopCarBtn setBackgroundImage:[UIImage imageNamed:@"EngineOff.png"] forState:UIControlStateNormal];

    }
    
    cell.textlbl.attributedText =[self getCellAttributedText:[tableData objectAtIndex:indexPath.row] forRowAtIndexPath:(int)indexPath.row];
    cell.textlbl.textColor = [UIColor whiteColor];
    
    return cell;
}
-(void)stopButtonPressed:(id)sender{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIButton *btn  = (UIButton*)sender;
        CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:self.myTableView];
        NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
        
        NSString *postValue;
        if ([[[tableData objectAtIndex:indexPath.row] objectForKey:@"Engine"] isEqual:@"Off"])
            postValue = @"turnOn";
        else
            postValue = @"turnoff";
        
        
        [[ApiController sharedManager] PostSwitchOnOff:postValue trackerId:[[tableData objectAtIndex:indexPath.row] objectForKey:@"TRACKER_GUID"] onLoginResponse:^(BOOL isloggedIn, NSData *responseResulr) {
            
            if(isloggedIn){
                
                NSError *jsonError;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseResulr
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&jsonError];
                NSLog(@"%@",json);
                
                
            }
            else
            {
                NSLog(@"Error");
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }];
    });


}
- (void)uploadDataOnThread
{
   
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = [tableData objectAtIndex:indexPath.row];
    
    
    if(![[dict objectForKey:@"Latitute"] length] || ![[dict objectForKey:@"Langtitute"] length]){
        
        [[[UIAlertView alloc] initWithTitle:@"GPS Error" message:@"Gps is not Installed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    
    if (self.myString && [self.myString isEqualToString:@"Route Replay"]) {
        ReplyViewController  *settingsView = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]
                                                  instantiateViewControllerWithIdentifier:@"ReplyViewController"];
        settingsView.myDictionary = [tableData objectAtIndex:indexPath.row];
        
        [self.navigationController pushViewController:settingsView animated:YES];
        
    }
    else{
        
        MonitorVehicleDetailView *settingsView = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]
                                                  instantiateViewControllerWithIdentifier:@"MonitorVehicleDetailView"];
        settingsView.myDictionary = [tableData objectAtIndex:indexPath.row];
        
        [self.navigationController pushViewController:settingsView animated:YES];
    }

}

-(NSAttributedString*)getCellAttributedText:(NSDictionary*)text forRowAtIndexPath:(int)rowId{
    
    
    NSArray *dictWord = @[[NSString stringWithFormat:@"NumberPlate : %@",[text objectForKey:@"NumberPlate"]],
                          [NSString stringWithFormat:@"TrackerName : %@",[text objectForKey:@"TrackerName"]],
                          [NSString stringWithFormat:@"Speed : %0.3f %@",[[text objectForKey:@"Speed"] floatValue],[lablesData objectForKey:@"speedUnit"]],
                          [NSString stringWithFormat:@"Mileage : %0.3f",[[text objectForKey:@"Mileage"]floatValue]],
                          [NSString stringWithFormat:@"Time : %@",[text objectForKey:@"Time"]]];
        
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@""];
    
    int i = 0;
    
    for (NSString * word in dictWord) {
        
        NSDictionary *attrsDictionary = [dictfonts objectAtIndex:i++];
        
        NSAttributedString * subString = [[NSAttributedString alloc] initWithString:[[word componentsSeparatedByString:@" :"] objectAtIndex:0] attributes:attrsDictionary];
        
        [string appendAttributedString:subString];
        
        [string appendAttributedString:[[NSAttributedString alloc] initWithString:@" : " attributes:nil]];
        
        
        attrsDictionary = [dictfonts objectAtIndex:i++];
        
        subString = [[NSAttributedString alloc] initWithString:[[word componentsSeparatedByString:@" :"] objectAtIndex:1]  attributes:attrsDictionary];
        
        [string appendAttributedString:subString];
        
        if (![[[word componentsSeparatedByString:@":"] objectAtIndex:0] isEqualToString:@"Time "])
            [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:nil]];
        
    }
    if ([locationArray count]  && [locationArray count] >=rowId ) {
        
        NSDictionary *attrsDictionary = dictfonts[8];
        
        NSAttributedString *subString = [[NSAttributedString alloc] initWithString:@"\nAddress: \t"  attributes:attrsDictionary];
        
        [string appendAttributedString:subString];
        
        attrsDictionary = dictfonts[9];
        
        subString = [[NSAttributedString alloc] initWithString:[locationArray objectAtIndex:rowId]  attributes:attrsDictionary];
        
        [string appendAttributedString:subString];
        
    }
    
    return string;
}
# pragma searchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@" searchBarTextDidBeginEditing ");
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    NSLog(@" searchBarShouldEndEditing ");
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@" searchBarTextDidEndEditing ");

}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //NSLog(@" textDidChange ");
    if ([searchBar.text length] > 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NumberPlate CONTAINS[cd] %@",
                                  searchBar.text];
        NSArray *filteredArray = [self.VehicleData filteredArrayUsingPredicate:predicate];
        
        if([filteredArray count]>0){
            
            tableData = [filteredArray mutableCopy];
            [self.myTableView reloadData];
        }
        
    }
    else{
        tableData = [self.VehicleData mutableCopy];
        [self.myTableView reloadData];
    }

}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if ([searchBar.text length] > 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NumberPlate CONTAINS[cd] %@",
                                  searchBar.text];
        NSArray *filteredArray = [tableData filteredArrayUsingPredicate:predicate];
        
        if([filteredArray count]>0){
            
            tableData = [filteredArray mutableCopy];
            [self.myTableView reloadData];
        }
       
    }
    [self.mySearchBar resignFirstResponder];    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;{
    NSLog(@" searchBarCancelButtonClicked ");
    
    self.mySearchBar.text = @"";
    [self.mySearchBar resignFirstResponder];
    tableData = [self.VehicleData mutableCopy];
    [self.myTableView reloadData];

}


@end