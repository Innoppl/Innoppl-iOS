//
//  CustomView.m
//  Kiosk
//
//  Created by Innoppl Technologies on 28/07/10.
//  Copyright 2010, Interstellar Studios. All rights reserved.
//

#import "CustomView.h"


@implementation CustomView


@synthesize textField;
@synthesize passField;
@synthesize enteredText;
@synthesize enteredPass;
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okayButtonTitle
{
	
    if (self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okayButtonTitle, nil])
    {
		//[self initWithFrame:CGRectMake(10.0, 10.0, 300.0, 100.0)];
        UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)]; 
		UITextField *thePassword = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 90.0, 260.0, 25.0)];
		UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(12.0, 135.0, 260.0, 25.0)];
        [theTextField setBackgroundColor:[UIColor whiteColor]];
		[theTextField setPlaceholder:@"Enter your userid"];
		[thePassword setBackgroundColor:[UIColor whiteColor]];
		[thePassword setPlaceholder:@"Enter your password"];
        [self addSubview:theTextField];
		[self addSubview:thePassword];
		//[self addSubview:okButton];
		//[self addSubview:cancelBtn];
		[self addButtonWithTitle:@"Ok"];
		[self addButtonWithTitle:@"NewCancel"];
        self.textField = theTextField;
		self.passField= thePassword;
        [theTextField release];
		[thePassword release];
        CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 130.0); 
        [self setTransform:translate];
    }
    return self;
}
- (void)setFrame:(CGRect)rect {
	[super setFrame:CGRectMake(0, 0, rect.size.width, 300)];
	self.center = CGPointMake(600/2, 800/2);
}
- (void)show
{
    [textField becomeFirstResponder];
    [super show];
}
- (NSString *)enteredText
{
    return textField.text;
}

- (NSString *)enteredPass
{
    return passField.text;
}

- (void)dealloc
{
    [textField release];
	[passField release];
    [super dealloc];
}
@end