//
//  HomeView.m
//  I am eating
// Home page 
//  Created by Innoppl Technologies on 24/05/10.
//  Copyright 2010 mac. All rights reserved.

//  Home page 

#import "HomeView.h"
#import "Innoppl.h"
#import <QuartzCore/QuartzCore.h>
@implementation HomeView

//class global variables
int id1;

NSMutableDictionary *GlobalInfo;
NSArray *resultset, *itemset ;
NSMutableArray *newitemset;
NSMutableArray *myDbArray;
NSMutableArray *tempDBArray ;

UIAlertView *alert ;
UIActivityIndicatorView *progress;
NSString *viewload, *setReportFlag ;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    reportBtn.layer.cornerRadius=12.0f;
	//SQLite DB 
	databaseName = @"imeating.sql";
	
	
	// Get the path to the documents directory and append the databaseName
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	
	setReportFlag = @"False" ;
	[[I_am_eatingAppDelegate getGlobalInfo]setObject:[NSString stringWithFormat:@"%@", setReportFlag] forKey:@"gReportFlag"];
	
	sqlite=[[Sqlite alloc] init];
	[sqlite open:databasePath];
	
	
	userid = [[[I_am_eatingAppDelegate getGlobalInfo] objectForKey:@"logininfo"]intValue];
	
	
	con=0;
	p = 0;
	c = 0;
	f = 0;
	k = 0;
	callSunItem = FALSE;
	SubItemCnt = 0;
	calladdservice = FALSE;
	itemrow = 0;
	itemsel = 0;
	sublabel = 0;
	subitemrow = 0;
	Category_Id = 0;
	CategoryDetailArray = nil;
	addFlag = FALSE;
	catIdFlag = @"NO";
	checkItem = FALSE;
	forwhichWebservice = [[NSString alloc]init];
	
	tmpStr = [[NSString alloc] init];
	tempDic = [[NSMutableDictionary alloc]init];
	selectedItemsRow = [[NSMutableDictionary alloc]init];
	
	addedsubitems = [[NSMutableArray alloc]init];
	subItem1Array =[[NSMutableArray alloc] init];
	subItem2Array =[[NSMutableArray alloc] init];
	subItem3Array =[[NSMutableArray alloc] init];
	subItem4Array =[[NSMutableArray alloc] init];
	subItem5Array =[[NSMutableArray alloc] init];
	subItem6Array =[[NSMutableArray alloc] init];
	subItem7Array =[[NSMutableArray alloc] init];
    subItemnewArray1=[[NSMutableArray alloc] init];
    subItemnewArray2=[[NSMutableArray alloc] init];
    subItemnewArray3=[[NSMutableArray alloc] init];
    subItemnewArray4=[[NSMutableArray alloc] init];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	 NSString *documentsDirectory = [paths objectAtIndex:0];
	 NSString *DataPath = [documentsDirectory stringByAppendingPathComponent:@"Login.plist"];
	plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:DataPath];
	 
	
	
	formateDate1=[[[NSDateFormatter alloc]init] autorelease];
	[formateDate1 setDateFormat:@"MM/dd/yyyy"];
	
	
	btnitem = 0;
	
	alert = [[UIAlertView alloc] initWithTitle:@"Loading main items and all sub items" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	progress= [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 50, 30, 30)];
	progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	[alert addSubview:progress];
    
    [self GetDateFromString:@"01/10/2011"];
	//[sqlite executeQuery:@"delete from subitem_detail"];
	//[self loadDB];
	
	
	
	NSDate* date = [NSDate date];
	NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"MMM dd,yyyy"];
	NSString* str = [formatter stringFromDate:date];
	[currentdate setText:str];
	[[I_am_eatingAppDelegate getGlobalInfo]setObject:[NSString stringWithFormat:@"%@", str] forKey:@"selecteddate"];
    [headerDate setText:[[I_am_eatingAppDelegate getGlobalInfo]objectForKey:@"selecteddate"]] ;
}
- (void)viewWillAppear:(BOOL)animated {
	[AlertHandler hideAlert];
	((I_am_eatingAppDelegate*)[[UIApplication sharedApplication]delegate]).newData=nil;
	((I_am_eatingAppDelegate*)[[UIApplication sharedApplication]delegate]).newData=[[NSMutableArray alloc]init];
	
	setReportFlag = @"False" ;
	[[I_am_eatingAppDelegate getGlobalInfo]setObject:[NSString stringWithFormat:@"%@", setReportFlag] forKey:@"gReportFlag"];
    [headerDate setText:[[I_am_eatingAppDelegate getGlobalInfo]objectForKey:@"selecteddate"]] ;
	
}

-(NSString *)GetDateFromString: (NSString *)stringDate {
    
    NSDateFormatter *formateDate1=[[[NSDateFormatter alloc]init] autorelease];
	[formateDate1 setDateFormat:@"MM/dd/yyyy"];
	
	NSDateFormatter *formateDate2=[[[NSDateFormatter alloc]init] autorelease];
	[formateDate2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	
    
	NSDate *date1 = [formateDate1 dateFromString:stringDate];
	
	
	NSString *date2 = [formateDate2 stringFromDate:date1];
    
   // NSLog(@"Print string date2 : %@", date2);
    
    return date2 ;
    
}

#pragma mark class method to get set ID
+(int)getID{
	return id1;
}

+(void)setID:(int)idid{
	id1 = idid;
}
#pragma mark 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)dealloc {
    [super dealloc];
}

#pragma mark OUtlets Actions
// Push to add breakfast category page
-(IBAction) Btnbreakfast:(id)sender{
	id1=1;
	[[I_am_eatingAppDelegate getGlobalInfo] setObject:@"0" forKey:@"updateoption"];
	[[I_am_eatingAppDelegate getGlobalInfo] setObject:@"0" forKey:@"typid"];

	nxtcategoryview = [[CategoryView alloc]initWithNibName:@"CategoryView" bundle:nil];
	[self.navigationController pushViewController:nxtcategoryview animated:YES];
	[nxtcategoryview release];
}

// Push to add lunch category page
-(IBAction) Btnlunch:(id)sender{
	id1=2;
	[[I_am_eatingAppDelegate getGlobalInfo] setObject:@"0" forKey:@"updateoption"];
	[[I_am_eatingAppDelegate getGlobalInfo] setObject:@"0" forKey:@"typid"];
	nxtcategoryview = [[CategoryView alloc]initWithNibName:@"CategoryView" bundle:nil];
	[self.navigationController pushViewController:nxtcategoryview animated:YES];
	[nxtcategoryview release];
}
// Push to add dinner category page
-(IBAction) Btndinner:(id)sender{
	id1=3;
	[[I_am_eatingAppDelegate getGlobalInfo] setObject:@"0" forKey:@"updateoption"];
	[[I_am_eatingAppDelegate getGlobalInfo] setObject:@"0" forKey:@"typid"];
	nxtcategoryview = [[CategoryView alloc]initWithNibName:@"CategoryView" bundle:nil];
	[self.navigationController pushViewController:nxtcategoryview animated:YES];
	[nxtcategoryview release];
}

// Push to add other category page
-(IBAction) Btnother:(id)sender{
	id1=4;
	[[I_am_eatingAppDelegate getGlobalInfo] setObject:@"0" forKey:@"updateoption"];
	[[I_am_eatingAppDelegate getGlobalInfo] setObject:@"0" forKey:@"typid"];
	nxtcategoryview = [[CategoryView alloc]initWithNibName:@"CategoryView" bundle:nil];
	[self.navigationController pushViewController:nxtcategoryview animated:YES];
	[nxtcategoryview release];
}

// Push to report page
-(IBAction) Btnreport:(id)sender{
	
    [[I_am_eatingAppDelegate getGlobalInfo] setObject:@"0" forKey:@"updateoption"];
	[[I_am_eatingAppDelegate getGlobalInfo] setObject:@"0" forKey:@"typid"];
	mainreportview = [[MainReport alloc]initWithNibName:@"MainReport" bundle:nil];
    mainreportview.whichToLoad=[NSString stringWithFormat:@"Weekly"] ;
    mainreportview.fromWhichView=[NSString stringWithFormat:@"home"] ;
	[self.navigationController pushViewController:mainreportview animated:YES];
	[mainreportview release];
}

//Push to daily report view
-(IBAction) Btnweeklyreport:(id)sender {
    [[I_am_eatingAppDelegate getGlobalInfo] setObject:@"0" forKey:@"updateoption"];
	[[I_am_eatingAppDelegate getGlobalInfo] setObject:@"0" forKey:@"typid"];
	mainreportview = [[MainReport alloc]initWithNibName:@"MainReport" bundle:nil];
    mainreportview.whichToLoad=[NSString stringWithFormat:@"Weekly"] ;
    mainreportview.fromWhichView=[NSString stringWithFormat:@"home"] ;
	[self.navigationController pushViewController:mainreportview animated:YES];
	[mainreportview release];
}

//Push to weekly report view
-(IBAction) Btnmonthlyreport:(id)sender {
    [[I_am_eatingAppDelegate getGlobalInfo] setObject:@"0" forKey:@"updateoption"];
	[[I_am_eatingAppDelegate getGlobalInfo] setObject:@"0" forKey:@"typid"];
	mainreportview = [[MainReport alloc]initWithNibName:@"MainReport" bundle:nil];
    mainreportview.whichToLoad=[NSString stringWithFormat:@"Monthly"] ;
    mainreportview.fromWhichView=[NSString stringWithFormat:@"home"] ;
	[self.navigationController pushViewController:mainreportview animated:YES];
	[mainreportview release];
}

-(IBAction)btnFromDate:(id)sender{
	[self showDatePickerView];
}

-(IBAction)BtnLoad:(id)sender{
	
	
	RefreshData *dataRefresh = [[RefreshData alloc]  getWebservice:@"" gView:self.view];
	
}

//Push to About us page
-(IBAction) Btniclicked:(id)sender{
	Innoppl *ObjInnoppl = [[Innoppl alloc]initWithNibName:@"Innoppl" bundle:nil];
	[self.navigationController pushViewController:ObjInnoppl animated:YES];
	[ObjInnoppl release];
}

#pragma mark show pickerview 
-(void)showDatePickerView{
	NSDateFormatter *FormatDate = [[[NSDateFormatter alloc] init] autorelease];
	//[FormatDate setDateFormat:@"MMMM d y"];
	[FormatDate setDateFormat:@"MMMM dd yy"];
		
	pickerViewPopup = [[UIActionSheet alloc] initWithTitle:@"Select Expire Date"
												  delegate:self
										 cancelButtonTitle:nil
									destructiveButtonTitle:nil
										 otherButtonTitles:nil];
	
	theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
	theDatePicker.datePickerMode =UIDatePickerModeDate;
	theDatePicker.minimumDate=[NSDate date];
	NSTimeInterval secondsPerDay = 24 * 60 * 60;
	NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
	theDatePicker.maximumDate=tomorrow;
	//theDatePicker.minimumDate=[NSDate date];
	[theDatePicker addTarget:self action:@selector(dateChange) forControlEvents:UIControlEventValueChanged];
	pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	pickerDateToolbar.tintColor=[UIColor blackColor];
	
	[pickerDateToolbar sizeToFit];
	
	NSMutableArray *barItems = [[NSMutableArray alloc] init];
	
	UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	[barItems addObject:flexSpace];
	[flexSpace release];
	
	UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DatePickerDoneClick)];
	[barItems addObject:doneBtn];
	[doneBtn release];
	
	[pickerDateToolbar setItems:barItems animated:YES];
	
	[pickerViewPopup addSubview:pickerDateToolbar];
	[pickerViewPopup addSubview:theDatePicker];
	[pickerViewPopup showInView:self.view];
	[pickerViewPopup setBounds:CGRectMake(0,0,320, 464)];
	
	[pickerDateToolbar release];
	[theDatePicker release];
	[pickerViewPopup release];
	
}
-(void)dateChange
{
}
-(void)DatePickerDoneClick
{
	NSDateFormatter *FormatDate = [[[NSDateFormatter alloc] init] autorelease];
	[FormatDate setDateFormat:@"MMMM d y"];

	NSString *date1=[FormatDate stringFromDate:[theDatePicker date]];
	NSString *today=[FormatDate stringFromDate:[NSDate date]];
	NSTimeInterval secondsPerDay = 24 * 60 * 60;
	NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
	NSString *tommorow=[FormatDate stringFromDate:tomorrow];
	[pickerViewPopup dismissWithClickedButtonIndex:0 animated:YES];
	if ([date1 isEqualToString:today]||[date1 isEqualToString:tommorow] ) {
		NSDateFormatter *FormatDate = [[[NSDateFormatter alloc] init] autorelease];
		[FormatDate setDateFormat:@"MMM dd,yyyy"];
		currentdate.text = [FormatDate stringFromDate:[theDatePicker date]];
		
		[[I_am_eatingAppDelegate getGlobalInfo]setObject:[NSString stringWithFormat:@"%@", [FormatDate stringFromDate:[theDatePicker date]]] forKey:@"selecteddate"];
        [headerDate setText:[[I_am_eatingAppDelegate getGlobalInfo]objectForKey:@"selecteddate"]] ;
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wrong Date Selected" 
														message:@"Please select Today Or Tommorow Date !!!" 
													   delegate:self cancelButtonTitle:@"Ok" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

#pragma mark Alerview delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	[self showDatePickerView];
}

#pragma mark load the data base with a search items
-(void) loadDB {
	
	//NSLog(@"load ");
	[sqlite executeQuery:@"delete from subitem_detail"];
	int checkcount ;
	BOOL stat;
	for (checkcount = 1;checkcount <=12; checkcount++)
	{
        stat=NO;
		NSString *query = [NSString stringWithFormat:@"select count(*) as countval from subitem_detail where category_id = %d", checkcount];
		
		itemset = [sqlite executeQuery:query];
		newitemset = [[NSMutableArray alloc] initWithArray:itemset];
		//NSLog(@"%@",[[newitemset objectAtIndex:0] valueForKey:@"countval"]);
		int countval = [[[newitemset objectAtIndex:0] valueForKey:@"countval"] intValue];
		
	//	NSLog(@"Inside checkcount : %d", checkcount);
		
		if (tempDBArray!=nil && [tempDBArray retainCount]>0) {
			tempDBArray=nil;
		}
		tempDBArray =[[NSMutableArray alloc] init];
		
		
		
		
		if (countval > 0) {
			//NSLog(@"Inside count g 0 : %d", countval);
			

			
		} else 
		{
			if (checkcount != 7 || checkcount != 8 ) {
				
                stat=YES;
				
			}
           
						
		}
	}	
	if (stat) {
        [self callWebService];
    }

	
}


// Calling web service for login

-(void)callWebService{
	isMainItem = TRUE;
	
	userid = [[[I_am_eatingAppDelegate getGlobalInfo] objectForKey:@"logininfo"]intValue];
	
	if (userid == 0)
	{
		NSString *resourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Login.plist"];
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *DataPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Login.plist"];
		
		NSFileManager *fileManager = [NSFileManager defaultManager];
		
		//see if Data.plist exists in the Documents directory
		if (![fileManager fileExistsAtPath:DataPath]) {
			[fileManager copyItemAtPath:resourcePath toPath:DataPath error:nil];
		}
		//END OF CHECK TO SEE IF FILE EXISTS
		
		//Load Data.plist from documents directory
		NSString *errorDesc = nil;
		NSPropertyListFormat format;
		NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:DataPath];
		NSDictionary *tempDict = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
		
		userid = [[tempDict objectForKey:@"userid"] intValue];
	}
	
	
	[progress startAnimating];
	
	[alert show];	
	
	NSString *soapMsg=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
					   "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
					   "<soap:Body>\n"
					   "<GetItemsList xmlns=\"http://tempuri.org/\">\n"
					   "<UserID>%i</UserID>\n"
					   "</GetItemsList>\n"
					   "</soap:Body>\n"
					   "</soap:Envelope>\n",userid];
	//NSLog(@"Print GetItemsList : %@",soapMsg) ;
	
	NSURL *myURL=[NSURL URLWithString:[WebService getLoginURL]];
	
	NSMutableURLRequest *connectionReq=[NSMutableURLRequest requestWithURL:myURL];
	
	[connectionReq addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[connectionReq addValue:@ "http://tempuri.org/GetItemsList" forHTTPHeaderField:@"SOAPAction"];
	[connectionReq setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
	[connectionReq addValue:[NSString stringWithFormat:@"%i",[soapMsg length]] forHTTPHeaderField:@"Content-Length"];
	[connectionReq setHTTPMethod:@"POST"];
	
	NSURLConnection *myConnection=[[NSURLConnection alloc] initWithRequest:connectionReq delegate:self];
	
	if(myConnection){
		//[spinner startAnimating];
		myWebData=[[NSMutableData alloc]  initWithLength:0];
		ItemArray = [[NSMutableArray alloc]init];
		forwhichWebservice = @"MainItem";
	}else{
		UIAlertView *ConnectionNullAlert = [[UIAlertView alloc]initWithFrame:CGRectMake(10, 170, 300, 120)];
		ConnectionNullAlert.message=@"Eating can't able to connect to Server - First!";
		ConnectionNullAlert.title=@"Message";
		[ConnectionNullAlert addButtonWithTitle:@"OK"];
		[ConnectionNullAlert show];
		[ConnectionNullAlert release];		
	}
}




-(void)GetSubItemRecordByCategoryList{
	isSubItem = TRUE;	
	userid=[[[I_am_eatingAppDelegate getGlobalInfo] objectForKey:@"logininfo"]intValue];
	
	
	[progress startAnimating];
	
	[alert show];	
   // NSLog(@"get subitem by cate");
	NSString *soapMsg = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
						 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
						 "<soap:Body>\n"
						 "<GetSubItemRecordByCategoryList xmlns=\"http://tempuri.org/\">\n"
						 "<UserID>%i</UserID>\n"
						 "</GetSubItemRecordByCategoryList>\n"
						 "</soap:Body>\n"
						 "</soap:Envelope>\n",userid];
	//NSLog(@"Print GetSubItemRecordByCategoryList : %@",soapMsg) ;
	
	NSURL *myURL=[NSURL URLWithString:[WebService getLoginURL]];
	
	NSMutableURLRequest *connectionReq=[NSMutableURLRequest requestWithURL:myURL];
	
	[connectionReq addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[connectionReq addValue:@ "http://tempuri.org/GetSubItemRecordByCategoryList" forHTTPHeaderField:@"SOAPAction"];
	[connectionReq setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
	[connectionReq addValue:[NSString stringWithFormat:@"%i",[soapMsg length]] forHTTPHeaderField:@"Content-Length"];
	[connectionReq setHTTPMethod:@"POST"];
	
	NSURLConnection *myConnection=[[NSURLConnection alloc] initWithRequest:connectionReq delegate:self];
	if(myConnection){
		myWebData=[[NSMutableData alloc]  initWithLength:0];
		forwhichWebservice = @"SubItem";

	}else{
		UIAlertView *ConnectionFailAlert = [[UIAlertView alloc]initWithFrame:CGRectMake(10, 170, 300, 120)];
		ConnectionFailAlert.message=@"Please select Item First";
		ConnectionFailAlert.title=@"Message";
		[ConnectionFailAlert addButtonWithTitle:@"OK"];
		[ConnectionFailAlert show];
		[ConnectionFailAlert release];
	}
}



#pragma mark URLWithString delegate



- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	
	UIAlertView *ConnectionFailAlert = [[UIAlertView alloc]initWithFrame:CGRectMake(10, 170, 300, 120)];
	ConnectionFailAlert.message=@"Eating can't able to connect to Server - Fourth!";
	ConnectionFailAlert.title=@"Message";
	[ConnectionFailAlert addButtonWithTitle:@"OK"];
	[ConnectionFailAlert show];
	[ConnectionFailAlert release];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	[myWebData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[myWebData appendData:data];
    NSString *ss=[[[NSString alloc] initWithBytes:data length:[data length] encoding:NSStringEncodingConversionAllowLossy] autorelease];
 
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	
	NSString *str=[[NSString alloc] initWithBytes:[myWebData bytes] length:[myWebData length] encoding:NSStringEncodingConversionAllowLossy];

	[str release];
	if(myXMLParser!=nil && [myXMLParser retainCount]>0){
		myXMLParser.delegate=nil; myXMLParser=nil;[myXMLParser release];  
	}
	myXMLParser=[[NSXMLParser alloc] initWithData:myWebData];
	myXMLParser.delegate=self;
	[myXMLParser parse];
	
	
		
	if (![viewload isEqualToString:@"YES"]) {
		[alert dismissWithClickedButtonIndex:0 animated:TRUE];
	}
	
	
}

#pragma mark XMLParser methods
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
	
	
	if([elementName isEqualToString:@"Prop_SubItemDetail"] || [elementName isEqualToString:@"Prop_CategoryDetail"] || [elementName isEqualToString:@"InsertCategoryDetailResult"]) {
		tempDicCatId = nil ;
		tempDicCatId = [[NSMutableDictionary alloc] init];
		
		
		
		tempDic = nil;
		tempDic = [[NSMutableDictionary alloc] init];
	}
	
	tmpStr = elementName;
	
	if([elementName isEqualToString:@"SubItemDetail"]){
		[subItemArray release];
		subItemArray = [[NSMutableArray alloc]init];
		
	}
	
	if([elementName isEqualToString:@"Category_Id"]){
	
		catIdFlag = @"YES" ;
	}
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	
	
	if ([catIdFlag isEqualToString:@"YES"] && [tmpStr isEqualToString:@"Category_Id"]) {
		tmpCatId = string ;
		catIdFlag = @"NO" ;
		
	}
	
	if([tempDic objectForKey:tmpStr] == nil){
		[tempDic setObject:string forKey:tmpStr];
		[tempDicCatId setObject:string forKey:tmpStr];
		
	} else {
		
		[tempDic setObject:[[tempDic objectForKey:tmpStr] stringByAppendingString:string] forKey:tmpStr];
		[tempDicCatId setObject:[[tempDicCatId objectForKey:tmpStr] stringByAppendingString:string] forKey:tmpStr];
	}

}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	
		
	
	if([forwhichWebservice isEqualToString:@"MainItem"]) {
		if([elementName isEqualToString:@"Prop_SubItemDetail"]) {
			[ItemArray addObject:tempDic];			
		}		
		
		
	} else if([forwhichWebservice isEqualToString:@"CategoryDetails"]) { 
		if([elementName isEqualToString:@"Prop_CategoryDetail"]) {
			[CategoryDetailArray addObject:tempDic];
		}
	} else if([forwhichWebservice isEqualToString:@"AddCateItems"]) { 
		
		if([elementName isEqualToString:@"InsertCategoryDetailResult"]){
			[ItemAddInfo addObject:tempDic];
		}
	} else if([forwhichWebservice isEqualToString:@"SubItem"]){
		if([elementName isEqualToString:@"Prop_SubItemDetail"]) {
			viewload = @"NO";
			[subItemArray addObject:tempDic];
			
			
		}	

		if([elementName isEqualToString:@"SubItemDetail"]) {
			
			
			if ([tmpCatId isEqualToString:@"1"]) {
				subItem1Array  = [subItemArray retain];
				itemset = [sqlite executeQuery:@"select count(*) as countval from subitem_detail where category_id = 1;"];
				newitemset = [[NSMutableArray alloc] initWithArray:itemset];
				
				int countval = [[[newitemset objectAtIndex:0] valueForKey:@"countval"] intValue];
				
				if (countval > 0 && countval == [subItem1Array count]) {
					
					resultset=[sqlite executeQuery:@"select * from subitem_detail where category_id = 1 order by subitem_name ;"];
					myDbArray = [[NSMutableArray alloc] initWithArray:resultset];
					for (NSDictionary *row in resultset) {
						
						NSString *decodedstr = [NSString stringWithUTF8String:[[row valueForKey:@"subitem_name"] cStringUsingEncoding:[NSString defaultCStringEncoding]]];
				
					}
				}
				else {
				
					for (NSDictionary *testarray in subItem1Array)
					{
						
						
						[self SaveData:1 :@"Sub Item 1" :[[testarray objectForKey:@"SubItem_Detail_Id"] intValue] :[testarray objectForKey:@"SubItem_Name"] :[[testarray objectForKey:@"Protein"] floatValue] :
						 [[testarray objectForKey:@"Carbohydrates"] floatValue] :[[testarray objectForKey:@"Fat"]floatValue] :
						 [[testarray objectForKey:@"Calorie"]floatValue]: [self GetDateFromString:[testarray objectForKey:@"Updated_Date"]] ] ;
						
						
					}
				}
			} else if([tmpCatId isEqualToString:@"2"]) {
				subItem2Array  = [subItemArray retain];
				
				itemset = [sqlite executeQuery:@"select count(*) as countval from subitem_detail where category_id = 2;"];
				newitemset = [[NSMutableArray alloc] initWithArray:itemset];

				int countval = [[[newitemset objectAtIndex:0] valueForKey:@"countval"] intValue];
				
				if (countval > 0 && countval == [subItem2Array count]) {
	
					resultset=[sqlite executeQuery:@"select * from subitem_detail where category_id = 2 order by subitem_name ;"];
					myDbArray = [[NSMutableArray alloc] initWithArray:resultset];
					for (NSDictionary *row in resultset) {
						
						NSString *decodedstr = [NSString stringWithUTF8String:[[row valueForKey:@"subitem_name"] cStringUsingEncoding:[NSString defaultCStringEncoding]]];
					}
				}
				else {
	
					for (NSDictionary *testarray in subItem2Array)
					{
                        
						
						[self SaveData:2 :@"Sub Item 2" :[[testarray objectForKey:@"SubItem_Detail_Id"] intValue] :[testarray objectForKey:@"SubItem_Name"] :[[testarray objectForKey:@"Protein"] floatValue] :
						 [[testarray objectForKey:@"Carbohydrates"] floatValue] :[[testarray objectForKey:@"Fat"]floatValue] :
						 [[testarray objectForKey:@"Calorie"]floatValue]: [self GetDateFromString:[testarray objectForKey:@"Updated_Date"]]] ;
						
					}
				}
				
			} else if([tmpCatId isEqualToString:@"3"]) {
				subItem3Array  = [subItemArray retain];
				
				itemset = [sqlite executeQuery:@"select count(*) as countval from subitem_detail where category_id = 3;"];
				newitemset = [[NSMutableArray alloc] initWithArray:itemset];
		
				int countval = [[[newitemset objectAtIndex:0] valueForKey:@"countval"] intValue];
				
				if (countval > 0 && countval == [subItem3Array count]) {
	
					resultset=[sqlite executeQuery:@"select * from subitem_detail where category_id = 3 order by subitem_name ;"];
					myDbArray = [[NSMutableArray alloc] initWithArray:resultset];
					for (NSDictionary *row in resultset) {
						NSString *decodedstr = [NSString stringWithUTF8String:[[row valueForKey:@"subitem_name"] cStringUsingEncoding:[NSString defaultCStringEncoding]]];
					}
				}
				else {
		
					for (NSDictionary *testarray in subItem3Array)
					{
						
						[self SaveData:3 :@"Sub Item 3" :[[testarray objectForKey:@"SubItem_Detail_Id"] intValue] :[testarray objectForKey:@"SubItem_Name"] :[[testarray objectForKey:@"Protein"] floatValue] :
						 [[testarray objectForKey:@"Carbohydrates"] floatValue] :[[testarray objectForKey:@"Fat"]floatValue] :
						 [[testarray objectForKey:@"Calorie"]floatValue]: [self GetDateFromString:[testarray objectForKey:@"Updated_Date"]]] ;
					}
				}
			} else if([tmpCatId isEqualToString:@"4"]) {
				subItem4Array  = [subItemArray retain];
				
				itemset = [sqlite executeQuery:@"select count(*) as countval from subitem_detail where category_id = 4;"];
				newitemset = [[NSMutableArray alloc] initWithArray:itemset];
		
				int countval = [[[newitemset objectAtIndex:0] valueForKey:@"countval"] intValue];
				
				if (countval > 0 && countval == [subItem4Array count]) {
			
					resultset=[sqlite executeQuery:@"select * from subitem_detail where category_id = 4 order by subitem_name;"];
					myDbArray = [[NSMutableArray alloc] initWithArray:resultset];
					for (NSDictionary *row in resultset) {
						NSString *decodedstr = [NSString stringWithUTF8String:[[row valueForKey:@"subitem_name"] cStringUsingEncoding:[NSString defaultCStringEncoding]]];
					}
				}
				else {
			
					for (NSDictionary *testarray in subItem4Array)
					{
					
						[self SaveData:4 :@"Sub Item 4" :[[testarray objectForKey:@"SubItem_Detail_Id"] intValue] :[testarray objectForKey:@"SubItem_Name"] :[[testarray objectForKey:@"Protein"] floatValue] :
						 [[testarray objectForKey:@"Carbohydrates"] floatValue] :[[testarray objectForKey:@"Fat"]floatValue] :
						 [[testarray objectForKey:@"Calorie"]floatValue]: [self GetDateFromString:[testarray objectForKey:@"Updated_Date"]]] ;
					}
				}
			} else if([tmpCatId isEqualToString:@"5"]) {
				subItem5Array  = [subItemArray retain];
				
				itemset = [sqlite executeQuery:@"select count(*) as countval from subitem_detail where category_id = 5;"];
				newitemset = [[NSMutableArray alloc] initWithArray:itemset];
		
				int countval = [[[newitemset objectAtIndex:0] valueForKey:@"countval"] intValue];
				
				if (countval > 0 && countval == [subItem5Array count]) {
			
					resultset=[sqlite executeQuery:@"select * from subitem_detail where category_id = 5 order by subitem_name;"];
					myDbArray = [[NSMutableArray alloc] initWithArray:resultset];
					for (NSDictionary *row in resultset) {
						NSString *decodedstr = [NSString stringWithUTF8String:[[row valueForKey:@"subitem_name"] cStringUsingEncoding:[NSString defaultCStringEncoding]]];
					}
				}
				else {
		
					for (NSDictionary *testarray in subItem5Array)
					{
						
						[self SaveData:5 :@"Sub Item 5" :[[testarray objectForKey:@"SubItem_Detail_Id"] intValue] :[testarray objectForKey:@"SubItem_Name"] :[[testarray objectForKey:@"Protein"] floatValue] :
						 [[testarray objectForKey:@"Carbohydrates"] floatValue] :[[testarray objectForKey:@"Fat"]floatValue] :
						 [[testarray objectForKey:@"Calorie"]floatValue]: [self GetDateFromString:[testarray objectForKey:@"Updated_Date"]]] ;
					}
				}
			} else if([tmpCatId isEqualToString:@"6"]) {
				subItem6Array  = [subItemArray retain];
				
				itemset = [sqlite executeQuery:@"select count(*) as countval from subitem_detail where category_id = 6;"];
				newitemset = [[NSMutableArray alloc] initWithArray:itemset];
	
				int countval = [[[newitemset objectAtIndex:0] valueForKey:@"countval"] intValue];
				
				if (countval > 0 && countval == [subItem6Array count]) {
		
					resultset=[sqlite executeQuery:@"select * from subitem_detail where category_id = 6 order by subitem_name;"];
					myDbArray = [[NSMutableArray alloc] initWithArray:resultset];
					for (NSDictionary *row in resultset) {
						NSString *decodedstr = [NSString stringWithUTF8String:[[row valueForKey:@"subitem_name"] cStringUsingEncoding:[NSString defaultCStringEncoding]]];
					}
				}
				else {
				
					for (NSDictionary *testarray in subItem6Array)
					{
						
						[self SaveData:6 :@"Sub Item 6" :[[testarray objectForKey:@"SubItem_Detail_Id"] intValue] :[testarray objectForKey:@"SubItem_Name"] :[[testarray objectForKey:@"Protein"] floatValue] :
						 [[testarray objectForKey:@"Carbohydrates"] floatValue] :[[testarray objectForKey:@"Fat"]floatValue] :
						 [[testarray objectForKey:@"Calorie"]floatValue]: [self GetDateFromString:[testarray objectForKey:@"Updated_Date"]]] ;
					}
				}
			} else if([tmpCatId isEqualToString:@"8"]) {
				
				subItem7Array  = [subItemArray retain];
				
				itemset = [sqlite executeQuery:@"select count(*) as countval from subitem_detail where category_id = 8;"];
				newitemset = [[NSMutableArray alloc] initWithArray:itemset];
			
				int countval = [[[newitemset objectAtIndex:0] valueForKey:@"countval"] intValue];
				
				if (countval > 0 && countval == [subItem7Array count]) {
	
					resultset=[sqlite executeQuery:@"select * from subitem_detail where category_id = 8 order by subitem_name;"];
					myDbArray = [[NSMutableArray alloc] initWithArray:resultset];
					for (NSDictionary *row in resultset) {
						NSString *decodedstr = [NSString stringWithUTF8String:[[row valueForKey:@"subitem_name"] cStringUsingEncoding:[NSString defaultCStringEncoding]]];
					}
				}
				else {
		
					for (NSDictionary *testarray in subItem7Array)
					{
						[self SaveData:8 :@"Search Item" :[[testarray objectForKey:@"SubItem_Detail_Id"] intValue] :[testarray objectForKey:@"SubItem_Name"] :[[testarray objectForKey:@"Protein"] floatValue] :
						 [[testarray objectForKey:@"Carbohydrates"] floatValue] :[[testarray objectForKey:@"Fat"]floatValue] :
						 [[testarray objectForKey:@"Calorie"]floatValue]: [self GetDateFromString:[testarray objectForKey:@"Updated_Date"]]] ;
					}
				}
			}
           else if ([tmpCatId isEqualToString:@"9"]) {
				subItemnewArray1  = [subItemArray retain];
				itemset = [sqlite executeQuery:@"select count(*) as countval from subitem_detail where category_id = 9;"];
				newitemset = [[NSMutableArray alloc] initWithArray:itemset];
			
				int countval = [[[newitemset objectAtIndex:0] valueForKey:@"countval"] intValue];
				
				if (countval > 0 && countval == [subItemnewArray1 count]) {
				
					resultset=[sqlite executeQuery:@"select * from subitem_detail where category_id = 9 order by subitem_name ;"];
					myDbArray = [[NSMutableArray alloc] initWithArray:resultset];
					for (NSDictionary *row in resultset) {
						
						NSString *decodedstr = [NSString stringWithUTF8String:[[row valueForKey:@"subitem_name"] cStringUsingEncoding:[NSString defaultCStringEncoding]]];
						
						
					}
				}
				else {
					
					for (NSDictionary *testarray in subItemnewArray1)
					{
						
						
						[self SaveData:9 :@"Sub Item 9" :[[testarray objectForKey:@"SubItem_Detail_Id"] intValue] :[testarray objectForKey:@"SubItem_Name"] :[[testarray objectForKey:@"Protein"] floatValue] :
						 [[testarray objectForKey:@"Carbohydrates"] floatValue] :[[testarray objectForKey:@"Fat"]floatValue] :
						 [[testarray objectForKey:@"Calorie"]floatValue]: [self GetDateFromString:[testarray objectForKey:@"Updated_Date"]] ] ;
						
						
					}
				}
			} 
         else   if ([tmpCatId isEqualToString:@"10"]) {
				subItemnewArray2  = [subItemArray retain];
				itemset = [sqlite executeQuery:@"select count(*) as countval from subitem_detail where category_id = 10;"];
				newitemset = [[NSMutableArray alloc] initWithArray:itemset];
				
				int countval = [[[newitemset objectAtIndex:0] valueForKey:@"countval"] intValue];
				
				if (countval > 0 && countval == [subItemnewArray2 count]) {
				
					resultset=[sqlite executeQuery:@"select * from subitem_detail where category_id = 10 order by subitem_name ;"];
					myDbArray = [[NSMutableArray alloc] initWithArray:resultset];
					for (NSDictionary *row in resultset) {
						
						NSString *decodedstr = [NSString stringWithUTF8String:[[row valueForKey:@"subitem_name"] cStringUsingEncoding:[NSString defaultCStringEncoding]]];
						
						
					}
				}
				else {
					
					for (NSDictionary *testarray in subItemnewArray2)
					{
						
						
						[self SaveData:10 :@"Sub Item 10" :[[testarray objectForKey:@"SubItem_Detail_Id"] intValue] :[testarray objectForKey:@"SubItem_Name"] :[[testarray objectForKey:@"Protein"] floatValue] :
						 [[testarray objectForKey:@"Carbohydrates"] floatValue] :[[testarray objectForKey:@"Fat"]floatValue] :
						 [[testarray objectForKey:@"Calorie"]floatValue]: [self GetDateFromString:[testarray objectForKey:@"Updated_Date"]] ] ;
						
						
					}
				}
			} 
         else   if ([tmpCatId isEqualToString:@"11"]) {
             subItemnewArray3  = [subItemArray retain];
             itemset = [sqlite executeQuery:@"select count(*) as countval from subitem_detail where category_id = 11;"];
             newitemset = [[NSMutableArray alloc] initWithArray:itemset];
             
             int countval = [[[newitemset objectAtIndex:0] valueForKey:@"countval"] intValue];
             
             if (countval > 0 && countval == [subItemnewArray3 count]) {
                
                 resultset=[sqlite executeQuery:@"select * from subitem_detail where category_id = 11 order by subitem_name ;"];
                 myDbArray = [[NSMutableArray alloc] initWithArray:resultset];
                 for (NSDictionary *row in resultset) {
                     
                     NSString *decodedstr = [NSString stringWithUTF8String:[[row valueForKey:@"subitem_name"] cStringUsingEncoding:[NSString defaultCStringEncoding]]];
                    
                 }
             }
             else {
              
                 for (NSDictionary *testarray in subItemnewArray3)
                 {
                     
                     
                     [self SaveData:11 :@"Sub Item 11" :[[testarray objectForKey:@"SubItem_Detail_Id"] intValue] :[testarray objectForKey:@"SubItem_Name"] :[[testarray objectForKey:@"Protein"] floatValue] :
                      [[testarray objectForKey:@"Carbohydrates"] floatValue] :[[testarray objectForKey:@"Fat"]floatValue] :
                      [[testarray objectForKey:@"Calorie"]floatValue]: [self GetDateFromString:[testarray objectForKey:@"Updated_Date"]] ] ;
                     
                     
                 }
             }
         } 
            
         else   if ([tmpCatId isEqualToString:@"12"]) {
             subItemnewArray4  = [subItemArray retain];
             itemset = [sqlite executeQuery:@"select count(*) as countval from subitem_detail where category_id = 12;"];
             newitemset = [[NSMutableArray alloc] initWithArray:itemset];
             
             int countval = [[[newitemset objectAtIndex:0] valueForKey:@"countval"] intValue];
             
             if (countval > 0 && countval == [subItemnewArray4 count]) {
                 
                 resultset=[sqlite executeQuery:@"select * from subitem_detail where category_id = 12 order by subitem_name ;"];
                 myDbArray = [[NSMutableArray alloc] initWithArray:resultset];
                 for (NSDictionary *row in resultset) {
                     
                     NSString *decodedstr = [NSString stringWithUTF8String:[[row valueForKey:@"subitem_name"] cStringUsingEncoding:[NSString defaultCStringEncoding]]];
                     
                    
                 }
             }
             else {
               
                 for (NSDictionary *testarray in subItemnewArray4)
                 {
                     
                     
                     [self SaveData:12 :@"Sub Item 12" :[[testarray objectForKey:@"SubItem_Detail_Id"] intValue] :[testarray objectForKey:@"SubItem_Name"] :[[testarray objectForKey:@"Protein"] floatValue] :
                      [[testarray objectForKey:@"Carbohydrates"] floatValue] :[[testarray objectForKey:@"Fat"]floatValue] :
                      [[testarray objectForKey:@"Calorie"]floatValue]: [self GetDateFromString:[testarray objectForKey:@"Updated_Date"]] ] ;
                     
                     
                 }
             }
         } 



			itemsel++;
			[subItemArray release];
			subItemArray = [[NSMutableArray alloc]init];
		}		
	}
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
	[AlertHandler hideAlert];
	//	Category Detail Added Successfully
	NSLog(@"parser did end");
	if ([ItemArray count] > 0) {
		itemset = [sqlite executeQuery:@"select count(*) as countval from subitem_detail where category_id = 7 order by subitem_name;"];
		newitemset = [[NSMutableArray alloc] initWithArray:itemset];
		
		int countval = [[[newitemset objectAtIndex:0] valueForKey:@"countval"] intValue];
		
	
		
		if (countval > 0) {
			resultset=[sqlite executeQuery:@"select * from subitem_detail where category_id = 7 order by subitem_name;"];
			myDbArray = [[NSMutableArray alloc] initWithArray:resultset];
			for (NSDictionary *row in resultset) {
				NSString *decodedstr = [NSString stringWithUTF8String:[[row valueForKey:@"subitem_name"] cStringUsingEncoding:[NSString defaultCStringEncoding]]];
			}
		}
		else {
			for (NSDictionary *testarray in ItemArray)
			{
				[self SaveData:7 :@"Item" :[[testarray objectForKey:@"SubItem_Detail_Id"] intValue] :[testarray objectForKey:@"SubItem_Name"] :[[testarray objectForKey:@"Protein"] floatValue] :
				 [[testarray objectForKey:@"Carbohydrates"] floatValue] :[[testarray objectForKey:@"Fat"]floatValue] :
				 [[testarray objectForKey:@"Calorie"]floatValue]: [self GetDateFromString:[testarray objectForKey:@"Updated_Date"]]] ;
				
			}
		}
		
	}
	if([forwhichWebservice isEqualToString:@"MainItem"]) {
		if([ItemEditArray count] > 0) {
			itemsel = 1;
			[self GetSubItemRecordByCategoryList];
						
		}
		else {
						NSLog(@"subItemcount : %d", [subItemArray count]);
		
			if(![subItemArray count] > 0) {
				itemsel = 1;
				
				[self GetSubItemRecordByCategoryList];
			}
		}
		
		
		
	}   else {
		UIAlertView *ConnectionNullAlert = [[UIAlertView alloc]initWithFrame:CGRectMake(10, 170, 300, 120)];
		ConnectionNullAlert.message=[[ItemAddInfo objectAtIndex:0] objectForKey:@"Msg"];
		ConnectionNullAlert.title=@"Message";
		[ConnectionNullAlert addButtonWithTitle:@"OK"];
		[ConnectionNullAlert show];
		[ConnectionNullAlert release];	
		
	}
	
	
}  


-(void)SaveData:(int)categoryid: (NSString *)category_name: (int)subitemdetail_id: (NSString *)subitem_name: (float)protein: (float)carbohydrates: (float)fat: (float)calorie: (NSString *)updated_date
{
    NSLog(@"save data");
	databaseName = @"imeating.sql";
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
	NSString *documentsDir=[documentPaths objectAtIndex:0];
	databasePath=[documentsDir stringByAppendingPathComponent:databaseName];
	sqlite3 *database;
	
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
	{	
		const char *sqlStatement = "insert into subitem_detail (category_id, category_name, subitem_detail_id, subitem_name, protein, carbohydrates, fat, calorie, updated_date) values (?, ?, ?, ?, ?, ?, ?, ?, ?)";
		sqlite3_stmt *compiledStatement;
		sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);

		sqlite3_bind_int(compiledStatement, 1, categoryid);
		sqlite3_bind_text(compiledStatement,2,[category_name UTF8String],-1,SQLITE_TRANSIENT);
		sqlite3_bind_int(compiledStatement, 3, subitemdetail_id);
		sqlite3_bind_text(compiledStatement,4,[subitem_name UTF8String],-1,SQLITE_TRANSIENT);
		sqlite3_bind_double(compiledStatement, 5, protein);
		sqlite3_bind_double(compiledStatement, 6, carbohydrates);
		sqlite3_bind_double(compiledStatement, 7, fat);
		sqlite3_bind_double(compiledStatement, 8, calorie);
        sqlite3_bind_text(compiledStatement,9,[updated_date UTF8String],-1,SQLITE_TRANSIENT);
		sqlite3_step(compiledStatement);	
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
}




@end
