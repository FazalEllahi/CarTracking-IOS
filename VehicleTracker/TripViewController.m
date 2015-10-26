//
//  MonitorVehiclesController.m
//  VehicleTracker
//
//  Created by fazal on 9/19/15.
//  Copyright (c) 2015 Fazal Ellahi. All rights reserved.
//

#import "TripViewController.h"
#import "MonitorVehiclesCell.h"
#import "ApiController.h"
#import "MonitorVehicleDetailView.h"
#import "FrontViewController.h"
#import "RoutReplyViewController.h"
#import "ReplyViewController.h"
#import "MBProgressHUD.h"

@interface TripViewController (){
    NSArray *dictfonts;
    NSArray *tableData;

}

@end

@implementation TripViewController

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
    tableData = [self.VehicleData mutableCopy];
    [myTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableData = [[NSArray alloc] init];
    
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
    
    

    tableData = [self.VehicleData mutableCopy];

    [myTableView reloadData];

   
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
    
    [cell.stopCarBtn setHidden:YES];
    
    cell.textlbl.attributedText =[self getCellAttributedText:[tableData objectAtIndex:indexPath.row]];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FrontViewController *newFrontController = nil;
    
    {
        newFrontController = [[FrontViewController alloc] init];
        newFrontController.TripDictionary = [self.VehicleData objectAtIndex:indexPath.row];
    }
    
    
    [self.navigationController pushViewController:newFrontController animated:YES];
    

}

-(NSAttributedString*)getCellAttributedText:(NSDictionary*)text{
    
    text = [text objectForKey:[[text allKeys] objectAtIndex:0]];
    
    NSArray *dictWord = @[[NSString stringWithFormat:@"startTime : %@",[text objectForKey:@"startTime"]],
                          [NSString stringWithFormat:@"endTime : %@",[text objectForKey:@"endTime"]],
                          [NSString stringWithFormat:@"averageSpeed : %0.3f %@",[[text objectForKey:@"averageSpeed"] floatValue],[_lablesData objectForKey:@"speedUnit"]],
                          [NSString stringWithFormat:@"driveTime : %0.3f",[[text objectForKey:@"driveTime"]floatValue]],
                          [NSString stringWithFormat:@"distanceTravel : %@",[text objectForKey:@"distanceTravel"]]];
        
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