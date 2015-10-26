//
//  SettingsViewController.h
//  VehicleTracker
//
//  Created by fazal on 9/22/15.
//  Copyright (c) 2015 Fazal Ellahi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignoutDelegate <NSObject>

-(void)SettingsViewControler:(id)SettingsView didSelectSignoutSelector:(BOOL)success;

@end

@interface SettingsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, retain) NSMutableArray *settingsData;

@property (nonatomic, strong) IBOutlet UILabel *titlelbl;

@property (nonatomic, strong) IBOutlet UIButton *backBtn;

@property (nonatomic, assign) NSUInteger SettingsType;

@property (nonatomic,strong) NSObject<SignoutDelegate> *adelegate;

-(IBAction)backButtonPressed:(id)sender;
-(IBAction)doneButtonPressed:(id)sender;


@end
