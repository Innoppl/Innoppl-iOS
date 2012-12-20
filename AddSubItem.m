//
//  AddSubItem.m
//  I am eating
// add subitems of the items
//  Created by Innoppl Technologies on 27/05/10.
//  Copyright 2010 mac. All rights reserved.
//

#import "AddSubItem.h"
#include "HomeView.h"
#import "Innoppl.h"
#import "MBProgressHUD.h"
@implementation AddSubItem
@synthesize itemid,callweb1,fetchsub1,fetchsub2,fetchsub3,fetchsub4,fetchsub5,fetchsub6,fetchsub9,fetchsub10,fetchsub11,fetchsub12 ;
@synthesize mlabel;
@synthesize arrayNo;
@synthesize subitem, newItemid ;

NSString *tempSubItem ;
NSString *tempProtein ;
NSString *tempCarbohydrates ;
NSString *tempFat ;
NSString *tempCalorie ;


UIAlertView *alert ;
MBProgressHUD *HUD;
UIActivityIndicatorView *progress;
int count2 = 1000;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	
	subitemProtein.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	subitemCarbohydrates.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	subitemFat.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	subitemCalorie.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
	subitemProtein.tag = 1;
	subitemCarbohydrates.tag = 2;
	subitemFat.tag = 3;
	subitemCalorie.tag = 4;
	
	
	[super viewDidLoad];
    
   // NSLog(@"searchObj shareitemname : %@", searchObj.shareItemName);
   // NSLog(@"searchObj share pro : %@", searchObj.shareProtein);
   // NSLog(@"searchObj sharecal : %@", searchObj.shareCalorie);
    [subitem becomeFirstResponder];
    subitem.text = searchObj.shareItemName ;
    mlabel.text = searchObj.shareItemName ;
    subitemProtein.text = searchObj.shareProtein ;
    subitemFat.text = searchObj.shareFat;
    subitemCarbohydrates.text = searchObj.shareCarbo;
    subitemCalorie.text = searchObj.shareCalorie;
    
    [searchObj release];
    
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
														 NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	mydb =[documentsDirectory stringByAppendingPathComponent:@"imeating.sql"];
	
	sqlite=[[Sqlite alloc] init];
	[sqlite open:mydb];

	if (newData1!=nil && [newData1 retainCount]>0) {
		[newData1 removeAllObjects];
	}

	newData1 =[[NSMutableArray alloc] init];
	
	[newData1 addObjectsFromArray:arrayNo] ;
    
    UIBarButtonItem *barButtonCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonSystemItemAdd target:self action:@selector(btnCancelClicked:)];
    
    UIBarButtonItem *BtnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *barButtonOk = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonSystemItemAdd target:self action:@selector(btnOkClicked:)];
    
    NSMutableArray *buttons = [[NSMutableArray alloc] init] ;
    
    [buttons addObject:barButtonCancel];
    [buttons addObject:BtnSpace];
    [buttons addObject:barButtonOk];
    
    [toolbar setItems:buttons animated:YES];
		
	
	[subitem addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

	if([HomeView getID]==1){
		headerlbl.text=@"i am eating this - breakfast";
	} else if([HomeView getID]==2){
		headerlbl.text=@"i am eating this - lunch";
	}else if([HomeView getID]==3){
		headerlbl.text=@"i am eating this - dinner";
	} else if([HomeView getID]==4){
		headerlbl.text=@"i am eating this - other";
	}
	
	int catId = [[[I_am_eatingAppDelegate getGlobalInfo] objectForKey:@"category_Id"]intValue];

	if(catId == 5) {
		lblmainItem.text = @"Manufacture";
	} else if(catId == 6) {
		lblmainItem.text = @"Beverages";
	}
	subitem.delegate = self;
	subitemProtein.delegate = self;
	subitemCarbohydrates.delegate = self;
	subitemFat.delegate = self;
	subitemCalorie.delegate = self;
	
/*	alert = [[UIAlertView alloc] initWithTitle:@"Loading" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
	progress= [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 50, 30, 30)];
	progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	[alert addSubview:progress];
	[progress startAnimating];
	
	[alert show];*/
    
       

	NSString *searchquery = [NSString stringWithFormat:@"select category_id as Category_Id, subitem_detail_id as SubItem_Detail_Id, subitem_name as SubItem_Name, protein as Protein, carbohydrates as Carbohydrates, fat as Fat, calorie as Calorie from subitem_detail where category_id = %d order by subitem_name",8];
	
	NSString *decodedstr = [NSString stringWithUTF8String:[searchquery cStringUsingEncoding:[NSString defaultCStringEncoding]]];
	
	
	//[alert dismissWithClickedButtonIndex:0 animated:NO];
	[pickerview selectRow:2 inComponent:0 animated:YES];

}
 
- (void) viewWillAppear:(BOOL)animated {
    
    
   // NSLog(@"searchObj shareitemname appear: %@", searchObj.shareItemName);
    if(searchObj!=nil){
    subitem.text = searchObj.shareItemName ;
    mlabel.text = searchObj.shareItemName ;
    subitemProtein.text = searchObj.shareProtein ;
    subitemFat.text = searchObj.shareFat;
    subitemCarbohydrates.text = searchObj.shareCarbo;
    subitemCalorie.text = searchObj.shareCalorie;
    
    [searchObj release];
    }
    [super viewWillAppear:YES];
}

#pragma mark OUtlets UI actions
-(IBAction) Btnback:(id)sender{
	[[self.navigationController popViewControllerAnimated:YES ] retain];
}
-(IBAction) Btnsubmit:(id)sender{
	
	NSString *subprotein = [subitemProtein.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString *subcarbo = [subitemCarbohydrates.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString *subfat = [subitemFat.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString *subcalorie = [subitemCalorie.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

	if([subitem.text length]==0){
		UIAlertView *alertMessage = [[UIAlertView alloc]initWithFrame:CGRectMake(0, 130, 320, 100)];
		alertMessage.title=@"Message";
		alertMessage.message=@"Please Enter SubItem Name.";
		[alertMessage addButtonWithTitle:@"OK"];
		[alertMessage show];
		[alertMessage release];
		[subitem becomeFirstResponder];
		
	} else {
	
	if([subprotein isEqualToString:@""]) {
		
		subitemProtein.text = @"0";
		
		
	} 
	
	if([subcarbo isEqualToString:@""]) {
		
		subitemCarbohydrates.text = @"0";
		
		
	} 
	
	if([subfat isEqualToString:@""]) {
				subitemFat.text = @"0";
		
		
	} 

		if([subcalorie isEqualToString:@""]) {
			
			subitemCalorie.text = @"0";
			
			
		} 
	
			//[progress startAnimating];
		
        HUD=[[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = @"Loading";
        HUD.detailsLabelText = @"updating data";
        HUD.square = YES;

        [HUD showWhileExecuting:@selector(callWeb) onTarget:self withObject:nil animated:YES];
		//[alert show];
		//[self callWebInsert];
	}
}


-(void) callWeb{
    
    [self performSelectorOnMainThread:@selector(callWebInsert) withObject:nil waitUntilDone:YES];
}


-(IBAction) Btnno:(id)sender{
	[[self.navigationController popViewControllerAnimated:YES] retain];
}

-(IBAction) Btniclicked:(id)sender{
    
    //[searchObj release];
    searchObj=nil;
	Innoppl *ObjInnoppl = [[Innoppl alloc]initWithNibName:@"Innoppl" bundle:nil];
	[self.navigationController pushViewController:ObjInnoppl animated:YES];
	[ObjInnoppl release];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

# pragma pickerView delegates
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	
	if ([newData1 count] == 0) {
		return;
	}
  	
	count2 = (int)row ;
	
	tempSubItem = [[newData1 objectAtIndex:row] objectForKey:@"SubItem_Name"];
	tempProtein = (NSString*)[[newData1 objectAtIndex:row] objectForKey:@"Protein"];	
	tempCarbohydrates = (NSString*)[[newData1 objectAtIndex:row] objectForKey:@"Carbohydrates"];
	tempFat = (NSString*)[[newData1 objectAtIndex:row] objectForKey:@"Fat"];
	tempCalorie = (NSString*)[[newData1 objectAtIndex:row] objectForKey:@"Calorie"];
	
	
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{

	if ([newData1 count] == 0)
	{
		return 1 ;
	}
    return [newData1 count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
	
	if ([newData1 count] == 0) {
		return @"";
	}
	
	return [(NSString*)[[newData1 objectAtIndex:row] objectForKey:@"SubItem_Name"] uppercaseString];
	
}

// When Ok Button is clicked from picker

-(IBAction) btnOkClicked:(id)sender
{
	
	//NSLog(@"OK cleciked") ;
	if ([newData1 count] == 0) {
		mlabel.text = subitem.text;
	} else 
	{

		if (count2==1000) {
			mlabel.text = [[newData1 objectAtIndex:0] objectForKey:@"SubItem_Name"];
			subitem.text = [[[newData1 objectAtIndex:0] objectForKey:@"SubItem_Name"] uppercaseString];
			subitemProtein.text = [NSString stringWithFormat:@"%@",[[newData1 objectAtIndex:0] objectForKey:@"Protein"]];	
			subitemCarbohydrates.text = [NSString stringWithFormat:@"%@",[[newData1 objectAtIndex:0] objectForKey:@"Carbohydrates"]];
			subitemFat.text = [NSString stringWithFormat:@"%@",[[newData1 objectAtIndex:0] objectForKey:@"Fat"]];
			subitemCalorie.text = [NSString stringWithFormat:@"%@",[[newData1 objectAtIndex:0] objectForKey:@"Calorie"]];
		} else {
	mlabel.text = tempSubItem;
	subitem.text = [tempSubItem uppercaseString];
	subitemProtein.text = [NSString stringWithFormat:@"%@",tempProtein];	
	subitemCarbohydrates.text = [NSString stringWithFormat:@"%@",tempCarbohydrates];
	subitemFat.text = [NSString stringWithFormat:@"%@",tempFat];
	subitemCalorie.text = [NSString stringWithFormat:@"%@",tempCalorie];		
		}
	}
	toolbar.hidden=YES;
	pickerview.hidden=YES;
	
	
}

-(IBAction) btnCancelClicked:(id)sender
{
	//NSLog(@"Cancel click");
	toolbar.hidden=YES;
	pickerview.hidden=YES;
}


-(void)callWebInsert {
	int userid=[[[I_am_eatingAppDelegate getGlobalInfo] objectForKey:@"logininfo"]intValue];
	int catId = [[[I_am_eatingAppDelegate getGlobalInfo] objectForKey:@"category_Id"]intValue];
	NSString *soapMsg ;
	
	
	soapMsg = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
						 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
						 "<soap:Body>\n"
						 "<AddSubItem xmlns=\"http://tempuri.org/\">\n"
						 "<User_Id>%i</User_Id>\n"
						 "<Category_Id>%i</Category_Id>\n"
						 "<SubItem_Name>%@</SubItem_Name>\n"
						 "<Protein>%0.2f</Protein>\n"
						 "<Carbohydrates>%0.2f</Carbohydrates>\n"
						 "<Fat>%0.2f</Fat>\n"
						 "<Calorie>%0.2f</Calorie>\n"
						 "</AddSubItem>\n"						 
						 "</soap:Body>\n"
						 "</soap:Envelope>\n",userid,catId,[self convertEntities:[subitem.text uppercaseString]],[subitemProtein.text floatValue],[subitemCarbohydrates.text floatValue],[subitemFat.text floatValue],[subitemCalorie.text floatValue]];
	//NSLog(@"Request : %@", soapMsg);
	NSURL *myURL=[NSURL URLWithString:[WebService getLoginURL]];

	NSMutableURLRequest *connectionReq=[NSMutableURLRequest requestWithURL:myURL];
	[connectionReq addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[connectionReq addValue:@ "http://tempuri.org/AddSubItem" forHTTPHeaderField:@"SOAPAction"];
	[connectionReq setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
	[connectionReq addValue:[NSString stringWithFormat:@"%i",[soapMsg length]] forHTTPHeaderField:@"Content-Length"];
	[connectionReq setHTTPMethod:@"POST"];
	
	NSURLConnection *myConnection=[[NSURLConnection alloc] initWithRequest:connectionReq delegate:self];
	if(myConnection){
		myWebData=[[NSMutableData alloc]  initWithLength:0];
	}else{
		UIAlertView *ConnectionNullAlert = [[UIAlertView alloc]initWithFrame:CGRectMake(10, 170, 300, 120)];
		ConnectionNullAlert.message=@"Eating can't able to connect to Server!";
		ConnectionNullAlert.title=@"Message";
		[ConnectionNullAlert addButtonWithTitle:@"OK"];
		[ConnectionNullAlert show];
		[ConnectionNullAlert release];		
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	[alert dismissWithClickedButtonIndex:0 animated:TRUE];
	UIAlertView *ConnectionFailAlert = [[UIAlertView alloc]initWithFrame:CGRectMake(10, 170, 300, 120)];
	ConnectionFailAlert.message=@"Eating can't able to connect to Server!";
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
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	[alert dismissWithClickedButtonIndex:0 animated:TRUE];

	NSString *str=[[NSString alloc] initWithBytes:[myWebData bytes] length:[myWebData length] encoding:NSStringEncodingConversionAllowLossy];
	//NSLog(@"%@", str);
	[str release];
	if(myXMLParser!=nil && [myXMLParser retainCount]>0){ myXMLParser.delegate=nil; [myXMLParser release]; myXMLParser=nil; }
	myXMLParser=[[NSXMLParser alloc] initWithData:myWebData];
	myXMLParser.delegate=self;
	[myXMLParser parse];
	[myWebData release];
}


#pragma mark XMLParser methods
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
	if([elementName isEqualToString:@"AddSubItemResult"]){
		tempDic=[[NSMutableDictionary alloc] init];
	}
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	if(tmpStr!=nil && [tmpStr retainCount]>0){ [tmpStr release]; tmpStr=nil; }
	tmpStr=[[NSString alloc] initWithString:string];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	if([elementName isEqualToString:@"AddSubItemResult"] ||
	   [elementName isEqualToString:@"Msg"]){
		[tempDic setValue:tmpStr forKey:elementName];
	}
	
	if ([elementName isEqualToString:@"SubItem_Detail_Id"]) {
		//NSLog(@"ITEMNAM : %@", subitem.text);
		//NSLog(@"PRO : %@", subitemProtein.text);
		//NSLog(@"CARB :  %@", subitemCarbohydrates.text);
		//NSLog(@"FAT : %@", subitemFat.text);
		//NSLog(@"FAT : %@", subitemCalorie.text);
		//NSLog(@"ID : %@", tmpStr);
		//NSLog(@"catid : %d", [[[I_am_eatingAppDelegate getGlobalInfo] objectForKey:@"category_Id"]intValue]);
		newItemid = [tmpStr intValue];
	}
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
	[AlertHandler hideAlert];
	callweb1 = [[NSString alloc] init];
	if([[tempDic valueForKey:@"Msg"]isEqualToString:@"SubItem Added Successfully"]){
		callweb1 = @"call";
		
		//Insert the new Item to local DB
		
		NSString *itemtitle ;
		int catId = [[[I_am_eatingAppDelegate getGlobalInfo] objectForKey:@"category_Id"]intValue];
		
		if (catId == 1) {
			itemtitle = @"Sub Item 1"; 
			fetchsub1 = @"fetch" ;
		} else if(catId == 2) {
			itemtitle = @"Sub Item 2";
			fetchsub2 = @"fetch" ;
		} else if(catId == 3) {
			itemtitle = @"Sub Item 3";
			fetchsub3 = @"fetch" ;
		} else if(catId == 4) {
			itemtitle = @"Sub Item 4";
			fetchsub4 = @"fetch" ;
		} else if(catId == 5) {
			itemtitle = @"Sub Item 5";
			fetchsub5 = @"fetch" ;
		} else if(catId == 6) {
			itemtitle = @"Sub Item 6";
			fetchsub6 = @"fetch" ;
		}
        else if(catId == 9) {
			itemtitle = @"Sub Item 9";
			fetchsub9 = @"fetch" ;
		}
        else if(catId == 10) {
			itemtitle = @"Sub Item 10";
			fetchsub10 = @"fetch" ;
		}
        else if(catId == 11) {
			itemtitle = @"Sub Item 11";
			fetchsub11 = @"fetch" ;
		}
        else if(catId == 12) {
			itemtitle = @"Sub Item 12";
			fetchsub12 = @"fetch" ;
		}


		
		
		
		[self SaveData:[[[I_am_eatingAppDelegate getGlobalInfo] objectForKey:@"category_Id"]intValue] :itemtitle :newItemid :subitem.text :[subitemProtein.text floatValue] :
		 [subitemCarbohydrates.text floatValue] :[subitemFat.text floatValue] :
		 [subitemCalorie.text floatValue]] ;
		
        [[I_am_eatingAppDelegate getGlobalInfo] setObject:[NSArray array] forKey:@"itemArray"];
        
		
		UIAlertView *av = [[UIAlertView alloc]initWithFrame:CGRectMake(10, 170, 300, 120)];
		av.message = @"SubItem Added Successfully";
		av.title = @"Message";
		[av addButtonWithTitle:@"OK"];
		[av show];
		[av release];
	} else if([[tempDic valueForKey:@"Msg"]isEqualToString:@"Already exists in your SubItemlist"]) {
		UIAlertView *ConnectionNullAlert = [[UIAlertView alloc]initWithFrame:CGRectMake(10, 170, 300, 120)];
		ConnectionNullAlert.message=@"Item Already exist in your list!";
		ConnectionNullAlert.title=@"Message";
		[ConnectionNullAlert addButtonWithTitle:@"OK"];
		[ConnectionNullAlert show];
		[ConnectionNullAlert release];
	}
	[self.navigationController popViewControllerAnimated:YES];
}

-(void)SaveData:(int)categoryid: (NSString *)category_name: (int)subitemdetail_id: (NSString *)subitem_name: (float)protein: (float)carbohydrates: (float)fat: (float)calorie
{
    
    NSLog(@"%d,%@,%d,%@,",categoryid,category_name,subitemdetail_id,subitem_name);
	databaseName = @"imeating.sql";
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
	NSString *documentsDir=[documentPaths objectAtIndex:0];
	databasePath=[documentsDir stringByAppendingPathComponent:databaseName];
	sqlite3 *database;
	
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
	{	
		//const char *sqlStatement = "insert into customers (FirstName, LastName, State, Street, PostCode) values(?, ?, ?, ?, ?)";
		const char *sqlStatement = "insert into subitem_detail (category_id, category_name, subitem_detail_id, subitem_name, protein, carbohydrates, fat, calorie) values (?, ?, ?, ?, ?, ?, ?, ?)";
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
		sqlite3_step(compiledStatement);	
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
}

- (NSString*)convertEntities:(NSString*)string
{
	
	NSString    *returnStr = nil;
	
    if( string )
    {
        returnStr = [ string stringByReplacingOccurrencesOfString:@"&" withString: @"&amp;"  ];
		
        returnStr = [ returnStr stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"  ];
		
        returnStr = [ returnStr stringByReplacingOccurrencesOfString:@"'" withString:@"&#x27;"  ];
		
		// returnStr = [ returnStr stringByReplacingOccurrencesOfString:@"&#x39;" withString:@"'"  ];
		
        //returnStr = [ returnStr stringByReplacingOccurrencesOfString:@"&#x92;" withString:@"'"  ];
		
        //returnStr = [ returnStr stringByReplacingOccurrencesOfString:@"&#x96;" withString:@"'"  ];
		
        returnStr = [ returnStr stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"  ];
		
        returnStr = [ returnStr stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"  ];
		
        returnStr = [ [ NSString alloc ] initWithString:returnStr ];
    }
	
    return returnStr;
}

-(void)textFieldDidChange:(id)sender {
	
	//NSLog(@"textFieldDidChange");
    
	/*MBProgressHUD *HUD=[[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Loading";
	//HUD.detailsLabelText = @"updating data";
	HUD.square = YES;
    [HUD showWhileExecuting:@selector(searchTextRange:) onTarget:self withObject:sender animated:YES];
    */

//	[self performSelectorOnMainThread:@selector(searchTextRange:) withObject:sender waitUntilDone:YES];
}

-(void)searchTextRange:(UITextField *)t {
	
	int row = [t tag] ;
	
	[pickerview setHidden:NO];
	[toolbar setHidden:NO];
	[newData1 removeAllObjects];
	
	newData1 =[[NSMutableArray alloc] init];
	
	if([subitem.text isEqualToString:@""] || subitem.text==nil)
	{
		
	
		NSString *searchquery = [NSString stringWithFormat:@"select category_id as Category_Id, subitem_detail_id as SubItem_Detail_Id, subitem_name as SubItem_Name, protein as Protein, carbohydrates as Carbohydrates, fat as Fat, calorie as Calorie from subitem_detail where category_id = %d order by subitem_name",8];
		
		NSString *decodedstr = [NSString stringWithUTF8String:[searchquery cStringUsingEncoding:[NSString defaultCStringEncoding]]];
		NSArray *resultset=[sqlite executeQuery:decodedstr];
		
		[newData1 addObjectsFromArray:resultset];		
		
	} else {
		NSString *modulo = @"%";
		NSLog(@"test");
		NSString *searchquery = [NSString stringWithFormat:@"select category_id as Category_Id, subitem_detail_id as SubItem_Detail_Id, subitem_name as SubItem_Name, protein as Protein, carbohydrates as Carbohydrates, fat as Fat, calorie as Calorie from subitem_detail where category_id = %d and LOWER(subitem_name) LIKE '%@%@%@' order by subitem_name",8,modulo,[subitem.text lowercaseString],modulo];
		
		NSString *decodedstr = [NSString stringWithUTF8String:[searchquery cStringUsingEncoding:[NSString defaultCStringEncoding]]];
		NSArray *resultset=[sqlite executeQuery:decodedstr];
		
		[newData1 addObjectsFromArray:resultset];
	}
	
	[pickerview reloadComponent:0];
	[pickerview selectRow:2 inComponent:0 animated:YES];
	
	

}



#pragma mark textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
	
	
	//NSLog(@"textFieldDidBeginEditing");
	
	count2 = 1000 ;
    
    if(searchObj!=nil){
        searchObj=nil;
    }
	
	
    
	if([textField isEqual:subitem]){
		
		SignUpScrollView.contentOffset = CGPointMake(0,10);
        searchObj = [[ItemTableView alloc] initWithNibName:@"ItemTableView" bundle:nil];
		
		searchObj.getStr = mlabel.text;
		
		
        [subitem resignFirstResponder];
      //  NSLog(@"share item text : %@", subitem.text);
        searchObj.shareItemName = mlabel.text;
        [self presentModalViewController:searchObj animated:YES];
        
        //[searchObj release];
        //searchObj=nil;
	}

	if([textField isEqual:subitemProtein]){
		SignUpScrollView.contentOffset = CGPointMake(0,90);
	}
	if([textField isEqual:subitemCarbohydrates]){
		SignUpScrollView.contentOffset = CGPointMake(0,110);
	}
	if([textField isEqual:subitemFat]){
		SignUpScrollView.contentOffset = CGPointMake(0,130);
	}
	if([textField isEqual:subitemCalorie]){
		SignUpScrollView.contentOffset = CGPointMake(0,160);
	}

}
/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	
	//NSLog(@"textField shouldChangeCharactersInRange");
	
	if (textField.tag == 1 || textField.tag == 2 || textField.tag == 3 || textField.tag == 4) {
		
	
	static NSCharacterSet *charSet = nil;
    if(!charSet) {
        charSet = [[[NSCharacterSet characterSetWithCharactersInString:@"0123456789.."] invertedSet] retain];
    }
    NSRange location = [string rangeOfCharacterFromSet:charSet];
    return (location.location == NSNotFound);
	}
	
	
	//return YES;
}




- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	
	
	//NSLog(@"textFieldShouldReturn");
	
    [theTextField resignFirstResponder];
	SignUpScrollView.contentOffset = CGPointMake(0,0);
	mlabel.text=[subitem.text uppercaseString];
	if ([newData1 count]==0)
	{
		
	}
	
	return YES;
}
*/
#pragma mark 
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}
- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}
- (void)dealloc {
    [super dealloc];
	[arrayNo release];
	[tempDic1 release];
	[newData1 release];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[hud removeFromSuperview];
	[hud release];
	hud = nil;
}

@end