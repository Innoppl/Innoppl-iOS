/*********************************************************************************
  File Name       : UserManager.h
  Created by      : Jagadeesh D
  Created on      : 27/10/11 
  Last edited by  : Jagadeesh D
  Last edited on  : Adding Location and checkin
  Last edited     : 03/11/11
  Purpose         : The file is the header file for user management. 

**********************************************************************************/

#import <Foundation/Foundation.h>

@class User;

@interface UserManager : NSObject 
{
	User *mUserObj;
	
	NSString *gmail_AccessToken;					// Need to append this Access_token to get gmail contact image
}

+ (UserManager *) sharedInstance;

#pragma mark -
#pragma mark Instance Methods
	//clear logged in user details once signout
- (void)clearLoggedInUser;

- (void)updateLoggedInUserWithDetails:(NSMutableDictionary *)inUserDetails;
- (User *)loggedInUser;
#pragma mark -

// setter/getter methods for gmail acces token
- (void)setGmailAccessToken:(NSString *)inAccessToken;
- (NSString *)gmailAccessToken;

// setter/getter methods for facebook credentials
- (void)setFacebookCredentials:(NSDictionary *)inCredentials;
- (NSDictionary *)facebookCredentials;

// setter/getter methods for twitter credentials
- (void)setTwitterCredentials:(NSDictionary *)inCredentials;
- (NSDictionary *)twitterCredentials;

// setter/getter methods for foursquare credentials
- (void)setFoursquareCredentials:(NSDictionary *)inCredentials;
- (NSDictionary *)foursquareCredentials;

// setter/getter methods for privacy settings
- (void)setPrivacySettings:(NSDictionary *)inSettings;
- (NSDictionary *)privacySettings;

// setter/getter methods for user current location
- (void)setUserLocation:(NSString *)inLocation;
- (NSString *)userCurrentLocation;

//setter/getter methods for last check-in venue
- (void)setLastCheckinVenue:(NSString *)inVenue;
- (NSString *)lastCheckinVenue;

@end
