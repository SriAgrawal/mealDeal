//
//  CookReviewsModal.h
//  MealDeal
//
//  Created by Mohit on 25/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "Macro.h"

@interface CookReviewsModal : NSObject

// Parse Data For Chef Reviews List Diner Section

@property(strong, nonatomic) NSString *strReviewsListCookName;
@property(strong, nonatomic) NSString *strReviewsListCookImageUrl;
@property(strong, nonatomic) NSString *strReviewsListCookRatings;
@property(strong, nonatomic) NSString *strReviewsListReviewDate;
@property(strong, nonatomic) NSString *strReviewsListReviewDescription;
@property(strong, nonatomic) NSString *strReviewsListDinerId;


+(NSMutableArray *)getReviewsListDataFromArray:(NSArray*)arr;

// Parse Data for Diner Reviews List Chef Section

@property(strong, nonatomic) NSString *strReviewsListDinerName;
@property(strong, nonatomic) NSString *strReviewsListDinerImageUrl;
@property(strong, nonatomic) NSString *strReviewsListDinerRatings;
@property(strong, nonatomic) NSString *strReviewsListDinerReviewDate;
@property(strong, nonatomic) NSString *strReviewsListDinerReviewDescription;
@property(strong, nonatomic) NSString *strReviewsListReviewDinerId;

+(NSMutableArray *)getDinerReviewsListDataFromArrayChefSide:(NSArray*)arr;


@end
