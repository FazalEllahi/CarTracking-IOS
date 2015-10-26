//
//  ApiController.h
//  VehicleTracker
//
//  Created by Iftikhar on 09/09/2015.
//  Copyright (c) 2015 Fazal Ellahi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define AppLanguageKey @"AppLanguage"
#define AppSpeedUnitKey @"AppSpeedUnit"
#define AppTimeZoneKey @"AppTimeZone"
#define AppAlarmKey @"AppAlarms"


#define AppUserID @"UserID"
#define loginApiUrl @"http://althuraya-usa.com/trackApp/logins.php?"
#define infoApiUrl @"http://althuraya-usa.com/trackApp/companyInfo.php?securityKey=a85hkrwm20jj584e@df6!km&lang=1&request=info"
#define allVehiclesUrl @"http://althuraya-usa.com/trackApp/getAllVehicles.php?"
#define contactUsUrl @"http://althuraya-usa.com/trackApp/contactUS.php?"
#define languageListUrl @"http://althuraya-usa.com/trackApp/getLanguages.php?"
#define speedMeterUrl @"http://althuraya-usa.com/trackApp/getSpeedMeter.php?"
#define TimeZoneListUrl @"http://althuraya-usa.com/trackApp/getTimeZone.php?"
#define AlarmsListUrl @"http://althuraya-usa.com/trackApp/getAlarms.php?"
#define labelsListUrl @"http://althuraya-usa.com/trackApp/getLabels.php?"
#define VehicleTripsUrl @"http://althuraya-usa.com/trackApp/getVehicleTrips.php?"
#define SwitchCarUrl @"http://www.althuraya-usa.com/trackApp/doAction.php?"

@interface ApiController : NSObject

@property(strong,nonatomic)NSString *securityKey;
@property(strong,nonatomic)NSString *userID;
@property(strong,nonatomic)NSDictionary *userlang;
@property(strong,nonatomic)NSString *speedUnit;
@property(strong,nonatomic)NSString *timeZone;



+(ApiController *)sharedManager;

@property (nonatomic, copy) void (^onRequestFinshed)(NSData *responseResulr);
@property (nonatomic, copy) void (^onRequestFailed)(NSString *errorString);


@property (nonatomic, copy) void (^onloginRequestCompleted)(BOOL isloggedIn, NSData *responseResulr);

-(void)loginUserWithUserName:(NSString*)userName andPassword:(NSString*)password onLoginResponse:(void (^)(BOOL isloggedIn, NSData *responseResulr))loginResponse;

-(void)submitContactData:(NSString*)userName Phone:(NSString*)phone Email:(NSString*)email Subject:(NSString*)subject Message:(NSString*)message onLoginResponse:(void (^)(BOOL isloggedIn, NSData *responseResulr))loginResponse;

- (BOOL)isSessionAlive;
- (BOOL)prepareForLogout;


-(void)getAllVehivlesData:(NSString*)UserID onLoginResponse:(void (^)(BOOL isloggedIn, NSData *responseResulr))loginResponse;
-(void)getLanguageList:(NSString*)userId onLoginResponse:(void (^)(BOOL isloggedIn, NSData *responseResulr))loginResponse;
-(void)getSpeedMeter:(NSString*)userId onLoginResponse:(void (^)(BOOL isloggedIn, NSData *responseResulr))loginResponse;
-(void)getTimeZone:(NSString*)userId onLoginResponse:(void (^)(BOOL isloggedIn, NSData *responseResulr))loginResponse;
-(void)getAllAlarms:(NSString*)userId onLoginResponse:(void (^)(BOOL isloggedIn, NSData *responseResulr))loginResponse;
-(void)getAllLabels:(NSString*)userId onLoginResponse:(void (^)(BOOL isloggedIn, NSData *responseResulr))loginResponse;
-(void)PostSwitchOnOff:(NSString*)Action trackerId:(NSString*)trackID onLoginResponse:(void (^)(BOOL isloggedIn, NSData *responseResulr))loginResponse;
-(void)getCompanyInfoData:(NSString*)userId onLoginResponse:(void (^)(BOOL isloggedIn, NSData *responseResulr))loginResponse;
-(void)getVehicleTrips:(NSString*)DateRange withtrackerid:(NSString*)trackerID onLoginResponse:(void (^)(BOOL isloggedIn, NSData *responseResulr))loginResponse;
-(void)getVehicleTripRange:(NSString*)DateRange withtrackerid:(NSString*)trackerID onLoginResponse:(void (^)(BOOL isloggedIn, NSData *responseResulr))loginResponse;
@end
