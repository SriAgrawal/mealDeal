//
//  CookReviewsModal.m
//  MealDeal
//
//  Created by Mohit on 25/11/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "CookReviewsModal.h"

@implementation CookReviewsModal

// Parse Data For Chef Reviews List Diner Section
+(NSMutableArray *)getReviewsListDataFromArray:(NSDictionary *)dictionary{
    NSMutableArray *reviewsListArray = [[NSMutableArray alloc] init];
    NSArray *allReviewsArray = [dictionary objectForKey:@"allReview"];
    for(NSDictionary *dict in allReviewsArray){
        CookReviewsModal *reviewsInfo = [[CookReviewsModal alloc]init];
        NSDictionary *chefData = [dict objectForKey:@"dinerId"];
        reviewsInfo.strReviewsListDinerId = [chefData objectForKey:@"_id"];
        reviewsInfo.strReviewsListCookName = [chefData objectForKey:@"fullName"];
        reviewsInfo.strReviewsListCookImageUrl = [chefData objectForKey:@"image"];
        reviewsInfo.strReviewsListReviewDescription = [dict objectForKey:@"review"];
        reviewsInfo.strReviewsListCookRatings = [dict objectForKey:@"rating"];
        reviewsInfo.strReviewsListReviewDate = [dict objectForKey:@"createdAt"];
        [reviewsListArray addObject:reviewsInfo];
    }
    return reviewsListArray;
}

// Parse Data for Diner Reviews List Chef Section

+(NSMutableArray *)getDinerReviewsListDataFromArrayChefSide:(NSDictionary *)dictionary{
    NSMutableArray *dinerReviewsListArray = [[NSMutableArray alloc] init];
    NSArray *allReviewsArray = [dictionary objectForKey:@"allReview"];
    for(NSDictionary *dict in allReviewsArray){
        NSDictionary *dinerData = [dict objectForKey:@"dinerId"];
        CookReviewsModal *reviewsInfo = [[CookReviewsModal alloc]init];
        reviewsInfo.strReviewsListReviewDinerId = [dinerData objectForKey:@"_id"];
        reviewsInfo.strReviewsListDinerName = [dinerData objectForKey:@"fullName"];
        reviewsInfo.strReviewsListDinerImageUrl = [dinerData objectForKey:@"image"];
        reviewsInfo.strReviewsListDinerReviewDescription = [dict objectForKey:@"review"];
        reviewsInfo.strReviewsListDinerRatings = [dict objectForKey:@"rating"];
        reviewsInfo.strReviewsListDinerReviewDate = [dict objectForKey:@"createdAt"];
        [dinerReviewsListArray addObject:reviewsInfo];
    }
    return dinerReviewsListArray;
}

@end
