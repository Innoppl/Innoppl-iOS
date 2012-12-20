//
//  CustomView.h
//  Kiosk
//
//  Created by Innoppl Technologies on 28/07/10.
//  Copyright 2010, Interstellar Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomView : UIAlertView 
{
    UITextField *textField;
	UITextField *passField;
	UIButton *okBtn ;
	UIButton *cancelBtn;
}
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UITextField *passField;
@property (readonly) NSString *enteredText;
@property (readonly) NSString *enteredPass;
- (void)setNumberOfRows:(int)num;
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle;
@end