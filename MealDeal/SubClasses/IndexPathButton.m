//
//  IndexPathButton.m
//  UrgencyApp
//
//  Created by Raj Kumar Sharma on 11/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "IndexPathButton.h"

@implementation IndexPathButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self defaultSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self =  [super initWithCoder:aDecoder];
    if(self){
        
        [self defaultSetup];
        
    }
    return self;
}

#pragma mark - Private methods

- (void)defaultSetup {
    [self setExclusiveTouch:YES];
}


@end
