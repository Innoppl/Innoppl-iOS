//
//  CroppedViewController.h
//  CropImage
//
//  Created by Jagadeesh Deivasigamani on 20/12/12.
//  Copyright (c) 2012 Innoppl Technlogies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CroppedViewController : UIViewController


@property(nonatomic,strong)IBOutlet UIImageView *imgView;
@property(nonatomic,strong) UIImage *croppedImg;

@end
