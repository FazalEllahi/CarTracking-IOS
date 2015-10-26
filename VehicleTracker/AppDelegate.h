//
//  AppDelegate.h
//  VehicleTracker
//
//  Created by Iftikhar on 05/09/2015.
//  Copyright (c) 2015 Fazal Ellahi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ReplyViewController.h"
@class SWRevealViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) SWRevealViewController *viewController;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableDictionary *loginData;
@property (strong, nonatomic) NSMutableArray *TripData;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)setUpSideBarController;
-(void)getAllTripInformationDorView:(ReplyViewController*)view startDate:(NSString*)fromDate endDate:(NSString*)toDate withtrackerid:(NSString*)trackerID;
+ ( AppDelegate *)sharedAppDelegate;
- (NSString *) getPlistFilePath;
-(void)SaveFileToPlist;

@end

