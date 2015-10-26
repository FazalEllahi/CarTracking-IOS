//
//  MonitorVehiclesController.h
//  VehicleTracker
//
//  Created by fazal on 9/19/15.
//  Copyright (c) 2015 Fazal Ellahi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TripViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property(nonatomic,retain) IBOutlet UITableView *myTableView;

@property(nonatomic,retain) IBOutlet UISearchBar *mySearchBar;

@property(nonatomic,strong) IBOutlet UILabel *mylbl;

@property(nonatomic,retain) NSString *myString;

@property (nonatomic, strong) NSArray *VehicleData;

@property (nonatomic, strong) NSDictionary *lablesData;

-(IBAction)backButtonPressed:(id)sender;
-(IBAction)SubButtonPressed:(id)sender;


@end
