/*********************************************************************************
  File Name       : AddFriend.h
  Created by      : Jagadeesh D
  Created on      : 27/10/11 
  Last edited by  : Jagadeesh D
  Last edited on  : Adding new Connections
  Last edited     : 09/11/11
  Purpose         : The file is used for Adding new connections. 

**********************************************************************************/

#import "AddFriend.h"

@implementation AddFriend

@synthesize uid = mFriendVengaId;
@synthesize emailID = mFriendEmailID;
@synthesize friendStatus = mFriendStatus;
@synthesize name = mFriendName;
@synthesize profile_url = mFriendImageURL;
@synthesize isSelected = mIsSelected;
// Intialising a new instance with the Dictionary
- (id)initWithFriend:(NSDictionary *)inFriendDict state:(BOOL)isSelected {
	
	if(self = [super init]) {
		
		self.uid = [inFriendDict objectForKey:kUserId];
		self.emailID = [inFriendDict objectForKey:kFriendEmailId];
		self.friendStatus = [[inFriendDict objectForKey:kFriendRequestState] intValue];
		self.name = [inFriendDict objectForKey:kFriendName];
		self.profile_url = [inFriendDict objectForKey:kProfileURL];
		self.isSelected = isSelected;
	}
	return self;
}

//Default initialiser with NSCoder
-(id)initWithCoder:(NSCoder*)aDecoder
{
	self = [super init];
    if (self) {
		
		self.uid			= [aDecoder decodeObjectForKey:kUserId];
		self.emailID		= [aDecoder decodeObjectForKey:kFriendEmailId];
		self.friendStatus	= [aDecoder decodeIntegerForKey:kFriendRequestState];
		self.name			= [aDecoder decodeObjectForKey:kFriendName];
		self.profile_url	= [aDecoder decodeObjectForKey:kProfileURL];
		
		self.isSelected		= [aDecoder decodeBoolForKey:@"isSelected"];
    }
    return self;
}
//Encoding 
- (void)encodeWithCoder:(NSCoder*)inCoder
{
	[inCoder encodeObject:self.uid forKey:kUserId];
	[inCoder encodeObject:self.emailID forKey:kFriendEmailId];
	[inCoder encodeInteger:self.friendStatus forKey:kFriendRequestState];
	[inCoder encodeObject:self.name forKey:kFriendName];
	[inCoder encodeObject:self.profile_url forKey:kProfileURL];
	
	[inCoder encodeBool:self.isSelected forKey:@"isSelected"];
}

//Overriding the description
- (NSString *)description {
	
	return [NSString stringWithFormat:@"[friend name = %@]::[friend id is %@]::[friend email id is %@]::[Is Selected = %d]", self.name, self.uid, self.emailID, self.isSelected];
}

- (void)dealloc {
	
	self.uid = nil;
	self.emailID = nil;
	self.name = nil;
	self.profile_url = nil;
	[super dealloc];
}

@end