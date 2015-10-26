//
//  SettingsDetailViewController.h
//  VehicleTracker
//
//  Created by Iftikhar on 30/09/2015.
//  Copyright (c) 2015 Fazal Ellahi. All rights reserved.
//

#import <UIKit/UIKit.h>
enum SettingsType{
    Settings,
    Language,
    TimeZone,
    SpeedMeter,
    Alarms
    
};
@interface SettingsDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, retain) NSArray *settingsData;

@property (nonatomic, retain) NSDictionary *myDctionary;

@property (nonatomic, strong) IBOutlet UILabel *titlelbl;

@property (nonatomic, strong) IBOutlet UIButton *backBtn;

@property (nonatomic, assign) NSUInteger SettingsType;

-(IBAction)backButtonPressed:(id)sender;
-(IBAction)doneButtonPressed:(id)sender;

@end
