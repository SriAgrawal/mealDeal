//
//  ApiConstants.h
//  MealDeal
//
//  Created by Krati Agarwal on 19/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#ifndef ApiConstants_h
#define ApiConstants_h

/*>>>>>>>>>>>>>>>>>>>>>>API Name>>>>>>>>>*/

static NSString *kAPILogin                              = @"users/login";

static NSString *kAPIForgotPassword                     = @"users/forgotPass";

static NSString *kAPISignUp                             = @"users/signup";

static NSString *kAPITermsCondition                     = @"users/termsCondition";

static NSString *kAPIChangePassword                     = @"users/changePassword";

static NSString *kAPITodaysSpecial                      = @"diner/todaySpecial";

static NSString *kAPISurpriseMe                         = @"diner/surpriseMe";

static NSString *kAPIPersonalNutrition                  = @"diner/personalNutrition";

static NSString *kAPILoginFacebook                      = @"users/auth/facebook";

static NSString *kAPIChefRequestCancelDeal              = @"chef/approvalStatus";

static NSString *kAPIChefCancelFutureOrder             = @"chef/cancelFutureOrder";

static NSString *kAPIAddToCart                          = @"diner/addToCart";

static NSString *kAPIReviewsListDiner                   = @"diner/viewReview";

static NSString *kAPIRatingChef                         = @"diner/ratingChef";

static NSString *kAPIShowDinerPreferences               = @"diner/showdinerPreferences";

static NSString *kAPISaveDinerPreference                = @"diner/savedinerpreferences";

static NSString *kAPIGetUserProfile                     = @"users/usersProfile";

static NSString *kAPISetUserProfile                     = @"users/accountSetting";

static NSString *kAPILocation                           = @"users/findNearby";

static NSString *kAPIPrepareAMeal                       = @"chef/prepareMeal";

static NSString *kAPIMealsDetail                        = @"diner/mealsDetail";

static NSString *kAPIChefOrderHistory                   = @"chef/ChefOrderHistory";

static NSString *kAPIChefFutureOrders                   = @"chef/ChefFutureOrder";

static NSString *kAPIChatHistory                        = @"ChatHistory";

static NSString *kAPIGetAllStates                       = @"users/getAllStates";

static NSString *kAPIPaynow                             = @"users/paynow";




static NSString *kAPIChefHealthyMealList                = @"chef/ChefHealthyMeal";

static NSString *kAPIHealthyMealListAddToTodaysSpecial  = @"chef/addtoTodaysSpecial";

static NSString *kAPIDinerOrderStatus                   = @"diner/orderStatus";

static NSString *kAPIDinerOrderHistory                  = @"diner/dinerOrderHistory";

static NSString *kAPIForAutoAllergies                   = @"diner/autoAllergies";

static NSString *kAPIMyRegularMeals                     = @"chef/MyRegularMealList";

static NSString *kAPIRequestedMeals                     = @"chef/requestedMealDetail";

static NSString *kAPIRequestDetailsChef                 = @"chef/chefRequestDetails";

static NSString *kAPILoginSocial                        = @"users/socialLogin";

static NSString *kAPINeedHelp                           = @"diner/needHelp";

static NSString *kAPIMyRegularMealers                   = @"chef/MyRegularMealer";

static NSString *kAPITodaysOrderListChef                = @"chef/todaysOrder";

static NSString *kAPIForSwitchRole                      = @"users/switchRole";






static NSString *kAPIHealthyMeal                        = @"diner/healthyMeals";

static NSString *kAPICartDetail                         = @"diner/cartDetails";

static NSString *kAPIRemoveMealsFromCart                = @"diner/removeMeals";

static NSString *kAPISendRequest                        = @"diner/sendRequest";

static NSString *kAPICustomMeal                         = @"diner/customMeal";

static NSString *kAPIDetailCustomMeal                   = @"diner/detailCustomMeal";

/*>>>>>>>>>>>>Static Constants>>>>>>>>>>>>>>>>>>*/

static NSString *kDummyDeviceToken             = @"60de1f8d628b3f265b028ab3a69223af2dfc0b56b2671244bb6910b68764e611";
static NSString *kDeviceType                   = @"iOS";


static NSString *pType                         = @"type";

static NSString *pAccess_token                 = @"access_token";
static NSString *pDevice_token                 = @"deviceToken";

static NSString *pDeviceType                   = @"deviceType";
static NSString *pResponse_code                = @"response_code";
static NSString *pResponse_message             = @"response_message";

static NSString *p_id                          = @"_id";
static NSString *pEmail                        = @"email";
static NSString *pPassword                     = @"password";
static NSString *pRole                         = @"role";
static NSString *pUserID                       = @"userId";

static NSString *pUser                         = @"user";
static NSString *pLogindata                    = @"logindata";

static NSString *pUserName                     = @"userName";
static NSString *pFullName                     = @"fullName";
static NSString *pPhone                        = @"phoneNumber";
static NSString *pAddress                      = @"address";
static NSString *pPushNotification             = @"pushNotification";

static NSString *pCountry                      = @"country";
static NSString *pState                        = @"state";
static NSString *pCity                         = @"city";
static NSString *pZipCode                      = @"zipCode";
static NSString *pStreetName                   = @"streetName";
static NSString *pPhoto                        = @"image";

static NSString *pChefId                       = @"chefId";
static NSString *pData                         = @"data";
static NSString *pTotalreview                  = @"totalreview";
static NSString *pChefName                     = @"chefName";
static NSString *pTotalRating                  = @"totalRating";
static NSString *pDetails                      = @"Details";
static NSString *pPrice                        = @"price";
static NSString *pImages                       = @"images";
static NSString *pCuisineDetail                = @"cuisineDetail";
static NSString *pName                         = @"name";
static NSString *pChefdetails                  = @"chefdetails";
static NSString *pSocialType                   = @"socialType";
static NSString *pSocialId                     = @"socialId";
static NSString *pText                         = @"text";
static NSString *pHelpFrom                     = @"helpFrom";
static NSString *pTermsCondition               = @"termsCondition";

static NSString *pDinerId                      = @"dinerId";
static NSString *pRange                        = @"Range";
static NSString *pLongitude                    = @"long";
static NSString *platitude                     = @"lat";
static NSString *pMealId                       = @"mealId";
static NSString *pResult                       = @"result";
static NSString *pMealType                     = @"mealType";
static NSString *pIngredients                  = @"ingredients";
static NSString *pCalories                     = @"calories";
static NSString *pAdditionalCost               = @"additionalCost";
static NSString *pServings                     = @"servings";
static NSString *pSpiceLevel                   = @"spiceLevel";
static NSString *pHealthMeter                  = @"healthMeter";
static NSString *pTimeRequired                 = @"timeRequired";
static NSString *pPrefResult                   = @"prefResult";
static NSString *pReview                       = @"review";
static NSString *pSpeciality                   = @"Speciality";

static NSString *pLoc                          = @"loc";
static NSString *pIsVarified                   = @"IsVarified";
static NSString *pSides                        = @"sides";
static NSString *pDate                         = @"date";
static NSString *pTime                         = @"time";
static NSString *pMealCount                    = @"mealCount";
static NSString *pAddToHealthyMeal             = @"addToHealthyMeal";

static NSString *pMinerals                     = @"minerals";
static NSString *pConsumedQuantity             = @"consumedQuantity";
static NSString *pMealTime                     = @"MealTime";
static NSString *pNutrients                    = @"nutrients";
static NSString *pMeal                         = @"meal";
static NSString *pQuantity                     = @"quantity";
static NSString *pAddons                       = @"addons";
static NSString *pAddonsDetails                = @"addonsDetails";
static NSString *pStoresArounds                = @"storesArounds";
static NSString *pSpecialRequirements          = @"specialRequirements";
static NSString *pChefType                     = @"chefType";
static NSString *pAllergies                    = @"allergies";
static NSString *pAllAllergies                 = @"allAllergies";
static NSString *pCuisinePreference            = @"cuisinePreference";
static NSString *pSteps                        = @"steps";

// Order history
static NSString *pOutstanding                  = @"Outstanding";
static NSString *pSpending                     = @"Spending";
static NSString *pLastTwoOrders                = @"LastTwoOrders";
static NSString *pOrderId                        = @"orderId";
static NSString *pReason                        = @"reason";

#endif /* ApiConstants_h */
