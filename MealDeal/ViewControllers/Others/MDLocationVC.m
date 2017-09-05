//
//  MDLocationVC.m
//  MealDeal
//
//  Created by Krati Agarwal on 21/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "MDLocationVC.h"
#import <MapKit/MapKit.h>
#import "Macro.h"

@interface MDLocationVC ()<MKMapViewDelegate,CLLocationManagerDelegate> {
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

@property (weak, nonatomic) IBOutlet MKMapView          *mapView;

@property (weak, nonatomic) IBOutlet UIView             *radioButonView;

@property (weak, nonatomic) IBOutlet UIButton           *milesButton;
@property (weak, nonatomic) IBOutlet UIButton           *vegButton;
@property (weak, nonatomic) IBOutlet UIButton           *backButton;
@property (weak, nonatomic) IBOutlet UIButton           *nonvegButton;
@property (weak, nonatomic) IBOutlet UIButton           *bothButton;

@property (weak, nonatomic) IBOutlet TextField          *searchTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapBottomConstraint;

@property (strong, nonatomic) NSArray                   *dataSourceArray;
@property (strong, nonatomic) NSString                  *dinerName;

@property (strong, nonatomic) NSString                  *chefTypeString;

@property (strong, nonatomic) LocationModal             *locationObj;

@end

@implementation MDLocationVC

#pragma mark - UIViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tapGestureMethod];
    self.bothButton.selected = YES;
    }

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self.view bringSubviewToFront:self.radioButonView];

    if (self.isAfterLogin) {
        self.mapBottomConstraint.constant = 0;
        if(self.isBack)
            self.backButton.hidden = NO;
        else
            self.backButton.hidden = YES;
    } else {
        self.mapBottomConstraint.constant = 60;
        self.backButton.hidden = YES;
    }
    
    [[APPDELEGATE locationManager] startUpdatingLocation];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCurrentLocation:) name:@"RefreshCurrentLocation" object:nil];
}

//-(void)viewWillDisappear:(BOOL)animated {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

-(void)refreshCurrentLocation:(NSNotification *)notification {
    [self showannotations];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

#pragma mark - Private Methods

- (void)tapGestureMethod {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)showannotations {
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self initViews];
    
}

//- (void)locationManager:(CLLocationManager* )manager didUpdateLocations:(NSArray* )locations
//{
//    currentLocation = [locations objectAtIndex:0];
//
//    [locationManager stopUpdatingLocation];
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
//    
//    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray* placemarks, NSError* error)
//     {
//         if (!(error))
//         {
//             // CLPlacemark *placemark = [placemarks objectAtIndex:0];
//             
//             //  NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
//             //  NSString *Address = [[NSString alloc]initWithString:locatedAt];
//             // NSString *Area = [[NSString alloc]initWithString:placemark.locality];
//             //NSString *Country = [[NSString alloc]initWithString:placemark.country];
//             // NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
//         }
//         else
//         {
//             NSLog(@"Geocode failed with error %@", error);
//             NSLog(@"\nCurrent Location Not Detected\n");
//             //return;
//             //CountryArea = NULL;
//         }
//         /*---- For more results
//          placemark.region);
//          placemark.country);
//          placemark.locality);
//          placemark.name);
//          placemark.ocean);
//          placemark.postalCode);
//          placemark.subLocality);
//          placemark.location);
//          ------*/
//     }];
//    [self initViews];
//
//    [self callApiForUserCurrentLocation];
//}
//
-(void)initViews {
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;

    MKCoordinateRegion region = self.mapView.region;
    region.center = CLLocationCoordinate2DMake([[APPDELEGATE latitude] doubleValue], [[APPDELEGATE longitude] doubleValue]);
   
    //region.center = CLLocationCoordinate2DMake(28.5354383, 77.26393259999998);
    region.span.latitudeDelta /= 50.0;
    region.span.longitudeDelta /= 50.0;
    [self.mapView setRegion:region animated:YES];

    [self.view addSubview:self.mapView];
    [self.view bringSubviewToFront:self.radioButonView];

    [self callApiForUserCurrentLocation];

}

-(void)addAllPins {
    
    [self.mapView removeAnnotations:self.mapView.annotations];

    NSMutableArray *nameArray = [NSMutableArray array];
    
    for ( LocationModal *locationObj1 in self.dataSourceArray)
        [nameArray addObject:locationObj1.mealName];
    
    NSMutableArray *arrCoordinateStr = [[NSMutableArray alloc] initWithCapacity:nameArray.count];

    for ( LocationModal *locationObj2 in self.dataSourceArray)
        [arrCoordinateStr addObject:[NSString stringWithFormat:@"%@, %@",locationObj2.chefLatitude,locationObj2.chefLongitude]];

    for(int i = 0; i < nameArray.count; i++) {
        [self addPinWithTitle:nameArray[i] AndCoordinate:arrCoordinateStr[i]];
    }
    
    /////////////////////////// Dummy //////////////////////////////
//    NSArray *name=[[NSArray alloc]initWithObjects:
//                   @"VelaCherry",
//                   @"Tharamani", @"Abc", @"Xyz", nil];
//    
//    NSMutableArray *arrCoordinateStr = [[NSMutableArray alloc] initWithCapacity:name.count];
//
//    [arrCoordinateStr addObject:@"28.5503, 77.2502"];
//    [arrCoordinateStr addObject:@"28.54145, 77.263883"];
//    [arrCoordinateStr addObject:@"28.5223, 77.2849"];
//    [arrCoordinateStr addObject:@"28.5687, 77.2231"];
//
//    for(int i = 0; i < name.count; i++)
//    {
//        [self addPinWithTitle:name[i] AndCoordinate:arrCoordinateStr[i]];
//    }
    
}

-(void)addPinWithTitle:(NSString *)title AndCoordinate:(NSString *)strCoordinate {
   
    MKPointAnnotation *mapPin = [[MKPointAnnotation alloc] init];
    
    // clear out any white space
    strCoordinate = [strCoordinate stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // convert string into actual latitude and longitude values
    NSArray *components = [strCoordinate componentsSeparatedByString:@","];
    
    double latitude = [components[0] floatValue];
    double longitude = [components[1] floatValue];
    
    // setup the map pin with all data and add to map view
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    mapPin.title = title;
    mapPin.coordinate = coordinate;
    [self.mapView addAnnotation:mapPin];
 
}

#pragma mark - UIButton Actions

- (IBAction)loginButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    MDLoginVC *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MDLoginVC"];
    [self.navigationController pushViewController: loginVC animated:YES];
}

- (IBAction)milesButtonAction:(id)sender {
    [self.view endEditing:YES];
    [[OptionPickerManager pickerManagerManager] showOptionPicker:self withData:@[@"5 Miles", @"10 Miles", @"15 Miles"] completionBlock:^(NSArray *selectedIndexes, NSArray *selectedValues) {
        LogInfo(@"selectedIndexes    %@", selectedIndexes);
        LogInfo(@"selectedValues    %@", selectedValues);
        
        [self.milesButton setTitle:selectedValues.firstObject forState:UIControlStateNormal];
        [self callApiForUserCurrentLocation];

    }];
}

- (IBAction)vegButtonAction:(id)sender {
    self.vegButton.selected = YES;
    self.nonvegButton.selected = NO;
    self.bothButton.selected = NO;
    [self callApiForUserCurrentLocation];
}

- (IBAction)nonvegButtonAction:(id)sender {
    self.vegButton.selected = NO;
    self.nonvegButton.selected = YES;
    self.bothButton.selected = NO;
    [self callApiForUserCurrentLocation];
}

- (IBAction)bothButtonAction:(id)sender {
    self.vegButton.selected = NO;
    self.nonvegButton.selected = NO;
    self.bothButton.selected = YES;
    [self callApiForUserCurrentLocation];
}

- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextfield delegate method

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.returnKeyType == UIReturnKeySearch) {
        
        [textField resignFirstResponder];

        if (![TRIM_SPACE(self.searchTextField.text) length] || [TRIM_SPACE(self.searchTextField.text) length] <= 2 || [TRIM_SPACE(self.searchTextField.text) length] >= 11)
        
            [AlertController title: ![TRIM_SPACE(self.searchTextField.text) length] ? @"Please enter zip code." : @"Please enter zip code between 3 to 10 characters." ];
         else
             [self callApiForUserCurrentLocation];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
        TextField *field = (TextField *)textField;
        field.active = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
        TextField *field = (TextField *)textField;
        field.active = NO;
        
}

#pragma mark -

#pragma mark Delegate Methods

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    id <MKAnnotation> annotation = [view annotation];
    
    float lat = [[view annotation] coordinate].latitude;
    float longitude = [[view annotation] coordinate].longitude;

    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
     }

    for (LocationModal *objLocation in self.dataSourceArray) {
        if ([objLocation.chefLatitude floatValue] == lat && [objLocation.chefLongitude floatValue] == longitude) {
            [APPDELEGATE setChefId:objLocation.chefId];
            break;
        }
    }
    [self.navigationController pushViewController:[APPDELEGATE getSlidePanel] animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        
        if (self.isAfterLogin)
            [self.mapView.userLocation setTitle:self.dinerName];
        else
            return nil;
    }
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        
        // Try to dequeue an existing pin view first.
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView) {
            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
            pinView.calloutOffset = CGPointMake(0, -5);
            pinView.tintColor = AppColor;

            UIImage *imgRed = [UIImage imageNamed:@"red_pin"];
            UIImage *imgYellow = [UIImage imageNamed:@"yellow_icon"];
        
            pinView.image = imgRed;

            float lat = [[pinView annotation] coordinate].latitude;
            float longitude = [[pinView annotation] coordinate].longitude;
            
            for (LocationModal *objLocation in self.dataSourceArray) {
                if ([objLocation.chefLatitude floatValue] == lat && [objLocation.chefLongitude floatValue] == longitude) {
                    
                    if ([objLocation.isVerified isEqualToString:@"0"])
                        pinView.image = imgRed;
                    else
                        pinView.image = imgYellow;
                    
                    break;
                }
            }
            
//           NSInteger index = [mapView.annotations indexOfObject:pinView.annotation];
//            self.locationObj =  [self.dataSourceArray objectAtIndex:index];
//
//                if ([self.locationObj.isVerified isEqualToString:@"0"])
//                    pinView.image = imgRed;
//                else
//                    pinView.image = imgYellow;
            
             //Add a detail disclosure button to the callout.
            
            if (self.isAfterLogin) {
               
                UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                pinView.rightCalloutAccessoryView = rightButton;
                [rightButton setImage:[UIImage imageNamed:@"rightArrow_icon"] forState:UIControlStateNormal];
                
            }
            
        }
        
            ///////////////////// dummy///////////////////////////
//        {
//            // If an existing pin view was not available, create one.
//            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
//            pinView.canShowCallout = YES;
//            pinView.image = [UIImage imageNamed:@"red_pin"];
//            pinView.calloutOffset = CGPointMake(0, -5);
//            pinView.tintColor = [UIColor blueColor];
//            
//            // Add a detail disclosure button to the callout.
//            
//            if (self.isAfterLogin) {
//                UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
//                pinView.rightCalloutAccessoryView = rightButton;
//            }
//            //            UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red_pin"]];
//            //            pinView.rightCalloutAccessoryView = iconView;
//            
//        }
        
            else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

#pragma mark - Web Api Section

- (void)callApiForUserCurrentLocation {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:[NSString stringWithFormat:@"%ld",(long)[[[[self.milesButton titleLabel] text] stringByReplacingOccurrencesOfString:@" Miles" withString:@""] integerValue]] forKey:pRange];
    
    [dict setValue:[APPDELEGATE longitude] forKey:pLongitude];
    [dict setValue:[APPDELEGATE latitude] forKey:platitude];
    
    [dict setValue:self.searchTextField.text forKey:pZipCode];

    if (!self.bothButton.selected)
        (self.vegButton.selected) ? [dict setValue:@"veg" forKey:pMealType] : [dict setValue:@"nonveg" forKey:pMealType];
    else
        [dict setValue:@"" forKey:pMealType];

    [ServiceHelper request:dict apiName:kAPILocation method:POST completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        if (!error) {
            
            NSString *statusCode = [resultDict objectForKeyNotNull:pResponse_code expectedObj:@""];
            if ([statusCode integerValue] == 200) {
                
               self.dataSourceArray = [LocationModal location:[resultDict objectForKeyNotNull:pData expectedObj:[NSDictionary dictionary]]];
                
                NSDictionary *dataDict = [resultDict objectForKeyNotNull:pData expectedObj:[NSDictionary dictionary]];
                NSDictionary *dinerDict = [dataDict objectForKeyNotNull:@"dinerName" expectedObj:[NSDictionary dictionary]];
                self.dinerName = [dinerDict objectForKeyNotNull:pFullName expectedObj:@""];

            } else {
                
                self.dataSourceArray = [[NSArray alloc]init];
                NSString *responseMessage = [resultDict objectForKeyNotNull:pResponse_message expectedObj:@""];
                [AlertController title:responseMessage];
            }
            
        } else {
            [AlertController title:error.localizedDescription];
        }
        
        [self addAllPins];

    }];
}

#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
