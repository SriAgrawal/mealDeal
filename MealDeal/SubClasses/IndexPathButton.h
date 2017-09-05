//
//  IndexPathButton.h
//  UrgencyApp
//
//  Created by Raj Kumar Sharma on 11/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexPathButton : UIButton

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL isRightSide;

@end
