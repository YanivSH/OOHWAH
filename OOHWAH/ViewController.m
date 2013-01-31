//
//  ViewController.m
//  OOHWAH
//
//  Created by Yaniv Marshaly on 1/30/13.
//  Copyright (c) 2013 OOHWAH LTD. All rights reserved.
//
#define FRAME_MARGIN	60

#import "ViewController.h"
#import "ContentViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
@property (assign, nonatomic) int previousIndex;
@property (assign, nonatomic) int tentativeIndex;
@property (assign, nonatomic) BOOL observerAdded;
@end

@implementation ViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.flipViewController = [[MPFlipViewController alloc] initWithOrientation:[self flipViewController:nil orientationForInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation]];
	self.flipViewController.delegate = self;
	self.flipViewController.dataSource = self;
    /////////////////////////////////////////////
    BOOL hasFrame = self.frame != nil;
	CGRect pageViewRect = self.view.bounds;
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
	{
		pageViewRect = CGRectInset(pageViewRect, 20 + (hasFrame? FRAME_MARGIN : 0), 20 + (hasFrame? FRAME_MARGIN : 0));
		self.flipViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	}
	
        else
        {
            pageViewRect = CGRectMake(0/*(self.view.bounds.size.width - 600)/2*/, /*(self.view.bounds.size.height - 600)/2*/0, self.view.bounds.size.width,self.view.bounds.size.height);
            self.flipViewController.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        }
	self.flipViewController.view.frame = pageViewRect;
	[self addChildViewController:self.flipViewController];
	[self.view addSubview:self.flipViewController.view];
	[self.flipViewController didMoveToParentViewController:self];
	
	[self.flipViewController setViewController:[self contentViewWithIndex:self.previousIndex] direction:MPFlipViewControllerDirectionForward animated:NO completion:nil];
	
	// Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
	self.view.gestureRecognizers = self.flipViewController.gestureRecognizers;
	
	[self addObserver];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidUnload
{
	
	[self setFrame:nil];
	[self removeObserver];
    [super viewDidUnload];
	
    // Release any retained subviews of the main view.
}

- (void)addObserver
{
	if (![self observerAdded])
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flipViewControllerDidFinishAnimatingNotification:) name:MPFlipViewControllerDidFinishAnimatingNotification object:nil];
		[self setObserverAdded:YES];
	}
}

-(void)removeObserver
{
	if ([self observerAdded])
	{
		[[NSNotificationCenter defaultCenter] removeObserver:self name:MPFlipViewControllerDidFinishAnimatingNotification object:nil];
		[self setObserverAdded:NO];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ([self flipViewController])
		return [[self flipViewController] shouldAutorotateToInterfaceOrientation:interfaceOrientation];
	else
		return YES;
}


- (NSString *)storyboardName
{
	// fetch the appropriate storyboard name depending on platform
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
		return @"MainStoryboard";
	else
		return @"MainStoryboard";
}

- (ContentViewController *)contentViewWithIndex:(int)index
{
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[self storyboardName] bundle:nil];
	ContentViewController *page = [storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
	page.movieIndex = index;
	page.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	return page;
}

#pragma mark - MPFlipViewControllerDelegate protocol

- (void)flipViewController:(MPFlipViewController *)flipViewController didFinishAnimating:(BOOL)finished previousViewController:(UIViewController *)previousViewController transitionCompleted:(BOOL)completed
{
	if (completed)
	{
		self.previousIndex = self.tentativeIndex;
	}
}

- (MPFlipViewControllerOrientation)flipViewController:(MPFlipViewController *)flipViewController orientationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
		return UIInterfaceOrientationIsPortrait(orientation)? MPFlipViewControllerOrientationVertical : MPFlipViewControllerOrientationHorizontal;
	else
		return MPFlipViewControllerOrientationHorizontal;
}

#pragma mark - MPFlipViewControllerDataSource protocol

- (UIViewController *)flipViewController:(MPFlipViewController *)flipViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
	int index = self.previousIndex;
	index--;
	if (index < 1)
		return nil; // reached beginning, don't wrap
	self.tentativeIndex = index;
	return [self contentViewWithIndex:index];
}

- (UIViewController *)flipViewController:(MPFlipViewController *)flipViewController viewControllerAfterViewController:(UIViewController *)viewController
{
	int index = self.previousIndex;
	index++;
	if (index >4)
		return nil; // reached end, don't wrap
	self.tentativeIndex = index;
	return [self contentViewWithIndex:index];
}

#pragma mark - Notifications

- (void)flipViewControllerDidFinishAnimatingNotification:(NSNotification *)notification
{
	NSLog(@"Notification received: %@", notification);
}



    
    /*
    self.flipViewController = [[MPFlipViewController alloc] initWithOrientation:[self flipViewController:nil orientationForInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation]];
    
	self.flipViewController.delegate = self;
    
	self.flipViewController.dataSource = self;
    
    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
	
	self.flipViewController.view.frame = self.view.frame;
	[self addChildViewController:self.flipViewController];
	[self.view addSubview:self.flipViewController.view];
	[self.flipViewController didMoveToParentViewController:self];
	
	[self.flipViewController setViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"] direction:MPFlipViewControllerDirectionForward animated:NO completion:nil];
	
	// Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
	self.view.gestureRecognizers = self.flipViewController.gestureRecognizers;
	
		


	// Do any additional setup after loading the view, typically from a nib.


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MPFlipViewControllerDataSource
- (UIViewController *)flipViewController:(MPFlipViewController *)flipViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    int index = self.previousIndex;
	index--;
	if (index < 1)
		return nil; // reached beginning, don't wrap
	self.tentativeIndex = index;
    return [self.storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];

}// get previous page, or nil for none
- (UIViewController *)flipViewController:(MPFlipViewController *)flipViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    int index = self.previousIndex;
	index++;
	if (index > 3)
		return nil; // reached end, don't wrap
	self.tentativeIndex = index;
    return [self.storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
}// get next page, or nil for none

#pragma mark - MPFlipViewControllerDelegate
// handle this to be notified when page flip animations have finished
- (void)flipViewController:(MPFlipViewController *)flipViewController didFinishAnimating:(BOOL)finished previousViewController:(UIViewController *)previousViewController transitionCompleted:(BOOL)completed
{
    if (completed)
	{
		self.previousIndex = self.tentativeIndex;
	}

}

// handle this and return the desired orientation (horizontal or vertical) for the new interface orientation
// called when MPFlipViewController handles willRotateToInterfaceOrientation:duration: callback
- (MPFlipViewControllerOrientation)flipViewController:(MPFlipViewController *)flipViewController orientationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return MPFlipViewControllerOrientationHorizontal;
}
*/
@end
