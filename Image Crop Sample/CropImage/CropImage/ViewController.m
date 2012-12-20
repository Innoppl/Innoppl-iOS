//
//  ViewController.m
//  CropImage
//
//  Created by Jagadeesh Deivasigamani on 20/12/12.
//  Copyright (c) 2012 Innoppl Technlogies. All rights reserved.
//

#import "ViewController.h"
#import "CroppedViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *done=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction:)];
    
    
    UIBarButtonItem *select=[[UIBarButtonItem alloc] initWithTitle:@"Load Image" style:UIBarButtonItemStyleBordered target:self action:@selector(loadAction:)];
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:done, nil];
    self.navigationItem.leftBarButtonItem=select;

   

	// Do any additional setup after loading the view, typically from a nib.
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}




-(IBAction)doneAction:(id)sender
{
    
    //Show Cropped Image

    CroppedViewController *crop=[[CroppedViewController alloc] initWithNibName:@"CroppedViewController" bundle:[NSBundle mainBundle]];
    crop.croppedImg=[self.imgCropper getCroppedImage];
    [self.navigationController pushViewController:crop animated:YES];

}

-(void)update:(UIImage*)img
{
    
    if(self.imgCropper) {[self.imgCropper removeFromSuperview]; self.imgCropper=nil;}
    self.imgCropper = [[INImageCropperView alloc] initWithImage:img andMaxSize:CGSizeMake(320, 410)];
    [self.view addSubview:self.imgCropper];
    self.imgCropper.center = self.view.center;
    self.imgCropper.baseImageView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.imgCropper.baseImageView.layer.shadowRadius = 3.0f;
    self.imgCropper.baseImageView.layer.shadowOpacity = 0.8f;
    self.imgCropper.baseImageView.layer.shadowOffset = CGSizeMake(1, 1);
    
}

-(void)loadAction:(id)sender
{
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"From Gallery",nil];
    
    actionSheet.actionSheetStyle=UIActionSheetStyleAutomatic;
    
    [actionSheet showInView:self.view];

}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraCaptureModePhoto])
        {
            UIImagePickerController *picker=[[UIImagePickerController alloc] init];
            picker.delegate=self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.showsCameraControls=YES;
            
            
            [self presentModalViewController:picker animated:YES];
        }
        else{
            NSLog(@"No Device");
        }
        
        //[self update:nil];
    } else if (buttonIndex == 1) {
        
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.delegate=self;
        
        
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentModalViewController:picker animated:YES];
        
    } else if (buttonIndex == 2) {
   
    }
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
   
    [picker dismissModalViewControllerAnimated:YES];
    
  [self update:[info valueForKey:@"UIImagePickerControllerOriginalImage"]];
    
    
}


@end
