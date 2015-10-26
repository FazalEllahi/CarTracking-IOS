//
//  SettingsDetailViewController.m
//  VehicleTracker
//
//  Created by Iftikhar on 30/09/2015.
//  Copyright (c) 2015 Fazal Ellahi. All rights reserved.
//

#import "SettingsDetailViewController.h"
#import "SettingsDetailCell.h"
#import "ApiController.h"

@interface SettingsDetailViewController (){
    NSMutableArray *checkedArray;
    int selectedIndex;
    int PreviousSelectedIndex;
}

@end

@implementation SettingsDetailViewController


@synthesize myTableView;
@synthesize settingsData;
@synthesize SettingsType;
@synthesize titlelbl;
@synthesize backBtn;
@synthesize myDctionary;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    checkedArray = [[NSMutableArray alloc] init];
    self.myTableView.tableFooterView = [[UIView alloc] init];
    
    switch (SettingsType) {
        case Settings:{
            
            settingsData = @[@"Languages",@"SpeedMeter",@"TimeZone",@"Alarms",@"Signout"];
        }
            break;
        case Language:{
            
            titlelbl.text = @"Language";
            [[ApiController sharedManager] getLanguageList:@"SettingView" onLoginResponse:^(BOOL isloggedIn, NSData *responseResulr) {
                
                if (isloggedIn) {
                    
                    NSError *jsonError;
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseResulr
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:&jsonError];
                    settingsData = [[json objectForKey:@"response"] objectForKey:@"data"];
                    
                    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
                    NSDictionary *language = [standard objectForKey:AppLanguageKey];
                    
                    if ([[language allKeys] count] < 1) {
                        language = [settingsData objectAtIndex:0];
                        [standard setObject:language forKey:AppLanguageKey];
                    }
                    
                    for (int i = 0; i < [settingsData count]; i++) {
                        
                        if ([[settingsData objectAtIndex:i] isEqualToDictionary:language]){
                            PreviousSelectedIndex = i;
                            selectedIndex = i;
                            [checkedArray addObject:[NSNumber numberWithBool:true]];
                        }
                        else
                            [checkedArray addObject:[NSNumber numberWithBool:false]];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.myTableView reloadData];
                        
                    });
                }
            }];
        }
            break;
        case SpeedMeter:{
            
            titlelbl.text = @"SpeedMeter";

            [[ApiController sharedManager] getSpeedMeter:@"SettingView" onLoginResponse:^(BOOL isloggedIn, NSData *responseResulr) {
                
                if (isloggedIn) {
                    NSError *jsonError;
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseResulr
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:&jsonError];
                    myDctionary = [[json objectForKey:@"response"] objectForKey:@"data"];
                    
                    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
                    NSString *speedUnit = [standard objectForKey:AppSpeedUnitKey];
                    
                    NSArray *allkeys = [myDctionary allKeys];
                    
                    if (speedUnit == nil || [speedUnit length] < 1) {
                        
                        speedUnit = [NSString stringWithFormat:@"%d",1];//[myDctionary objectForKey:[allkeys objectAtIndex:0]];
                        
                        [standard setObject:speedUnit forKey:AppSpeedUnitKey];
                    }
                    
                    for (int i = 0; i < [allkeys count]; i++) {
                        
                        NSString *str = [NSString stringWithFormat:@"%d",(i+1)];//[myDctionary objectForKey:[allkeys objectAtIndex:i]];

                        if ([str isEqual:speedUnit])
                        {
                            PreviousSelectedIndex = i;
                            selectedIndex = i;
                            [checkedArray addObject:[NSNumber numberWithBool:true]];
                        }
                        else
                            [checkedArray addObject:[NSNumber numberWithBool:false]];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.myTableView reloadData];

                    });
                    
                }
            }];
        }
            break;
        case TimeZone:{
            
            titlelbl.text = @"TimeZone";

            [[ApiController sharedManager] getTimeZone:@"SettingView" onLoginResponse:^(BOOL isloggedIn, NSData *responseResulr) {
                
                if (isloggedIn) {
                    NSError *jsonError;
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseResulr
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:&jsonError];
                    settingsData = [[json objectForKey:@"response"] objectForKey:@"data"];
                    
                    
                    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
                    NSString *timeZone = [standard objectForKey:AppTimeZoneKey];
                    
                    for (int i = 0; i < [settingsData count]; i++) {
                        
                        NSString *str = [settingsData objectAtIndex:i];
                        
                        if ([str isEqual:timeZone])
                        {
                            PreviousSelectedIndex = i;
                            selectedIndex = i;
                            [checkedArray addObject:[NSNumber numberWithBool:true]];
                        }
                        else
                            [checkedArray addObject:[NSNumber numberWithBool:false]];
                    }

                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.myTableView reloadData];
                        
                    });                    //simple array
                }
            }];
        }
            break;
        case Alarms:{
            
            titlelbl.text = @"Alarms";

            [[ApiController sharedManager] getAllAlarms:@"SettingView" onLoginResponse:^(BOOL isloggedIn, NSData *responseResulr) {
                
                if (isloggedIn) {
                    NSError *jsonError;
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseResulr
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:&jsonError];
                    settingsData = [[json objectForKey:@"response"] objectForKey:@"data"];
                    
                    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
                    NSDictionary *AppAlarm = [standard objectForKey:AppAlarmKey];
                    
                   
                    
                    for (int i = 0; i < [settingsData count]; i++) {
                        
                        if ([[settingsData objectAtIndex:i] isEqualToDictionary:AppAlarm]){
                            PreviousSelectedIndex = i;
                            selectedIndex = i;
                            [checkedArray addObject:[NSNumber numberWithBool:true]];
                        }
                        else
                            [checkedArray addObject:[NSNumber numberWithBool:false]];
                    }
                   
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.myTableView reloadData];
                        
                    });
                }
            }];
        }
            break;
            
        default:
            break;
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)backButtonPressed:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(IBAction)doneButtonPressed:(id)sender{
    
    switch (SettingsType) {
        case Language:{
            
            if (selectedIndex != PreviousSelectedIndex) {
                
                NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
                [standard setObject:[settingsData objectAtIndex:selectedIndex] forKey:AppLanguageKey];
                NSDictionary *dict = [settingsData objectAtIndex:selectedIndex];
                [ApiController sharedManager].userlang = [dict objectForKey:@"languageID"];
                
                [self.navigationController popViewControllerAnimated:YES];

            }
        }
            break;
        case SpeedMeter:{
            
            if (selectedIndex != PreviousSelectedIndex) {
                
                NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
               // NSArray *allkeys = [myDctionary allKeys];
                NSString *value = [NSString stringWithFormat:@"%d",(selectedIndex+1)];//[myDctionary objectForKey:[allkeys objectAtIndex:selectedIndex]];
                
                [standard setObject:value forKey:AppSpeedUnitKey];
                [standard synchronize];
                
                [ApiController sharedManager].speedUnit = value;
                
                [self.navigationController popViewControllerAnimated:YES];

            }
        }
            break;
        case TimeZone:{
            
            if (selectedIndex != PreviousSelectedIndex) {
                
                NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
                
                [standard setObject:[settingsData objectAtIndex:selectedIndex] forKey:AppTimeZoneKey];
                [standard synchronize];

                [ApiController sharedManager].speedUnit = [settingsData objectAtIndex:selectedIndex];
                
                [self.navigationController popViewControllerAnimated:YES];

            }
            
        }
            break;
        case Alarms:{
            
            if (selectedIndex != PreviousSelectedIndex) {
                
                NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
                [standard setObject:[settingsData objectAtIndex:selectedIndex] forKey:AppAlarmKey];
                [standard synchronize];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        default:
            break;
        }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    switch (SettingsType) {
        case SpeedMeter:
            return [[myDctionary allKeys] count];
            break;
            
        default:
            return [settingsData count];

            break;
    }
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"SettingsDetailCell";
    
    SettingsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        
        cell = [[SettingsDetailCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
        
    }
    if (SettingsType == Settings)
        cell.textlbl.text = [settingsData objectAtIndex:indexPath.row];
    else if (SettingsType == Language)
        cell.textlbl.text = [[settingsData objectAtIndex:indexPath.row] objectForKey:@"langName"];
    else if (SettingsType == SpeedMeter){
        
       NSArray *array = [myDctionary allKeys];
        cell.textlbl.text = [myDctionary objectForKey:[array objectAtIndex:indexPath.row]];
    }
    else if (SettingsType == TimeZone)
        cell.textlbl.text = [settingsData objectAtIndex:indexPath.row];
    else
        cell.textlbl.text = [[settingsData objectAtIndex:indexPath.row] objectForKey:@"alarmName"];
    
    if ([[checkedArray objectAtIndex:indexPath.row] boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;

    }
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    separatorLineView.backgroundColor = [UIColor clearColor]; // set color as you want.
    [cell.contentView addSubview:separatorLineView];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BOOL value = [[checkedArray objectAtIndex:indexPath.row] boolValue];
    
    value = !value;
    
    selectedIndex = (int)indexPath.row;
    
    for (int i = 0; i < [checkedArray count]; i++) {
        
        [checkedArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:false]];
        
    }
    
    [checkedArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool: value]];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.myTableView reloadData];
                                                                 

//    if (![checkedArray objectAtIndex:indexPath.row]) {
//        
//        SettingsDetailCell *cell = (SettingsDetailCell*)[tableView cellForRowAtIndexPath:indexPath];
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }
//    
//    for (int i = 0; i < [settingsData count]; i++) {
//        
//        if (i!= indexPath.row){
//            
//            [checkedArray addObject:[NSNumber numberWithBool:false]];
//            
//            if ([checkedArray objectAtIndex:i])
//            {
//                NSIndexPath *indexPa = [NSIndexPath indexPathForRow:i inSection:0];
//            }
//        }
//
//    }
//    
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
