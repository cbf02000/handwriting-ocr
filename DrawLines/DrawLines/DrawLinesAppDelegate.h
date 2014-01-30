//
//  DrawLinesAppDelegate.h
//  DrawLines
//
//  Created by Reetu Raj on 11/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawLinesAppDelegate : NSObject <UIApplicationDelegate> {

    UINavigationController *navigationController;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) UINavigationController *navigationController;
@end
