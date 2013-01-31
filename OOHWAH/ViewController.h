//
//  ViewController.h
//  OOHWAH
//
//  Created by Yaniv Marshaly on 1/30/13.
//  Copyright (c) 2013 OOHWAH LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPFlipViewController.h"
@interface ViewController : UIViewController <MPFlipViewControllerDataSource,MPFlipViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *frame;
@property (strong,nonatomic) MPFlipViewController * flipViewController;
-(void)removeObserver;
@end

