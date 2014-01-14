//
//  LinkedInProfileViewController.h
//  BlueCanary
//
//  Created by Crae Sosa on 8/26/13.
//  Copyright (c) 2013 com.appiari. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkedInProfileViewController : UIViewController<NSURLConnectionDelegate>{
    
    IBOutlet UILabel *textViewName;
    IBOutlet UILabel *textViewTitle;
    IBOutlet UILabel *skillsTextView;
    IBOutlet UILabel *variableTextView;
    IBOutlet UITextView *textView1;
    NSArray * arrTexts;
    IBOutlet UIImageView *profilePicture;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;


@property (strong,nonatomic) NSString *linkedinURL;

@property (strong,nonatomic) UIAlertView *alert;

@property (strong,nonatomic) NSMutableData *responseData;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;



@property(nonatomic) NSInteger numberOfLines;
@property(nonatomic) UILineBreakMode lineBreakMode;



@end
