//
//  DrawingController.h
//  DrawLines
//
//  Created by Reetu Raj on 11/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MyLineDrawingView.h"

@interface DrawingController : UIViewController <NSURLConnectionDelegate> {
    
    IBOutlet UISegmentedControl *segmentBar;
    MyLineDrawingView *drawScreen;
    NSMutableData *resData;
    
}

@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@end
