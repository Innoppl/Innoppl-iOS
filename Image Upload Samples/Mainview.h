//
//  Mainview.h
//  iBand
//
//  Created by Innoppl tech on 3/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"
#import "MobileCoreServices/MobileCoreServices.h"
#import "CoreLocation/CoreLocation.h"
#import "AssetsLibrary/AssetsLibrary.h"
#import "CreateAccount.h"
#import "iBandViewController.h"
#import "MediaPlayer/MediaPlayer.h"
#import "iBandAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "ZBGridImageViewController.h"
#import "ZBGridControl.h"
#import "ZBGridLayer.h"
#import "ZBGridvideoControl.h"
#import "ZBGridvideoLayer.h"
#import "XMLReader.h"
#import "VideoView.h"
#import "Constants.h"
#import "LiveStreamlist.h"
#import "FriendsView.h"
#import "ASINetworkQueue.h"
#import "GADBannerView.h"
@interface Mainview : UIViewController<NSXMLParserDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ZBGridControlDelegate,ZBGridImageViewControllerDelegate,imageviewDelegate,ZBGridvideoControlDelegate,GADBannerViewDelegate> {
    UIView *imageuploadviw;
    UIView *videouploadviw;
    UIView *MoreTabview;
    UIImageView *cameraimage;
    UIView *profileview;
    UITextField *posttextfield;
    UITableView *tableView ;
   
    UIButton *item1,*item2,*item3,*item4;
    UIActivityIndicatorView *activityIndicator;
    UIActivityIndicatorView *VideoactivityIndicator;

 //................IMAGEVIEW & VIDEOS...............//
    ZBGridControl *control;
	ZBGridImageViewController *imageViewController;
    NSMutableArray *ImageArray;
    NSMutableArray *videosarray;
    NSMutableArray *videourlarray;
	ZBGridLayer *transitionLayer;
    
    VideoView *vid;
    UIAlertView   *alert;
    UIAlertView *alertview;
    UIAlertView *mainalert;
    UIActivityIndicatorView *mainactivityindicator;
    NSMutableArray *videoplay;
    ZBGridvideoControl *control2;
    ZBGridvideoLayer *layer2;
    NSXMLParser *xmlparser;
    NSXMLParser *xmlvideoparser;
    NSXMLParser *feedParser;
    NSString *tempstr;
    NSMutableArray *namearray;
   
    BOOL _adBannerViewIsVisible;
    BOOL alertyes;
    BOOL videoalert_yes;
    BOOL imagealert_yes;
    NSTimer *timer;
    
    GADBannerView *AbMob;

}
@property (retain, nonatomic) ZBGridControl *control;
@property (retain, nonatomic) ZBGridLayer *transitionLayer;
@property(retain,nonatomic)   ZBGridvideoControl *control2;
@property(nonatomic,retain)   ZBGridvideoLayer *layer2;
@property (nonatomic,retain) ASINetworkQueue *networkQueue;
@property (nonatomic,copy) NSString *Videos;
@property (nonatomic,copy) NSString *Images;
@property (nonatomic,copy) NSString *Chat;
@property(nonatomic,retain)NSMutableArray *videourlarray;

-(UIImageView*)imgrect:(CGRect)ret;
-(UILabel*)lbl:(CGRect)ret str:(NSString*)title;
-(UIButton*)btn:(CGRect)ret img:(NSString*)img num:(NSInteger)tag;
-(UILabel*)profilelbl:(CGRect)rect str:(NSString*)titletxt;
- (void)doNetworkOperations;
- (ASIFormDataRequest*)getchat;
- (ASIFormDataRequest *)getvideo;
- (ASIFormDataRequest *)getimages;
-(void)loadtheImageview;
-(void)loadvideosview;
@end
