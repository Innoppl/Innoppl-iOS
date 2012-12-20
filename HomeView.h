//
//  HomeView.h
//  I am eating
// Home page 
//  Created by Innoppl Technologies on 24/05/10.

//

#import <UIKit/UIKit.h>
#import "CategoryView.h"
#import "categoryNew.h"
#import "ReportView.h"
#import "MainReport.h"
#import "Sqlite.h"
#import "RefreshData.h"

@interface HomeView : UIViewController <UIActionSheetDelegate> {
	// Outlates UI objects
	IBOutlet UILabel *currentdate;
    IBOutlet UILabel *headerDate ;
	
	//RefreshData *dataRefresh;
	
	//class objects
	categoryNew *nxtcategoryview;
	ReportView *nxtreportview;
    MainReport *mainreportview;
	
	//Pickerview objects
	UIActionSheet *pickerViewPopup;
	UIDatePicker *theDatePicker;
	UIToolbar *pickerDateToolbar; // toolbare for the pickerview
	
	// Database variables
	NSString *databaseName;
	NSString *databasePath;
	
	//NSString *mydb;
	Sqlite *sqlite;
	
	// NSXML oobject
	NSXMLParser *myXMLParser;
	
	// Misc objects
	NSMutableDictionary *tempDic,*tempDicSubItem, *tempDicCatId;
	NSString *tmpStr,*tmpSubStr;
	BOOL checkItem;
	NSMutableData *myWebData;
	NSMutableArray *ItemArray,*CategoryDetailArray, *CategoryIdArray;
	NSMutableArray *subItem1Array,*subItem2Array,*subItem3Array,*subItem4Array,*subItemArray,*subItem5Array,*subItem6Array, *subItem7Array,*subItemnewArray1,*subItemnewArray2,*subItemnewArray3,*subItemnewArray4;
	NSMutableArray *item;
	NSMutableArray *subitem;
	NSMutableArray *Quantity;
	NSString *Selected;
	NSMutableArray *ItemEditArray;
	NSInteger btntagVal,itemrow,subitemrow, subitemrowblank;
	int k,itemid,typid,subitems,sublabel,itemsel,btnitem,SubItemId,SubItem1Id,SubItem2Id,SubItem3Id,SubItem4Id,SubItem5Id,SubItem6Id;
	int p,c,f,pe,catId,userid,modifyVal,Category_Id,CategoryDetail_Id,updateval,SubItemCnt;
	NSString *imageFlag;
	NSString *count1;
	NSString *catIdFlag, *tmpCatId ;
	NSMutableArray *addedsubitems;
	
	BOOL addFlag,overrideFlag;
	BOOL callSunItem,calladdservice;
	BOOL isMainItem,isSubItem,isInsertItem;
	int con;
	BOOL editnavigation;
	NSString *forwhichWebservice;
	NSMutableDictionary *selectedItemsRow;
	NSMutableDictionary* plistDict;
	NSString *DataPath ;
	NSDateFormatter *formateDate1;
	NSMutableArray *ItemAddInfo;
	NSMutableArray *tempArray;
    IBOutlet UIButton *reportBtn;
}

//// ----
-(NSString *)GetDateFromString: (NSString *)stringDate ;
-(void)showDatePickerView;  // Picker view Method
-(void)dateChange;  // nil 
-(void)loadDB;
-(void)callWebService;
-(void)GetSubItemRecordByCategoryList;
-(void)SaveData:(int)categoryid: (NSString *)category_name: (int)subitemdetail_id: (NSString *)subitem_name: (float)protein: (float)carbohydrates: (float)fat: (float)calorie: (NSString *)updated_date ;


// Outlets action
-(IBAction) btnFromDate:(id)sender;   // show picker view when click on date 
-(IBAction) Btnbreakfast:(id)sender; 
-(IBAction) Btnlunch:(id)sender;
-(IBAction) Btndinner:(id)sender;
-(IBAction) Btnother:(id)sender;
-(IBAction) Btnreport:(id)sender;
-(IBAction) Btnweeklyreport:(id)sender;
-(IBAction) Btnmonthlyreport:(id)sender;
-(IBAction) Btniclicked:(id)sender;
-(IBAction) BtnLoad:(id)sender;

//class Method
+(int)getID;
+(void)setID:(int)idid;

@end
