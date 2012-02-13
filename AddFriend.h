/*********************************************************************************
  File Name       : AddFriend.h
  Created by      : Jagadeesh D
  Created on      : 27/10/11 
  Last edited by  : Jagadeesh D
  Last edited on  : Adding new Connections
  Last edited     : 08/11/11
  Purpose         : The file is the header file for Adding new connections. 

**********************************************************************************/

#import <Foundation/Foundation.h>

@interface AddFriend : NSObject<NSCoding>
{
	NSString *mFriendVengaId;
	NSString *mFriendEmailID;
	short mFriendStatus;			//three cases 0:Add 1:Pending 2:Rejected
	NSString *mFriendName;
	NSString *mFriendImageURL;
	
	BOOL mIsSelected;				//Used to check the cell with right mark or not
}

@property (nonatomic, retain) NSString *uid;
@property (nonatomic, retain) NSString *emailID;
@property (nonatomic, assign) short friendStatus;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *profile_url;
@property (nonatomic, assign) BOOL isSelected;

	//Initialize object method
- (id)initWithFriend:(NSDictionary *)inFriendDict state:(BOOL)isSelected;

@end