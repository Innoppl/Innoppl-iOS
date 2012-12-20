//
//  AddSubItem.h
//  I am eating
// add subitems of the items
//  Created by Innoppl Technologies on 27/05/10.
//  Copyright 2010 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sqlite.h"
#import "ItemTableView.h"

@interface AddSubItem : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate> {
	// Outlet UI objects
	IBOutlet UITextField *categoryId;
	IBOutlet UITextField *subitem;
	IBOutlet UITextField *subitemProtein;
	IBOutlet UITextField *subitemCarbohydrates;
	IBOutlet UITextField *subitemFat;
	IBOutlet UITextField *subitemCalorie;
	IBOutlet UITextField *textfield ;
	
	IBOutlet UILabel *headerlbl;
	IBOutlet UILabel *lblFat;
	IBOutlet UILabel *lblProtin;
	IBOutlet UILabel *lblCarbo;
	IBOutlet UILabel *lblmainItem;
	
	IBOutlet UIScrollView *SignUpScrollView;
	
	IBOutlet UIPickerView *pickerview ;
	IBOutlet UILabel *mlabel ;
		IBOutlet UIToolbar *toolbar;

	// Misc objects
	NSMutableDictionary *tempDic;
	NSString *tmpStr;
	NSXMLParser *myXMLParser;
	NSMutableData *myWebData;
	int itemid;
	NSString *callweb1, *fetchsub1, *fetchsub2, *fetchsub3, *fetchsub4, *fetchsub5, *fetchsub6,*fetchsub21,*fetchsub22,*fetchsub23,*fetchsub24 ;
	NSMutableArray *newData1, *arrayNo ;
	NSMutableDictionary *tempDic1;

	NSString *mydb;
	Sqlite *sqlite;
	int newItemid;
    
    ItemTableView *searchObj ;
	
	// Database variables
	NSString *databaseName;
	NSString *databasePath;
}
@property(nonatomic,retain)NSString *callweb1, *fetchsub1, *fetchsub2, *fetchsub3, *fetchsub4, *fetchsub5, *fetchsub6,*fetchsub9,*fetchsub10,*fetchsub11,*fetchsub12 ;
@property(nonatomic, retain) UILabel *mlabel ;
@property(nonatomic, retain) NSMutableArray *arrayNo;
@property(nonatomic,nonatomic)int itemid;
@property(nonatomic, retain) UITextField *subitem ;
@property(nonatomic, assign) int newItemid ;

-(IBAction) Btnback:(id)sender;  // pop to prev view
-(IBAction) Btnsubmit:(id)sender; // validate add fields
-(IBAction) Btnno:(id)sender; 
-(IBAction) btnOkClicked:(id)sender;
-(IBAction) btnCancelClicked:(id)sender;
- (NSString*)convertEntities:(NSString*)string;
-(void)callWebInsert;    // call webservices to save data
-(void)SaveData:(int)categoryid: (NSString *)category_name: (int)subitemdetail_id: (NSString *)subitem_name: (float)protein: (float)carbohydrates: (float)fat: (float)calorie;

-(IBAction) Btniclicked:(id)sender; // show about us view
@end
