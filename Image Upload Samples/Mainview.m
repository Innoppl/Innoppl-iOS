//
//  Mainview.m
//  iBand
//
//  Created by Innoppl tech on 3/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Mainview.h"
#import "mediaplayer.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "UIView+Screenshot.h"
#import "searchview.h"
#import "ChatList.h"
@implementation Mainview
@synthesize control,control2;
@synthesize transitionLayer,layer2,networkQueue,Videos,Images,Chat,videourlarray;
NSMutableArray *postarray;
NSMutableArray *posttime;
UIImagePickerController *Profilepicker;
UIScrollView *scrollview;
NSString *poststr;
NSArray *exap;
UIButton *profilebtn;
UIImagePickerController *pickerview;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
     [NSThread detachNewThreadSelector:@selector(secondThread) toTarget:self withObject:nil];        
	[super viewWillAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
   
   // Invalidating the timer 
    if ([timer isValid]) {
        [timer invalidate];
    }

    
}
- (void) secondThread{  
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];  
    
    // Create a time for the thread  
    timer = [NSTimer timerWithTimeInterval:180 target:self selector:@selector(timerCallBack) userInfo:nil repeats:YES];  

    // Add the timer to the run loop  
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];      
    [[NSRunLoop currentRunLoop] run];  
    [pool release];  
    
}  

- (void)dealloc
{   
    [profileview release];
    [imageuploadviw release];
    [videouploadviw release];
    [tableView release];
    [scrollview release];
    [videosarray release];
    [self.videourlarray release];
    [ImageArray release];
    AbMob.delegate = nil;
    [AbMob release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self performSelector:@selector(doNetworkOperations) withObject:nil afterDelay:0.4];

    mainalert = [[UIAlertView alloc] initWithTitle:@"Loading....." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] ;
    [mainalert show];
    mainactivityindicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    mainactivityindicator.center = CGPointMake( 140,  65);
    [mainactivityindicator startAnimating];
    [mainalert addSubview:mainactivityindicator]; 
    alertyes=YES;
    videoalert_yes=NO;
    imagealert_yes=NO;
    self.videourlarray=[[NSMutableArray alloc]init];
    ImageArray =[[NSMutableArray alloc]init];
    videosarray=[[NSMutableArray alloc]init];    
    namearray =[[NSMutableArray alloc]init];
    postarray=[[NSMutableArray alloc]init];
    posttime=[[NSMutableArray alloc]init];
    
    scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0,0 , self.view.frame.size.width,420)];
    scrollview.scrollEnabled=YES;
    [self.view addSubview:scrollview];

    
    //...........................IMAGEVIEW..........................//   

    
    imageuploadviw=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,420)];
    [imageuploadviw setBackgroundColor:[UIColor orangeColor]];
     [self.view addSubview:imageuploadviw];
    
    UIImageView *imageupload=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg.png"]];
    imageupload.frame=CGRectMake(0, 0,imageuploadviw.frame.size.width, imageuploadviw.frame.size.height);
    imageupload.userInteractionEnabled=YES;
    [imageuploadviw addSubview:imageupload];
    [imageuploadviw release];
    
    [imageupload addSubview:[self btn:CGRectMake(85, 360, 155,30 ) img:@"btn_bg.png" num:1]];
    [imageupload release];

    [imageuploadviw addSubview:[self imgrect:CGRectMake(0, 0, 320,35)]];
    
    [imageuploadviw addSubview:[self lbl:CGRectMake(130,0 , 150, 30) str:@"Pictures"]];
    
    //...........................VIDEOVIEW..........................//   

    videouploadviw=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 420)];
    [videouploadviw setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:videouploadviw];
    
    UIImageView *videoupload=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg.png"]];
    videoupload.frame=CGRectMake(0, 0,videouploadviw.frame.size.width,videouploadviw.frame.size.height);
    videoupload.userInteractionEnabled=YES;
    [videouploadviw addSubview:videoupload];

    [videoupload addSubview:[self btn:CGRectMake(85, 360, 155,30 ) img:@"btn_bg.png" num:301]];
    [videoupload release];
    [videouploadviw addSubview:[self imgrect:CGRectMake(0, 0, 320,35)]];

    [videouploadviw addSubview:[self lbl:CGRectMake(133,0 , 150, 30) str:@"Videos"]];
    [videouploadviw release];

    //[topimage1 release];

    
//...........................MOREVIEW..........................//   
    
    
    MoreTabview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,410)];
    [self.view addSubview:MoreTabview];
    UIImageView *moreimg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg.png"]];
    moreimg.frame=CGRectMake(0, 0,MoreTabview.frame.size.width, MoreTabview.frame.size.height);
    moreimg.userInteractionEnabled=YES;
    [MoreTabview addSubview:moreimg];
    [MoreTabview addSubview:[self imgrect:CGRectMake(0, 0, 320,35)]];
    [MoreTabview addSubview:[self lbl:CGRectMake(138,0 , 150, 30) str:@"More"]];
    [moreimg release];

    [super viewDidLoad];


//...............PROFILEVIEW.....................................//
  
    profileview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 410)];
     [profileview setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    [scrollview addSubview:profileview];


    tableView= [[UITableView alloc] initWithFrame:CGRectMake(0,145,320, 180) style:UITableViewStyleGrouped];
    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    [profileview addSubview:tableView];
    [tableView release];
   
   
    posttextfield=[[UITextField alloc]initWithFrame:CGRectMake(10, 330, 300,25)];
    posttextfield.delegate=self;
    posttextfield.borderStyle=UITextBorderStyleRoundedRect;
    posttextfield.returnKeyType=UIReturnKeyDone;
    posttextfield.placeholder=@"Write something..";
    [profileview addSubview:posttextfield];
    [posttextfield release];
    
   
    
    NSURL *imageURL = [NSURL URLWithString:[[iBandAppDelegate getGlobalInfo] objectForKey:@"url"]];
    NSData *data =  [NSData dataWithContentsOfURL:imageURL];  
    UIImage *proimage = [[UIImage alloc] initWithData:data] ;

    profilebtn =[UIButton buttonWithType:UIButtonTypeCustom];
    profilebtn.frame=CGRectMake(20,40, 100, 100);
    [profilebtn setTag:302];
    [profilebtn addTarget:self action:@selector(Button_Action:) forControlEvents:UIControlEventTouchUpInside];
    if (!proimage) {
        NSLog(@"no");
        UIImage *image = [UIImage imageNamed:@"profile default.jpeg"];
        [profilebtn setBackgroundImage:image forState:UIControlStateNormal];
    }else{
    [profilebtn setBackgroundImage:proimage forState:UIControlStateNormal];

    }
    [profileview addSubview:profilebtn];
    
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(130, 28, 165, 57)];
    
    lable.font=[UIFont boldSystemFontOfSize:20];
    lable.lineBreakMode=UILineBreakModeTailTruncation;
    lable.numberOfLines=2;
    [lable setBackgroundColor:[UIColor clearColor]];
    [lable setTextColor:[UIColor whiteColor]];
    [profileview addSubview:lable];
    [lable release];
   
    
    [profileview addSubview:[self profilelbl:CGRectMake(130,74 , 150, 25) str:@"Gender"]];

    [profileview addSubview:[self profilelbl:CGRectMake(130,94 , 170, 25) str:@"Joined"]];
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *datestr=[[iBandAppDelegate getGlobalInfo] objectForKey:@"join"];
    NSDate *startDate = [formatter dateFromString:datestr];
    NSDate *endDate=[NSDate date];
    
    // This performs the difference calculation
    unsigned flags = NSDayCalendarUnit;
    NSDateComponents *difference = [[NSCalendar currentCalendar] components:flags fromDate:startDate toDate:endDate options:0];
    
    NSString *endstr=[NSString stringWithFormat:@"%ld days ago",[difference day]];
    
    [profileview addSubview:[self profilelbl:CGRectMake(220,94 , 170, 25) str:endstr]];
    [profileview addSubview:[self profilelbl:CGRectMake(130, 114, 170, 25) str:@"Profile hits"]];
    [profileview addSubview:[ self profilelbl:CGRectMake(220, 114, 170, 25) str:[[iBandAppDelegate getGlobalInfo] objectForKey:@"profilehits"]]];
    
    lable.text=[[iBandAppDelegate getGlobalInfo] objectForKey:@"realname"];
    NSString *str=[[iBandAppDelegate getGlobalInfo] objectForKey:@"gender"];
    if ([str isEqualToString:@"M"]||[str isEqualToString:@"m"]||[str isEqualToString:@"male" ]) 
    {
        [profileview addSubview:[self profilelbl:CGRectMake(220, 74, 150, 25) str:@"Male"]];

    }else if([str isEqualToString:@"F"]||[str isEqualToString:@"f"]||[str isEqualToString:@"female"])
    {
        [profileview addSubview:[self profilelbl:CGRectMake(220, 74, 150, 25) str:@"Female"]];

    }
        
    imageuploadviw.hidden=YES;
    videouploadviw.hidden=YES;
    MoreTabview.hidden=YES;
 
//***************  Custom Tabbar Image **************//
    
    UIImageView *Tabbar=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bottom_tab.png"]];
    Tabbar.frame=CGRectMake(0, 410, 320,55);
    Tabbar.userInteractionEnabled=YES;
    [self.view addSubview:Tabbar];
    [Tabbar release];
  
    //............Tabbar item 1 ..............//
   
    item1=[UIButton buttonWithType:UIButtonTypeCustom];
    item1.frame=CGRectMake(5, 410,70, 45);
    [item1 setTag:1];
    [item1 setImage:[UIImage imageNamed:@"man_241.png"] forState:UIControlStateNormal];
    [item1 addTarget:self action:@selector(ChangetheView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:item1];
 
    //............. Tabar item 2 ..............//  
    
    item2=[UIButton buttonWithType:UIButtonTypeCustom];
    item2.frame=CGRectMake(85, 410,70, 45);
    [item2 setTag:2];
    [item2 setImage:[UIImage imageNamed:@"video_24.png"] forState:UIControlStateNormal];
    [item2 addTarget:self action:@selector(ChangetheView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:item2];

    //............. Tabar item 3 ..............//  

    item3=[UIButton buttonWithType:UIButtonTypeCustom];
    item3.frame=CGRectMake(170, 410,70, 45);
    [item3 setTag:3];
    [item3 setImage:[UIImage imageNamed:@"photo_24.png"] forState:UIControlStateNormal];
    [item3 addTarget:self action:@selector(ChangetheView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:item3];
   
    //............. Tabar item 4 ..............//  
 
    item4=[UIButton buttonWithType:UIButtonTypeCustom];
    item4.frame=CGRectMake(250, 410,70, 45);
    [item4 setTag:4];
    [item4 addTarget:self action:@selector(ChangetheView:) forControlEvents:UIControlEventTouchUpInside];
    [item4 setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
    [self.view addSubview:item4];
   
    UILabel *MYWALL=[[UILabel alloc]initWithFrame:CGRectMake(15,440,60,20)];
    [MYWALL setText:@"MYWALL"];
    [MYWALL setTextColor:[UIColor whiteColor]];
    [MYWALL setFont:[UIFont boldSystemFontOfSize:12]];
    [MYWALL setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:MYWALL];
    [MYWALL release];
    
    UILabel *PICTURE=[[UILabel alloc]initWithFrame:CGRectMake(177,440,60,20)];
    [PICTURE setText:@"PICTURE"];
    [PICTURE setTextColor:[UIColor whiteColor]];
    [PICTURE setFont:[UIFont boldSystemFontOfSize:12]];
    [PICTURE setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:PICTURE];
    [PICTURE release];
    
    UILabel *VIDEO=[[UILabel alloc]initWithFrame:CGRectMake(101,440,60,20)];
    [VIDEO setText:@"VIDEO"];
    [VIDEO setTextColor:[UIColor whiteColor]];
    [VIDEO setFont:[UIFont boldSystemFontOfSize:12]];
    [VIDEO setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:VIDEO];
    [VIDEO release];
    
    UILabel *MORE=[[UILabel alloc]initWithFrame:CGRectMake(267,440,60,20)];
    [MORE setText:@"MORE"];
    [MORE setTextColor:[UIColor whiteColor]];
    [MORE setFont:[UIFont boldSystemFontOfSize:12]];
    [MORE setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:MORE];
    [MORE release];

    [profileview addSubview:[self imgrect:CGRectMake(0, 0, 320,35)]];

    UIButton *signout=[UIButton buttonWithType:UIButtonTypeCustom];
    signout.frame=CGRectMake(250, 5,67,23);
    [signout setTag:5];
    [signout setTitle:@"Sign Out" forState:UIControlStateNormal];
    [signout addTarget:self action:@selector(SignOut:) forControlEvents:UIControlEventTouchUpInside];
    signout.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    [signout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [signout setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
    [profileview addSubview:signout];

    [profileview addSubview:[self lbl:CGRectMake(130,0 , 150, 30) str:@"My Wall"]];
    
    
    UIButton *refreshbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    refreshbtn.frame=CGRectMake(12,4,67,23);
    [refreshbtn setTag:99];
    [refreshbtn setTitle:@"Refresh" forState:UIControlStateNormal];
    refreshbtn.titleLabel.font=[UIFont boldSystemFontOfSize:14];

    [refreshbtn addTarget:self action:@selector(SignOut:) forControlEvents:UIControlEventTouchUpInside];
    [videouploadviw addSubview:refreshbtn];
    [refreshbtn setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
    
    [self loadtheImageview];
    [self loadvideosview];

    
    _adBannerViewIsVisible=YES;
       
    // Do any additional setup after loading the view from its nib.
}

//********** ADMOB Creation ***************//

-(void)admobview{
    
    AbMob = [[GADBannerView alloc]initWithAdSize:kGADAdSizeBanner];
    AbMob.adUnitID = @"a14fd7057dcc75c";
    AbMob.delegate=self;
    AbMob.rootViewController = self;
    [self.view addSubview:AbMob];

    [AbMob loadRequest:[GADRequest request]];

}

//********* Add the services to network queue *********//
- (void)doNetworkOperations
{
    [[self networkQueue] cancelAllOperations];
    
    [self setNetworkQueue:[ASINetworkQueue queue]];
    [[self networkQueue] setDelegate:self];
    [[self networkQueue] setRequestDidFinishSelector:@selector(requestFinished:)];
    [[self networkQueue] setQueueDidFinishSelector:@selector(queueFinished:)];
    [[self networkQueue] setRequestDidFailSelector:@selector(requestFailed:)];
    
    ASIFormDataRequest *homeRequest = [self getimages];
    ASIFormDataRequest *awayRequest = [self getvideo];
    
    [[self networkQueue] addOperation:homeRequest];
    [[self networkQueue] addOperation:awayRequest];
     [[self networkQueue] addOperation:eventRequest];
    
    [[self networkQueue] go];
}
#pragma mark - Event Request

- (ASIFormDataRequest *)getimages
{
    [ImageArray removeAllObjects];
    NSURL *url=[NSURL URLWithString:ConnecttoSoap_response];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    NSLog(@"id %@",[[iBandAppDelegate getGlobalInfo]objectForKey:@"id"]);
    [request setRequestMethod:@"POST"];
    [request setPostValue:[[iBandAppDelegate getGlobalInfo]objectForKey:@"id"] forKey:@"params[uid]"];
    [request addPostValue: @"kalyan-innoppl-10" forKey:@"accesskey"];
    [request addPostValue:@"get_images" forKey:@"methodkey"];
    [request setDelegate:self];

    [request setDidFinishSelector:@selector(DownloadRequestFinished:)];
    [request setDidFailSelector:@selector(DownloadRequestFailed:)];

    
    [request setCompletionBlock:^{
        self.Images = @"HomeTeam!";
    }];
    return request;
}

- (ASIFormDataRequest *)getvideo
{
    [videosarray removeAllObjects];
    [self.videourlarray removeAllObjects];
    NSURL *url=[NSURL URLWithString:ConnecttoSoap_response];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    
    [request setRequestMethod:@"POST"]; 
    [request setPostValue:[[iBandAppDelegate getGlobalInfo]objectForKey:@"id"] forKey:@"params[uid]"];
    [request addPostValue: @"kalyan-innoppl-10" forKey:@"accesskey"];
    [request addPostValue:@"get_videos" forKey:@"methodkey"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(DownloadVideoRequestFinished:)];
    [request setDidFailSelector:@selector(DownloadRequestFailedforvideos:)];
    [request setCompletionBlock:^{
        self.Videos = @"Away Team!";
    }];
    
    return request;
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
   
}

- (void)queueFinished:(ASIHTTPRequest *)request
{

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
}

-(void)timerCallBack{
    [[self getvideo] startSynchronous];
    
}
-(void)loadtheImageview
{

 
	ZBGridControl *aControl = [[ZBGridControl alloc] initWithFrame:CGRectMake(0, 35, 320, 320)];
	self.control = [aControl autorelease];
    [control setBackgroundColor:[UIColor clearColor]];
	[imageuploadviw addSubview:self.control];
	self.control.dataSource = self;
    
    
 }

-(void)UploadProfileimage:(id)sender{
    UIActionSheet *obj=[[UIActionSheet alloc]initWithTitle:@"Capture Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose from Gallery",@"Take a Photo", nil];
    obj.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [obj setTag:111];
    [obj showInView:self.view];
    [obj release];

}
//********* Tabbar Button Actions **************//
-(void)ChangetheView:(id)sender
{
    if ([sender tag ] == 1) {
        [item1 setImage:[UIImage imageNamed:@"man_241.png"] forState:UIControlStateNormal];
        [item2 setImage:[UIImage imageNamed:@"video_24.png"] forState:UIControlStateNormal];
        [item3 setImage:[UIImage imageNamed:@"photo_24.png"] forState:UIControlStateNormal];
        [item4 setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
        MoreTabview.hidden=YES;
        videouploadviw.hidden=YES;
        imageuploadviw.hidden=YES;
        profileview.hidden=NO;
        AbMob.hidden=NO;

    }else if([sender tag ]==2){
        if ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != ReachableViaWiFi) {
            
        [item1 setImage:[UIImage imageNamed:@"man_241.png"] forState:UIControlStateNormal];
        [item2 setImage:[UIImage imageNamed:@"video_24.png"] forState:UIControlStateNormal];
        [item3 setImage:[UIImage imageNamed:@"photo_24.png"] forState:UIControlStateNormal];
        [item4 setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
        MoreTabview.hidden=YES;
        videouploadviw.hidden=YES;
        imageuploadviw.hidden=YES;
        profileview.hidden=NO;
        AbMob.hidden=NO;
        UIAlertView *popalert=[[UIAlertView alloc]initWithTitle:@"" message:@"Videos must be viewed on WIFI enabled networks and cannot be viewed on 3G" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [popalert show];
        [popalert release];
        }else
        {
        AbMob.hidden=YES;
        MoreTabview.hidden=YES;
        profileview.hidden=YES;
        videouploadviw.hidden=NO;
        imageuploadviw.hidden=YES;
        [item1 setImage:[UIImage imageNamed:@"man_24.png"] forState:UIControlStateNormal];
        [item2 setImage:[UIImage imageNamed:@"video_241.png"] forState:UIControlStateNormal];
        [item3 setImage:[UIImage imageNamed:@"photo_24.png"] forState:UIControlStateNormal];
        [item4 setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
        }
    }else if([sender tag]==3){
        AbMob.hidden=YES;
        MoreTabview.hidden=YES;
        imageuploadviw.hidden=NO;
        videouploadviw.hidden=YES;
        profileview.hidden=YES;
        [item1 setImage:[UIImage imageNamed:@"man_24.png"] forState:UIControlStateNormal];
        [item4 setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
        [item2 setImage:[UIImage imageNamed:@"video_24.png"] forState:UIControlStateNormal];
        [item3 setImage:[UIImage imageNamed:@"photo_241.png"] forState:UIControlStateNormal];

    }else if([sender tag]==4){
        AbMob.hidden=YES;
        [item1 setImage:[UIImage imageNamed:@"man_24.png"] forState:UIControlStateNormal];
        [item2 setImage:[UIImage imageNamed:@"video_24.png"] forState:UIControlStateNormal];
        [item3 setImage:[UIImage imageNamed:@"photo_24.png"] forState:UIControlStateNormal];
        [item4 setImage:[UIImage imageNamed:@"More1.png"] forState:UIControlStateNormal];
        MoreTabview.hidden=NO;
        profileview.hidden=YES;
        imageuploadviw.hidden=YES;
        videouploadviw.hidden=YES;
    }

}

-(void)loadvideosview
{
 
	ZBGridvideoControl *videoControl = [[ZBGridvideoControl alloc] initWithFrame:CGRectMake(0, 35, 320, 320)];
	//aControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
	self.control2 = [videoControl autorelease];
    [control2 setBackgroundColor:[UIColor clearColor]];
	[videouploadviw addSubview:self.control2];
	self.control2.dataSource = self;


}

-(void)SignOut:(id)sender{
    if ([sender tag]==99) {
        mainalert = [[UIAlertView alloc] initWithTitle:@"Loading....." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        [mainalert show];
        
        mainactivityindicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        mainactivityindicator.center = CGPointMake( 140,  65);
        [mainactivityindicator startAnimating];
        [mainalert addSubview:mainactivityindicator]; 
        
        alertyes=YES;
        [[self getvideo] startAsynchronous];

        
    }else{ 
    
        NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [cookies deleteCookie:cookie];
    }
    NSString *soapMsg = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                         "<soap:Body>\n"
                         "<logout xmlns=\"http://tempuri.org/\">\n"
                         "<user_id>%@</user_id>\n"
                         "</logout>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n",[[iBandAppDelegate getGlobalInfo] objectForKey:@"id"]];
    
    NSURL *url = [NSURL URLWithString:ConnecttoSoap_server];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    // request.shouldPresentCredentialsBeforeChallenge = YES;
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request appendPostData:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    [request setRequestMethod:@"POST"];
    //[request setTimeOutSeconds:60];
    [request setDidFinishSelector:@selector(Sucessresponse:)];
 //   [request setDidFailSelector:@selector(Failresponse:)];
    [request startAsynchronous];

    [self.navigationController popViewControllerAnimated:YES];
    //[[iBandAppDelegate getGlobalInfo] removeAllObjects];
    }
}
-(void)Sucessresponse:(ASIFormDataRequest*)req
{
    NSString *responseString = [req responseString];
    
    NSLog(@"Upload response %@", responseString);
}
-(void)viduplodbtnpressed:(id)sender{
    if([sender tag]==888){
        imageuploadviw.hidden=YES;
        videouploadviw.hidden=NO;
        profileview.hidden=YES;
      //  [self.navigationController pushViewController:signup animated:YES];
        
    }else if([sender tag]==999)
    {
        imageuploadviw.hidden=NO;
        videouploadviw.hidden=YES;
         profileview.hidden=YES;
    }else if([sender tag]==777)
    {
        profileview.hidden=NO;
        imageuploadviw.hidden=YES;
        videouploadviw.hidden=YES;
    }
}



#pragma mark - Button Action & Image Picker

-(void)Button_Action:(id)sender
{
    if ([sender tag]==1) {
  // Profile image updating 
    UIActionSheet *obj=[[UIActionSheet alloc]initWithTitle:@"Capture Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose from Gallery",@"Take a Photo", nil];
        obj.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
        [obj setTag:111];
    [obj showInView:self.view];
    [obj release];
    }else if([sender tag]==301){
 // Videos uploading 
        UIActionSheet *obj1=[[UIActionSheet alloc]initWithTitle:@"Capture Video" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose from Gallery",@"Take a Video", nil];
        obj1.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
        [obj1 setTag:222];
        [obj1 showInView:self.view];
        [obj1 release];
        
        
    }else if([sender tag]==302){
 // images uploading       
        UIActionSheet *obj2=[[UIActionSheet alloc]initWithTitle:@"Capture Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose from Gallery",@"Take a Photo", nil];
        obj2.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
        [obj2 setTag:333];
        [obj2 showInView:self.view];
        [obj2 release];

    }
}


/*****************************************************************************

 Code  For Picking image From Gallery Or Camera And Upload it to a server

/*****************************************************************************/
 

#pragma mark ActionSheet Delegate
//************ Action Sheet Delegate ***********//
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
        
       
        if (actionSheet.tag==111) {
  // Update profile image button clicked          
               pickerview=[[UIImagePickerController alloc]init];
               pickerview.delegate=self;
           if(buttonIndex==0)
           {
                // [picker tag:11];
               pickerview.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
               [self presentModalViewController:pickerview animated:YES];
           }
           else if(buttonIndex==1)
           {
            
           
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera ]) {
                
                pickerview.sourceType=UIImagePickerControllerSourceTypeCamera;
                pickerview.cameraDevice=UIImagePickerControllerCameraDeviceFront;
                pickerview.allowsEditing=YES;
                [self presentModalViewController:pickerview animated:YES];

                }else{
                UIAlertView   *al = [[UIAlertView alloc] initWithTitle:@"" message:@"No Camera available" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] ;
                [al show];
                [al release];
            }
                       
            }else if(buttonIndex==2){
            
            [self dismissModalViewControllerAnimated:YES];
        }
        }else if(actionSheet.tag==222){
       // Upload video button clicked     
                pickerview=[[UIImagePickerController alloc]init];
                pickerview.delegate=self;

            if (buttonIndex==0) {
                pickerview.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                pickerview.mediaTypes =  [NSArray arrayWithObjects:(NSString*)kUTTypeMovie, nil];
                pickerview.allowsEditing=NO;
                [self presentModalViewController:pickerview animated:YES];
             }
             else if(buttonIndex==1){
                
                
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera ]) {
                    
                pickerview.sourceType = UIImagePickerControllerSourceTypeCamera;
                pickerview.allowsEditing = YES;
                pickerview.cameraDevice=UIImagePickerControllerCameraDeviceFront;
                //  picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
                pickerview.mediaTypes =  [NSArray arrayWithObjects:(NSString*)kUTTypeMovie, nil];
                //  picker.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
                    
                [self presentModalViewController:pickerview animated:YES];                    
                }else{
                UIAlertView   *al = [[UIAlertView alloc] initWithTitle:@"" message:@"No Camera available" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [al show];
                [al release];
                }
                   
              }else if(buttonIndex==2){
            
               [self dismissModalViewControllerAnimated:YES];
           }
        }else if(actionSheet.tag==333){
        
        // Upload the images button clicked    
               Profilepicker =[[UIImagePickerController alloc]init];
               Profilepicker.delegate=self;
               if (buttonIndex==0) {
               Profilepicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
               [self presentModalViewController:Profilepicker animated:YES];

               }
               else if(buttonIndex==1){
                
                   if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera ]) {
                    
               Profilepicker.sourceType=UIImagePickerControllerSourceTypeCamera;
               Profilepicker.cameraDevice=UIImagePickerControllerCameraDeviceFront;
               Profilepicker.allowsEditing=YES;
               [self presentModalViewController:Profilepicker animated:YES]; 
                    
                   }else{
               UIAlertView   *al = [[UIAlertView alloc] initWithTitle:@"" message:@"No Camera available" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
               [al show];
               [al release];
                }
               }
               else if(buttonIndex==2){
                
            [self dismissModalViewControllerAnimated:YES];
            }

        }
        
        
}

#pragma mark PickerView Delegate
//*********************** Picker View Delegates ****************//

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info 
    {
        if (picker==Profilepicker) {
      //.........Updating of profile picture...........//      
            self.view.userInteractionEnabled=NO;
            UIImage *img=[info objectForKey:UIImagePickerControllerOriginalImage];
            UIGraphicsBeginImageContext(CGSizeMake(320,480)); 
            [img drawInRect:CGRectMake(0, 0,320,480)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext(); 
            UIGraphicsEndImageContext();
            
            NSData *imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation(newImage, 0.5)];  
            [profilebtn setImage:img forState:UIControlStateNormal];
            NSMutableString *imageName = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
           // Generating unique name 
            CFUUIDRef theUUID = CFUUIDCreate(kCFAllocatorDefault);
            if (theUUID) {
                [imageName appendString:NSMakeCollectable(CFUUIDCreateString(kCFAllocatorDefault, theUUID))];
                CFRelease(theUUID);
            }
            [imageName appendString:@".png"];
            NSURL *url = [NSURL URLWithString:ConnecttoFile_server];
       // Calling the service to update profile picture     
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            [request addPostValue:imageName forKey:@"name"];
            
            // Upload an image
            [request setData:imageData withFileName:imageName andContentType:@"image/jpeg" forKey:@"userfile"];
            [request setRequestMethod:@"POST"];
            [request setPostValue:[[iBandAppDelegate getGlobalInfo]objectForKey:@"id"] forKey:@"profile_id"];
            [request appendPostData:[@"" dataUsingEncoding:NSUTF16StringEncoding]];
            
            [request setDelegate:self];
            [request setDidFinishSelector:@selector(ProfileImageUpload:)];
            [request setDidFailSelector:@selector(ProfileImageFailedUpload:)];
            [request startAsynchronous];
            [imageData release];
            

            [self dismissModalViewControllerAnimated:YES];
        }else if(picker==pickerview) {
        // Uploading of video    
            NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
           if ([type isEqualToString:(NSString *)kUTTypeVideo] || 
            [type isEqualToString:(NSString *)kUTTypeMovie]) { // movie != video
            NSURL *videoURL =[info objectForKey:UIImagePickerControllerMediaURL];
            NSData *videodata = [[NSData alloc] initWithContentsOfURL:videoURL];
            NSMutableString *videoname = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
        // Generating unique name 
 
            CFUUIDRef theUUID = CFUUIDCreate(kCFAllocatorDefault);
            if (theUUID) {
                [videoname appendString:NSMakeCollectable(CFUUIDCreateString(kCFAllocatorDefault, theUUID))];
                CFRelease(theUUID);
            }
            [videoname appendString:@".mp4"];
  
            alertview = [[[UIAlertView alloc] initWithTitle:@"Loading....." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
            [alertview show];
            
            VideoactivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            
            
            VideoactivityIndicator.center = CGPointMake( 140,  65);
            [VideoactivityIndicator startAnimating];
            [alertview addSubview:VideoactivityIndicator]; 
               videoalert_yes=YES;
            NSURL *url = [NSURL URLWithString:ConnecttoFile_server];
               // Calling the service to upload video      
 
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            [request addPostValue:videoname forKey:@"name"];
            
            // Upload an video
            [request setData:videodata withFileName:videoname andContentType:@"video/mp4" forKey:@"userfile"];
            [request setRequestMethod:@"POST"];
            [request setPostValue:[[iBandAppDelegate getGlobalInfo]objectForKey:@"id"] forKey:@"id"];
            [request appendPostData:[@"" dataUsingEncoding:NSUTF16StringEncoding]];
            [request setDelegate:self];
            request.timeOutSeconds=120;
            request.numberOfTimesToRetryOnTimeout=2;
            [request setDidFinishSelector:@selector(uploadvideoRequestFinished:)];
            [request setDidFailSelector:@selector(uploadRequestFailed:)];
            
            [request startAsynchronous];
            [videodata release];
            [self dismissModalViewControllerAnimated:YES];
        }else if ([type isEqualToString:@"public.image"]) {
            
         // Uploading the pictures to our album   
            UIImage *im = [info objectForKey:@"UIImagePickerControllerOriginalImage"] ;
            UIGraphicsBeginImageContext(CGSizeMake(320,480)); 
            [im drawInRect:CGRectMake(0, 0,320,480)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext(); 
            UIGraphicsEndImageContext();
            
            NSData *imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation(newImage, 0.5)];        
            NSMutableString *imageName = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
            // Generating unique name for the images
            CFUUIDRef theUUID = CFUUIDCreate(kCFAllocatorDefault);
            if (theUUID) {
                [imageName appendString:NSMakeCollectable(CFUUIDCreateString(kCFAllocatorDefault, theUUID))];
                CFRelease(theUUID);
            }
            [imageName appendString:@".png"];
            
            alert = [[[UIAlertView alloc] initWithTitle:@"Loading....." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
            [alert show];
            
            activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            
            // Adjust the indicator so it is up a few pixels from the bottom of the alert
            activityIndicator.center = CGPointMake( 140,  65);
            [activityIndicator startAnimating];
            [alert addSubview:activityIndicator];
            imagealert_yes=YES;
            NSURL *url = [NSURL URLWithString: ConnecttoFile_server];
            // Calling the service to upload image      
 
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            [request addPostValue:imageName forKey:@"name"];
            
            // Upload an image
            [request setData:imageData withFileName:imageName andContentType:@"image/jpeg" forKey:@"userfile"];
            [request setRequestMethod:@"POST"];
            [request setPostValue:[[iBandAppDelegate getGlobalInfo]objectForKey:@"id"] forKey:@"id"];
            [request appendPostData:[@"" dataUsingEncoding:NSUTF16StringEncoding]];
            [request setDelegate:self];
            [request setDidFinishSelector:@selector(uploadRequestFinished:)];
            [request setDidFailSelector:@selector(uploadRequestFailed:)];
            [request startAsynchronous];
           
            [imageData release];

            [picker dismissModalViewControllerAnimated:YES];
        }
        [picker release];
        }
    }
-(void)ProfileImageUpload:(ASIHTTPRequest*)req{
    NSString *responseString = [req responseString];
    self.view.userInteractionEnabled=YES;
    
}
-(void)ProfileImageFailedUpload:(ASIHTTPRequest*)req{
    UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"Error" message:[[req error]localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alt show];
    [alt release];

}
-(void)uploadvideoRequestFinished:(ASIHTTPRequest*)request
{
    NSString *responseString = [request responseString];

    if ([responseString isEqualToString: @"success"]) {
        [[self getvideo] startAsynchronous];
     }

}

- (void)uploadRequestFinished:(ASIHTTPRequest *)request{    
    NSString *responseString = [request responseString];


    if ([responseString isEqualToString: @"success"]) {
        
        [[self getimages] startAsynchronous];
    }

}
//..........Service request failed ...............//

- (void)uploadRequestFailed:(ASIHTTPRequest *)request{
    if (imagealert_yes) {
        [activityIndicator stopAnimating];
        [activityIndicator release];
        [alert dismissWithClickedButtonIndex:0 animated:NO];
        imagealert_yes=NO;
    }
    if (videoalert_yes) {
        [VideoactivityIndicator stopAnimating];
        [VideoactivityIndicator release];
        [alertview dismissWithClickedButtonIndex:0 animated:YES];
        videoalert_yes=NO;
    }
    
    UIAlertView *alet=[[UIAlertView alloc]initWithTitle:@"Error" message:[[request error] localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alet show];
    [alet release];
}

//..........Video Upload request ...............//

-(void)DownloadVideoRequestFinished:(ASIHTTPRequest*)request{
    NSString *responseString = [request responseString];
    NSString *trim = [responseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    const char *urtfstring = [trim UTF8String];
    //NSError *error;
    if (responseString!=NULL) {
        NSData *someData = [NSData dataWithBytes:urtfstring length:strlen(urtfstring)];
        xmlvideoparser=[[[NSXMLParser alloc] initWithData:someData] autorelease];
        xmlvideoparser.delegate=self;    
        [xmlvideoparser setShouldResolveExternalEntities: YES];
        [xmlvideoparser parse];
    }
}
-(void)DownloadRequestFailedforvideos:(ASIHTTPRequest*)req{
    if (alertyes) {
        [mainactivityindicator stopAnimating];
        [mainactivityindicator release];
        [mainalert dismissWithClickedButtonIndex:0 animated:YES];
        [mainalert release];
        alertyes=NO;
    }
    
    UIAlertView *responsealert=[[UIAlertView alloc]initWithTitle:@"Error" message:[[req error]localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [responsealert show];
    [responsealert release];
}





-(void)DownloadRequestFinished:(ASIHTTPRequest*)request
{

    NSString *responseString = [request responseString];
     if (responseString!=NULL) {
        
    
    NSString *trim = [responseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    const char *urtfstring = [trim UTF8String];
        
    NSData *someData = [NSData dataWithBytes:urtfstring length:strlen(urtfstring)];


    if(xmlparser!=nil && [NSXMLParser retainCount]>0)
    { xmlparser.delegate=nil; 
        [NSXMLParser release]; 
        xmlparser=nil;
    }

    xmlparser=[[NSXMLParser alloc] initWithData:someData];
	xmlparser.delegate=self;    
    [xmlparser setShouldResolveExternalEntities: YES];
	[xmlparser parse];
    }
    }
-(void)DownloadRequestFailed:(ASIHTTPRequest*)request{
    
    if (alertyes) {
        [mainactivityindicator stopAnimating];
        [mainactivityindicator release];
        [mainalert dismissWithClickedButtonIndex:0 animated:YES];
        [mainalert release];
        alertyes=NO;
    }
    
    UIAlertView *responsealert=[[UIAlertView alloc]initWithTitle:@"Error" message:[[request error]localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [responsealert show];
    [responsealert release];

}

#pragma mark - Tableview Delgate
//************Table view Delgate **************//
static CGFloat padding = 20.0;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([postarray count]>10) {
        return 10;
        
    }else{
    return [postarray count];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGSize  textSize = { 260.0, 10000.0 };
	CGSize size = [[postarray objectAtIndex:indexPath.row] sizeWithFont:[UIFont systemFontOfSize:14]
                                                      constrainedToSize:textSize 
                                                          lineBreakMode:UILineBreakModeWordWrap];
	
	size.height += padding*2;
	
	CGFloat height = size.height < 35 ? 35 : size.height;
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    CGRect cellRectangle;
    
    cellRectangle = CGRectMake(0.0, 0.0, 150, 30);
    
    UITableViewCell *cell=[[[UITableViewCell alloc]initWithFrame:cellRectangle reuseIdentifier:CellIdentifier] autorelease];
    
    
    cellRectangle = CGRectMake(10,0, 190, 30);

    // Configure the cell...
    UILabel *Name=[[UILabel alloc]initWithFrame:cellRectangle];
    Name.text=[namearray objectAtIndex:indexPath.row];
    Name.font=[UIFont boldSystemFontOfSize:16];
    [Name setBackgroundColor:[UIColor clearColor]];
    [Name setTextColor:[UIColor whiteColor]];
    //[Name sizeToFit];
    [cell.contentView addSubview:Name];
    [Name release];
   
  //  if (revers!=nil) {
    CGSize  textSize = { 260.0, 10000.0 };
	CGSize size = [[postarray objectAtIndex:indexPath.row] sizeWithFont:[UIFont systemFontOfSize:14]
                                                      constrainedToSize:textSize 
                                                          lineBreakMode:UILineBreakModeWordWrap];
	
	size.height += padding*2;
	
    cellRectangle = CGRectMake(10,10, 280, size.height);

    UILabel *posttext=[[UILabel alloc]initWithFrame:cellRectangle];
    posttext.text=[postarray objectAtIndex:indexPath.row];
    posttext.font=[UIFont systemFontOfSize:14];
    [posttext setTextColor:[UIColor whiteColor]];
    posttext.lineBreakMode=UILineBreakModeWordWrap;
    posttext.numberOfLines=10;
    [posttext sizeThatFits:size];
    [posttext setBackgroundColor:[UIColor clearColor]];
    [cell.contentView addSubview:posttext];
    [posttext release];
  //  }
   // cell.textLabel.text = [revers objectAtIndex:indexPath.row] ;
    cellRectangle = CGRectMake(220,0, 150, 30);
    //revers=[[posttime reverseObjectEnumerator]allObjects];

    UILabel *timeofpost=[[UILabel alloc]initWithFrame:cellRectangle];
    timeofpost.text=[posttime objectAtIndex:indexPath.row];
    [timeofpost setTextColor:[UIColor whiteColor]];
    [timeofpost setBackgroundColor:[UIColor clearColor]];
    timeofpost.font=[UIFont systemFontOfSize:10];
    [cell.contentView addSubview:timeofpost];
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    [timeofpost release];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setBackgroundColor:[UIColor darkGrayColor]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}

#pragma Mark -   Image ZBGridview Delegate 

//**************  ZBGridview Delegate  *************//

- (void)imageViewDidClose:(VideoView *)inController{
    
    [control performSelector:@selector(resetSelection) withObject:nil afterDelay:0.0];

    [self dismissModalViewControllerAnimated:NO];
}

- (void)imageViewControllerDidClose:(ZBGridImageViewController *)inController
{
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	[self.transitionLayer removeAllAnimations];
	self.transitionLayer.contents = (id)[inController.navigationController.view screenshot].CGImage;
	self.transitionLayer.hidden = NO;
	self.transitionLayer.frame = self.navigationController.view.bounds;
	[CATransaction commit];
	[control performSelector:@selector(resetSelection) withObject:nil afterDelay:0.0];
	self.transitionLayer = nil;
	[self dismissModalViewControllerAnimated:NO];
}

- (NSUInteger)numberOfItemsInGridControl:(ZBGridControl *)inControl
{
    
        return [ImageArray count];
    
    
}
- (UIImage *)imageForItemInGridControl:(ZBGridControl *)inControl atIndex:(NSUInteger)inIndex
{
        UIImage *image = [ImageArray objectAtIndex:inIndex];
        return image;
    	
}

- (void)gridContol:(ZBGridControl *)inControl didSelectItemAtIndex:(NSUInteger)inIndex withLayer:(CALayer *)inLayer;
{

    vid=[[VideoView alloc]initWithNibName:@"VideoView" bundle:nil];
    vid.delegate=self;

    vid.imgpoint=inIndex;
    vid.imageary=ImageArray;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration: 1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
    [self presentModalViewController:vid animated:YES];

    [UIView commitAnimations];
    [vid release];


}
#pragma Mark      -   VideoView Delegate
//************* Video Grid View Delegate **************//
- (NSUInteger)numberOfItemsInGridvideoControl:(ZBGridvideoControl *)inControl
{
    return [videosarray count];

}
- (UIImage *)videoForItemInGridvideoControl:(ZBGridvideoControl *)inControl atIndex:(NSUInteger)inIndex
{
    
    UIImage *videoimg=[videosarray objectAtIndex:inIndex];  
    return videoimg;

}
- (void)gridvideoContol:(ZBGridvideoControl *)inControl didSelectItemAtIndex:(NSUInteger)inIndex withLayer:(CALayer *)inLayer
{
    if ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != ReachableViaWiFi) {
        
        
    }else{
        
     NSURL *ur=[NSURL URLWithString:[self.videourlarray objectAtIndex:inIndex]];
     MPMoviePlayerViewController *movieplayer=[[MPMoviePlayerViewController alloc]initWithContentURL:ur];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:movieplayer.moviePlayer];
    movieplayer.moviePlayer.shouldAutoplay=YES;
    [self presentMoviePlayerViewControllerAnimated:movieplayer];
    ur=nil;
    [movieplayer release];
    }

}
- (void)moviePlayBackDidFinish:(NSNotification*)notification {
    [self dismissMoviePlayerViewControllerAnimated];
    [control2 performSelector:@selector(resetSelection) withObject:nil afterDelay:0.0];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}



#pragma Maek XMLParser Delegate

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
    
 
        }

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    
	if(tempstr!=nil && [tempstr retainCount]>0) { 
		[tempstr release];
        tempstr=nil; 
	}
	tempstr=[[NSString alloc] initWithString:string];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if (parser== xmlparser) {
        
        if([elementName isEqualToString:@"user_id"])
        {
                           
                
        }else if([elementName isEqualToString:@"data"]){
         
            NSURL *imageURL = [NSURL URLWithString:tempstr];
            
            NSData *data =  [NSData dataWithContentsOfURL:imageURL];        
            UIImage *image = [[UIImage alloc] initWithData:data];
            if (image!= NULL) {
                [ImageArray addObject:image];
            }
            [image release];
            data=nil;
            imageURL=nil;
          }else if([elementName isEqualToString:@"success"]||[elementName isEqualToString:@"0"]){
        
        }else if([elementName isEqualToString:@"return"]){
            
            NSLog(@"count images is %i",[ImageArray count]);
           // [tempstr release];
        }    
   
    }else if(parser == feedParser){
        if([elementName isEqualToString:@"content"]){
            [postarray addObject:tempstr];
        }else if([elementName isEqualToString:@"ts"]){
            
            [posttime addObject:tempstr];
        }else if([elementName isEqualToString:@"friendname"]){
            [namearray addObject:tempstr];
           // NSLog(@"name %@",tempstr);

        }
        

    }else if( parser== xmlvideoparser){
        
        if ([elementName isEqualToString:@"thumbnail"]) {
            
            NSString *temstr=[@"http://iband.me/data" stringByAppendingString:tempstr];
            NSURL *thumurl = [NSURL URLWithString:temstr];
            
            NSData *thumdata =  [NSData dataWithContentsOfURL:thumurl];        
            UIImage *thumimage = [[UIImage alloc] initWithData:thumdata];
            if (thumimage!= NULL) {
                [videosarray addObject:thumimage];
            }
            temstr=nil;
            thumurl=nil;
            thumdata=nil;
            thumimage=nil;
        }else if([elementName isEqualToString:@"video_url"]){
        
         NSString *str1 = [tempstr substringToIndex:[tempstr length] - 3];
         NSString *str2 =[str1 stringByAppendingString:@"mp4"];
           // vidobjects.Vidlink=tempstr;
                       
           [self.videourlarray addObject:str2];

            str1=nil;
            str2=nil;
            

        }else if([elementName isEqualToString:@"return"]){
            NSLog(@"video array %i",[videosarray count]);
        }
        
    }
}
-(void)parserDidEndDocument:(NSXMLParser *)parser{

    
    if(parser==xmlparser){
        [control reloadData];

        if (imagealert_yes) {
            [activityIndicator stopAnimating];
            [activityIndicator release];
            [alert dismissWithClickedButtonIndex:0 animated:NO];
            imagealert_yes=NO;
            UIAlertView *responsealert=[[UIAlertView alloc]initWithTitle:@"" message:@"Upload completed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [responsealert show];
            [responsealert release];

        }
      }else if(parser==xmlvideoparser){
          [control2 reloadData];

        if (videoalert_yes) {
            [VideoactivityIndicator stopAnimating];
            [VideoactivityIndicator release];
            [alertview dismissWithClickedButtonIndex:0 animated:YES];
            videoalert_yes=NO;
            UIAlertView *responsealert=[[UIAlertView alloc]initWithTitle:@"" message:@"It may take a few minutes for the uploaded video to appear. You may also click on Refresh button after a few minutes" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [responsealert show];
            [responsealert release];
        }else{
            //[self performSelector:@selector(dissmiss:) withObject:mainalert afterDelay:6];
            if (alertyes) {
                [mainactivityindicator stopAnimating];
                [mainactivityindicator release];
                [mainalert dismissWithClickedButtonIndex:0 animated:YES];
                [mainalert release];
                alertyes=NO;

            }
            if (_adBannerViewIsVisible) {
                [self admobview];
                _adBannerViewIsVisible=NO;
            }
        }
        
     
    }else if(parser==feedParser){
        [tableView reloadData];
    }

}

-(void)dissmiss:(UIAlertView *)alertView{


}
#pragma mark - TextView Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}
// return NO to disallow editing.
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [scrollview setContentOffset:CGPointMake(0, 165) animated:YES];
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField==posttextfield) {
   
        if([posttextfield.text length]!=0){
            //[self performSelector:@selector(callPostFeedWebservice)];
        }
       // [tableView reloadData];
        [textField resignFirstResponder];
        scrollview.contentOffset=CGPointMake(0, 0);

    }else{
        [textField resignFirstResponder];
        scrollview.contentOffset=CGPointMake(0, 0);
    }
    return YES;
}


- (void)adViewDidReceiveAd:(GADBannerView *)view{
    CGRect adBannerViewFrame = [AbMob frame];
    adBannerViewFrame.origin.x = 0;
    adBannerViewFrame.origin.y = 0;
    [AbMob setFrame:adBannerViewFrame];
    CGRect contentViewFrame = profileview.frame;
    contentViewFrame.origin.y =50;
    contentViewFrame.size.height = self.view.frame.size.height - 50;
    profileview.frame = contentViewFrame; 
    NSLog(@"test");
}

//******* Custom method to alloc Buttons *************//
-(UIButton*)btn:(CGRect)ret img:(NSString*)img num:(NSInteger)tag{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=ret;
    [button setTag:tag];
    [button setBackgroundImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    [button setTitle:@"Upload" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(Button_Action:) forControlEvents:UIControlEventTouchUpInside];   
    return button;
}
//********** Custom method to alloc labels *************//
-(UILabel*)lbl:(CGRect)ret str:(NSString*)title {
    UILabel *titlelbl=[[UILabel alloc]initWithFrame:ret];
    titlelbl.text=title;
    titlelbl.font=[UIFont boldSystemFontOfSize:17];
    [titlelbl setBackgroundColor:[UIColor clearColor]];
    [titlelbl setTextColor:[UIColor whiteColor]]; 
    [title release];
    return titlelbl;
}
//*********** Custom methods to alloc ImageView *********//
-(UIImageView*)imgrect:(CGRect)ret {
    
    UIImageView *topimage1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bottom_tab.png"]];
    topimage1.frame=ret;
    topimage1.userInteractionEnabled=YES;
    return topimage1;
}

-(UILabel*)profilelbl:(CGRect)rect str:(NSString*)titletxt{
    UILabel *profiletit=[[UILabel alloc]initWithFrame:rect];
    profiletit.text=titletxt;
    [profiletit setTextColor:[UIColor whiteColor]];
    [profiletit setBackgroundColor:[UIColor clearColor]];
    profiletit.font=[UIFont boldSystemFontOfSize:14];
   // [profiletit release];
    return [profiletit autorelease];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    postarray=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
