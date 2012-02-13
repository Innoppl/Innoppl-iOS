/*********************************************************************************
  File Name       : UserManager.m
  Created by      : Jagadeesh D
  Created on      : 27/10/11 
  Last edited by  : Jagadeesh D
  Last edited on  : Adding Location and checkin
  Last edited     : 03/11/11
  Purpose         : The file is used for User related process which involves user's current location
                    and check in status.It also used for connecting user with social network sites for 
                    getting informations like friends,posts etc. 

**********************************************************************************/


#import "UserManager.h"
#import "User.h"

static UserManager *sharedInstance = nil;

@implementation UserManager

- (id) init
{
	self = [super init];
	if (self != nil) 
	{
		mUserObj	= [[User alloc] init];	
	}
	return self;
}


#pragma mark -
#pragma mark SingleTon Object Creation
//Creating a new instance Singleton
+(UserManager*)sharedInstance
{
	@synchronized(self) 
	{
		if (sharedInstance == nil)   // If there is no instance 
		{
			sharedInstance	= [[UserManager alloc] init]; 
		}
	}
	
	return sharedInstance;
}
//Creating new instance with the Zone
+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self) 
	{
		if (sharedInstance == nil) 
		{
			sharedInstance = [super allocWithZone:zone];
			
			return sharedInstance;  
		}
	}
	return nil; 
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}
// Incrementing the retain count
- (id)retain
{
	return self;
}
// getting the count
- (unsigned)retainCount
{
	return UINT_MAX;  
}
// releasing the allocated instance
- (void)release
{	
	sharedInstance = nil;
}

- (id)autorelease
{
	return self;
}

#pragma mark -
#pragma mark User Updation Methods
// Updating user object with the given data
- (void)updateLoggedInUserWithDetails:(NSMutableDictionary *)inUserDetails
{
	mUserObj.customerId = [inUserDetails objectForKey:kCustomerId];
	mUserObj.emailID	= [inUserDetails objectForKey:kEmailId];
	mUserObj.firstName	= [inUserDetails objectForKey:kFirstName];
	mUserObj.gender		= [inUserDetails objectForKey:kGender];
	mUserObj.lastName	= [inUserDetails objectForKey:kLastName];
	mUserObj.userId		= [[inUserDetails objectForKey:kUserId]intValue];
	mUserObj.zipCode	= [inUserDetails objectForKey:kZipCode];
	mUserObj.imageURL   = [inUserDetails objectForKey:kAvatharURL];
	mUserObj.lastCheckInVenue = [inUserDetails objectForKey:kLastCheckInVenue];
	mUserObj.eliteCount = [[inUserDetails objectForKey:kEliteCount] intValue];
	mUserObj.maxEliteCount = [[inUserDetails objectForKey:kMaxEliteCount] intValue];
	
	[USER_DEFAULTS setObject:mUserObj.customerId forKey:USER_DEFAULTS_LOGGEDIN_USER_CUSTOMER_ID];
	[USER_DEFAULTS synchronize];
}
//Getting the user currenly logged in
- (User *)loggedInUser
{
	return mUserObj;
}

#pragma mark -
#pragma mark Gmail Access Token
// Set User's Gmail access token
- (void)setGmailAccessToken:(NSString *)inAccessToken
{
	SAFE_RELEASE(gmail_AccessToken);
	
	gmail_AccessToken = [inAccessToken retain];
}
// getting the gmail access token
- (NSString *)gmailAccessToken
{
	return gmail_AccessToken;
}

#pragma mark -
#pragma mark Facebook access tokens
//Setting the facebook credentials
- (void)setFacebookCredentials:(NSDictionary *)inCredentials
{
	
	mUserObj.facebookCredentials = inCredentials;
}
- (NSDictionary *)facebookCredentials 
{
	
	return mUserObj.facebookCredentials;
}

#pragma mark -
#pragma mark Twitter access tokens
//Setter for Twitter credentails
- (void)setTwitterCredentials:(NSDictionary *)inCredentials 
{
	
	mUserObj.twitterCredentials = inCredentials;
}

- (NSDictionary *)twitterCredentials 
{
	
	return mUserObj.twitterCredentials;
}

#pragma mark -
#pragma mark Foursquare access tokens
//Setter for Foursquare credentials
- (void)setFoursquareCredentials:(NSDictionary *)inCredentials
{
	
	mUserObj.foursquareCredentials = inCredentials;
}

- (NSDictionary *)foursquareCredentials
{
	
	return mUserObj.foursquareCredentials;
}

#pragma mark -
#pragma mark Privacy settings
//Privacy settings
- (void)setPrivacySettings:(NSDictionary *)inSettings 
{
	
	mUserObj.privacySettings = inSettings;
}

- (NSDictionary *)privacySettings
{
	
	return mUserObj.privacySettings;
}

#pragma mark -
#pragma mark Setting User Location
//User Location setter and getter
- (void)setUserLocation:(NSString *)inLocation
{
	mUserObj.currentCity = inLocation;
}

- (NSString *)userCurrentLocation
{
	return mUserObj.currentCity;
}

#pragma mark -
#pragma mark Setting last check-in venue name
//Last Checked in venue
- (void)setLastCheckinVenue:(NSString *)inVenue
{
	mUserObj.lastCheckInVenue = inVenue;
}

- (NSString *)lastCheckinVenue
{
	return mUserObj.lastCheckInVenue;
}

#pragma mark -
#pragma mark Clear User Object - Signout
// Removing user data for making the user  signingout
- (void)clearLoggedInUser
{
	mUserObj.firstName = nil;
	mUserObj.lastName = nil;
	mUserObj.emailID = nil;
	mUserObj.password = nil;
	mUserObj.confirmPwd = nil;
	mUserObj.gender = nil;
	mUserObj.zipCode = nil;
	mUserObj.imageURL = nil;
	mUserObj.privacySettings = nil;
	mUserObj.facebookCredentials = nil;
	mUserObj.foursquareCredentials = nil;
	mUserObj.twitterCredentials = nil;
	mUserObj.currentCity = nil;
	mUserObj.lastCheckInVenue = nil;
	
	[USER_DEFAULTS removeObjectForKey:USER_DEFAULTS_COOKIES_KEY];
	[USER_DEFAULTS removeObjectForKey:USER_DEFAULTS_LOGGEDIN_USER_CUSTOMER_ID];
	[USER_DEFAULTS synchronize];
}

#pragma mark -
#pragma mark Dealloc

- (void) dealloc
{
	SAFE_RELEASE(mUserObj);
	
	SAFE_RELEASE(gmail_AccessToken);
	
	[super dealloc];
}


@end