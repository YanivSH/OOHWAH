//
//  ContentViewController.h
//  OOHWAH
//
//  Created by Yaniv Marshaly on 1/30/13.
//  Copyright (c) 2013 OOHWAH LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *imageFrame;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITextView *descriptionField;

// Index of the movie (1 - 3)
@property (assign, nonatomic) NSUInteger movieIndex;

@property (strong, nonatomic) IBOutlet UIButton *indexButton;
@end
