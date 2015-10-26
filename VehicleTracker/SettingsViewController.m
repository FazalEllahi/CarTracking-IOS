//
//  SettingsViewController.m
//  VehicleTracker
//
//  Created by fazal on 9/22/15.
//  Copyright (c) 2015 Fazal Ellahi. All rights reserved.
//

#import "SettingsViewController.h"
#import "ApiController.h"
#import "SettingsViewCell.h"
#import "SettingsDetailViewController.h"


@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize myTableView;
@synthesize settingsData;
@synthesize SettingsType;
@synthesize titlelbl;
@synthesize backBtn;
@synthesize adelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTableView.tableFooterView = [[UIView alloc] init];
    settingsData = [[NSMutableArray alloc] init];
          // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    
    [[ApiController sharedManager] getAllLabels:@"settings" onLoginResponse:^(BOOL isloggedIn, NSData *responseResulr) {
        if (!isloggedIn) {
            return ;
        }
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseResulr
                                                             options:NSJSONReadingMutableContainers
                                                               error:&jsonError];
        
        NSDictionary *dict = [[json objectForKey:@"response"] objectForKey:@"data"];
        
        [_titleLabel setText:[dict objectForKey:@"pageTitle"]];
        NSArray *allkeys = @[@"language",@"timeZone",@"SpeedMeter",@"Alarms",@"signOutLink"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            for (UILabel *key in allkeys) {
                
                [settingsData addObject:[dict objectForKey:key]];
                
                
            }
            [self.myTableView reloadData];
            
        });
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)backButtonPressed:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(IBAction)doneButtonPressed:(id)sender{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [settingsData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"SettingsCell";
    
    SettingsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        
        cell = [[SettingsViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
        
    }
    if (SettingsType == Settings)
        cell.textlbl.text = [settingsData objectAtIndex:indexPath.row];
     else
        cell.textlbl.text = [[settingsData objectAtIndex:indexPath.row] objectForKey:@"langName"];
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    separatorLineView.backgroundColor = [UIColor clearColor]; // set color as you want.
    [cell.contentView addSubview:separatorLineView];
   

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 4) {
        
     //   if ([self respondsToSelector:@selector(SettingsViewControler:didSelectSignoutSelector:)]) {
            [self.adelegate SettingsViewControler:self didSelectSignoutSelector:YES];
     //   }
    }
    else{
        
        SettingsDetailViewController *settingsView = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]
                                                      instantiateViewControllerWithIdentifier:@"SettingsDetailViewController"];
        settingsView.SettingsType = indexPath.row+1;
        settingsView.titlelbl = [settingsData objectAtIndex:indexPath.row];
        NSLog(@"%ld",indexPath.row);
        [self.navigationController pushViewController:settingsView animated:YES];
    }

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
