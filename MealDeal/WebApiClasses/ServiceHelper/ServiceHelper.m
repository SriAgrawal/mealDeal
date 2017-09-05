//
//  ServiceHelper.m
//  VoiceSociety
//
//  Created by Raj Kumar Sharma on 05/08/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//


//@@@@@@@@@@@@@@@ Version v3 @@@@@@@@@@@@@@@@@@@@@@@

#import "ServiceHelper.h"
#import "Macro.h"

//TODO:- // Note:- Implement delegates if required for your requirement. PUT and Delete are not tested; May requires improvement

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> APIs Constants Start >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

static double timeoutInterval = 45.0;

// Local
//static NSString *baseURL = @"http://172.16.16.159:1406/";

// Staging

static NSString *baseURL = @"http://ec2-52-76-162-65.ap-southeast-1.compute.amazonaws.com:1406/";

static NSString *baseURLChat = @"http://ec2-52-76-162-65.ap-southeast-1.compute.amazonaws.com:1420/";


// Production


//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> APIs Constants Start >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

@interface ServiceHelper()

@end

@implementation ServiceHelper

#pragma mark - Public methods

+ (void)request:(NSMutableDictionary *)parameterDict apiName:(NSString *)name method:(Method)methodType completionBlock:(void (^)(id result, NSError *error))handler {
    
    if (![APPDELEGATE isReachable]) {
        
        NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
        [errorDetails setValue:@"Unable to connect network. Please check your internet connection." forKey:NSLocalizedDescriptionKey];
        
        NSError *error = [NSError errorWithDomain:@"Connection Error!" code:1009 userInfo:errorDetails];
        
        handler(nil,error);
        return ;
    }
    
    NSURL *requestURL = [self requestURL:parameterDict apiName:name method:methodType];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    
    [request setHTTPMethod:[self methodName:methodType]];
    
    if (methodType == POST) {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    [request setHTTPBody:[self body:parameterDict method:methodType]];
    [request setTimeoutInterval:timeoutInterval];
    
    LogInfo(@"\n\n Request URL  >>>>>>  %@",requestURL);
    //LogInfo(@"\n\n Request Header  >>>>>>  %@",request.allHTTPHeaderFields);
    //LogInfo(@"\n\n Request Body  >>>>>>  %@",request.HTTPBody);
    LogInfo(@"\n\n Request Parameters  >>>>>>  %@",[parameterDict toJsonString]);

    if ([self isTokenRequiredForApi:name]) {
        [request setValue:@"TOKEN VALUE" forHTTPHeaderField:@"authorization"];
    }
    
    [self progressHud:YES];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
       
        [self progressHud:NO];
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSInteger responseCode = [httpResponse statusCode];
        
        LogInfo("\n\n Response Code >>>>>> \n%ld",responseCode)
        
        //NSDictionary *responseHeader = [httpResponse allHeaderFields];
        //LogInfo("\n\n Response Header >>>>>> \n%ld",responseHeader)

        if (error != nil) {
            LogInfo(@"\n\n error  >>>>>>  %@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(nil, error);
            });
        } else {
            
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            id result = [NSDictionary dictionaryWithContentsOfJSONURLData:data];
            
            LogInfo("\n\nResponse String>>>> \n%@",responseString);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(result, nil);
            });
        }
    }];
    
    [dataTask resume];
}

//
//+ (void)multirequest:(NSMutableDictionary *)parameterDict apiName:(NSString *)name video:(NSArray *)videoArray mediaType:(NSInteger)mediaType completionBlock:(void (^)(id result, NSError *error))handler {
//
//    if (![APPDELEGATE isReachable]) {
//        
//        NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
//        [errorDetails setValue:@"Unable to connect network. Please check your internet connection." forKey:NSLocalizedDescriptionKey];
//        
//        NSError *error = [NSError errorWithDomain:@"Connection Error!" code:1009 userInfo:errorDetails];
//        
//        handler(nil,error);
//        return ;
//    }
//    
//    NSURL *requestURL = [self requestURL:parameterDict apiName:name method:POST];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
//    
//    [request setHTTPMethod:[self methodName:POST]];
//
//    NSString *boundary = [self generateBoundaryString]; //unique-consistent-string
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//
//    NSData *body = [self createBodyWithBoundary:boundary parameters:parameterDict video:videoArray];
//
//    [request setHTTPBody:body];
//    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
//    [request setHTTPShouldHandleCookies:NO];
//    [request setTimeoutInterval:timeoutInterval];
//    
//    // set the content-length
//    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    
//    LogInfo(@"\n\n Request URL  >>>>>>  %@",requestURL);
//    //LogInfo(@"\n\n Request Header  >>>>>>  %@",request.allHTTPHeaderFields);
//    LogInfo(@"\n\n Request Body  >>>>>>  %@",request.HTTPBody);
//    LogInfo(@"\n\n Request Parameters  >>>>>>  %@",[parameterDict toJsonString]);
//    
//    if ([self isTokenRequiredForApi:name]) {
//        [request setValue:@"TOKEN VALUE" forHTTPHeaderField:@"authorization"];
//    }
//    
//    [self progressHud:YES];
//    
//    NSURLSession *session = [NSURLSession sharedSession]; // use sharedSession or create your own
//    
//    request.HTTPBody = body;
//    
//    NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        
//        [self progressHud:NO];
//        
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//        NSInteger responseCode = [httpResponse statusCode];
//        
//        LogInfo("\n\n Response Code >>>>>> \n%ld",(long)responseCode)
//        
//        //NSDictionary *responseHeader = [httpResponse allHeaderFields];
//        //LogInfo("\n\n Response Header >>>>>> \n%ld",responseHeader)
//        
//        if (error != nil) {
//            LogInfo(@"\n\n error  >>>>>>  %@",error);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                handler(nil, error);
//            });
//        } else {
//            
//            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            id result = [NSDictionary dictionaryWithContentsOfJSONURLData:data];
//            
//            LogInfo("\n\nResponse String>>>> \n%@",responseString);
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                handler(result, nil);
//            });
//        }
//        
//        //        if (error) {
//        //            NSLog(@"error = %@", error);
//        //            return;
//        //        }
//        //
//        //        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        //        NSLog(@"result = %@", result);
//    }];
//    
//    [dataTask resume];
//    
////    
////    //-- Getting response form server
////    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
////    
////    //-- JSON Parsing with response data
////    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
////    NSLog(@"Result = %@",result);
//}


+ (void)multiPartRequest:(NSMutableDictionary *)parameterDict images:(NSArray *)images apiName:(NSString *)name completionBlock:(void (^)(id result, NSError *error))handler {
    
    if (![APPDELEGATE isReachable]) {
        
        NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
        [errorDetails setValue:@"Unable to connect network. Please check your internet connection." forKey:NSLocalizedDescriptionKey];
        
        NSError *error = [NSError errorWithDomain:@"Connection Error!" code:1009 userInfo:errorDetails];
        
        handler(nil,error);
        return ;
    }
    
    //NSURL *requestURL = [NSURL URLWithString:@"http://172.16.0.9/PROJECTS/MICOLUMBIA/trunk/api_v3/version_v3/create_post"];//[self requestURL:parameterDict apiName:name method:POST];
    NSURL *requestURL = [self requestURL:parameterDict apiName:name method:POST];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    
    [request setHTTPMethod:[self methodName:POST]];
    
    NSString *boundary = [self generateBoundaryString]; //unique-consistent-string

    // create body
    NSData *httpBody = [self createBodyWithBoundary:boundary parameters:parameterDict images:images];

    // set content type
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    [request setHTTPBody:httpBody];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:timeoutInterval];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[httpBody length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    LogInfo(@"\n\n Request URL  >>>>>>  %@",requestURL);
    //LogInfo(@"\n\n Request Header  >>>>>>  %@",request.allHTTPHeaderFields);
    LogInfo(@"\n\n Request Body  >>>>>>  %@",request.HTTPBody);
    LogInfo(@"\n\n Request Parameters  >>>>>>  %@",[parameterDict toJsonString]);
    
    if ([self isTokenRequiredForApi:name]) {
        [request setValue:@"TOKEN VALUE" forHTTPHeaderField:@"authorization"];
    }
    
    [self progressHud:YES];
    
    NSURLSession *session = [NSURLSession sharedSession]; // use sharedSession or create your own

    request.HTTPBody = httpBody;
    
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        [self progressHud:NO];
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSInteger responseCode = [httpResponse statusCode];
        
        LogInfo("\n\n Response Code >>>>>> \n%ld",responseCode)
        
        //NSDictionary *responseHeader = [httpResponse allHeaderFields];
        //LogInfo("\n\n Response Header >>>>>> \n%ld",responseHeader)
        
        if (error != nil) {
            LogInfo(@"\n\n error  >>>>>>  %@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(nil, error);
            });
        } else {
            
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            id result = [NSDictionary dictionaryWithContentsOfJSONURLData:data];
            
            LogInfo("\n\nResponse String>>>> \n%@",responseString);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(result, nil);
            });
        }
        
//        if (error) {
//            NSLog(@"error = %@", error);
//            return;
//        }
//        
//        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"result = %@", result);
    }];
    
    [dataTask resume];
}

#pragma mark - Private methods

+ (BOOL)isTokenRequiredForApi:(NSString *)name {
    
    BOOL required = NO;
    
    if ([name isEqualToString:@"API name which need token"]) {
       required = YES;
    }
    
    return required;
}

+ (NSString *)methodName:(Method)methodType {
    
    switch (methodType) {
            
        case GET: return @"GET";
            
        case POST: return @"POST";
            
        case DELETE: return @"DELETE";
            
        case PUT: return @"PUT";
            
    }
}

+ (NSData *)body:(NSMutableDictionary *)parameterDict method:(Method)methodType {
    
    switch (methodType) {
            
        case GET: return [NSData data];
            
        case POST: return [parameterDict toNSData];
            
        case DELETE: return [NSData data];
            
        case PUT: return [parameterDict toNSData]; // depends on server requirement
            
    }
}

+ (NSURL *)formattedURL:(NSMutableDictionary *)parameterDict apiName:(NSString *)name {
    NSMutableString *urlString;
    if([name isEqualToString:@"ChatHistory"])
    {
        urlString = [NSMutableString stringWithFormat:@"%@%@", baseURLChat, name];
    }else{
       urlString = [NSMutableString stringWithFormat:@"%@%@", baseURL, name];
    }
    BOOL isFirst = YES;
    
    for (NSString *key in [parameterDict allKeys]) {
        
        id object = parameterDict[key];
        if ([object isKindOfClass:[NSArray class]]) {
            
            for (id eachObject in object) {
                
                [urlString appendString:[NSString stringWithFormat:@"%@%@=%@", isFirst ? @"?": @"&", key, eachObject]];
                isFirst = NO;
            }
        } else {
            [urlString appendString:[NSString stringWithFormat:@"%@%@=%@", isFirst ? @"?": @"&", key, parameterDict[key]]];
        }
        
        isFirst = NO;
    }
    
    NSString *encodedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return [NSURL URLWithString:encodedString];
}

+ (NSURL *)requestURL:(NSMutableDictionary *)parameterDict apiName:(NSString *)name method:(Method)methodType {
    NSString *urlString;
    if([name isEqualToString:@"ChatHistory"]){
        urlString = [NSString stringWithFormat:@"%@%@",baseURLChat,name];
    }
    else{
        urlString = [NSString stringWithFormat:@"%@%@",baseURL,name];
    }
    
    switch (methodType) {
            
        case GET: return [self formattedURL:parameterDict apiName:name];
            
        case POST:return [NSURL URLWithString:urlString];
            
        default: return [NSURL URLWithString:urlString];
    }
}

+ (NSTimeInterval )currentTimeStamp {
    NSTimeInterval timeInSeconds = [[NSDate date] timeIntervalSince1970];
    return timeInSeconds;
}

+ (NSString *)randomGlobalUniqueString {
    NSString *randomString = [NSString stringWithFormat:@"%@%.0f", [[[NSProcessInfo processInfo] globallyUniqueString] stringByReplacingOccurrencesOfString:@"-" withString:@""], [[NSDate date] timeIntervalSince1970]];
    
    return randomString;
}

+ (NSString *)generateBoundaryString {
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
    
    // if supporting iOS versions prior to 6.0, you do something like:
    //
    // // generate boundary string
    // //
    // adapted from http://developer.apple.com/library/ios/#samplecode/SimpleURLConnections
    //
    // CFUUIDRef  uuid;
    // NSString  *uuidStr;
    //
    // uuid = CFUUIDCreate(NULL);
    // assert(uuid != NULL);
    //
    // uuidStr = CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
    // assert(uuidStr != NULL);
    //
    // CFRelease(uuid);
    //
    // return uuidStr;
}

// This is the method used above to build the body of the request:

+ (NSData *)createBodyWithBoundary:(NSString *)boundary
                        parameters:(NSDictionary *)parameters
                            images:(NSArray *)images
/*paths:(NSArray *)paths
 fieldName:(NSString *)fieldName*/ {
     
     NSMutableData *httpBody = [NSMutableData data];
     
     //NSString *keyForImages = @"mediaFiles";
     
     // add params (all params are strings)
     
     [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
         [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
         [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
         [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
     }];
     
     
     // add image data
     
     int counter = 1;
     
     for (UIImage *image in images) {
         NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
         
         [httpBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
         //[httpBody appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",[NSString stringWithFormat:@"file_%d_%f",counter,[self currentTimeStamp]],keyForImages]] dataUsingEncoding:NSUTF8StringEncoding]];
         [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpg\r\n", @"photo"] dataUsingEncoding:NSUTF8StringEncoding]];
         //[httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=\"%@\r\n", keyForImages,[NSString stringWithFormat:@"file_%d_%f",counter,[self currentTimeStamp]]] dataUsingEncoding:NSUTF8StringEncoding]];


         [httpBody appendData:[@"Content-Type:application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
         [httpBody appendData:imageData];
         [httpBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
         counter++;
     }
     
     //    for (NSString *path in paths) {
     //        NSString *filename  = [path lastPathComponent];
     //        NSData   *data      = [NSData dataWithContentsOfFile:path];
     //        NSString *mimetype  = [self mimeTypeForPath:path];
     //
     //        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     //        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
     //
     //        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
     //        [httpBody appendData:data];
     //        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
     //    }
     
     [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     
     return httpBody;
 }


//
//
//+ (NSData *)createBodyWithBoundary:(NSString *)boundary
//                        parameters:(NSDictionary *)parameters
//                            video:(NSArray *)videoArray
///*paths:(NSArray *)paths
// fieldName:(NSString *)fieldName*/ {
//     
//     NSMutableData *httpBody = [NSMutableData data];
//     
//     //NSString *keyForImages = @"mediaFiles";
//     
//     // add params (all params are strings)
//     
//     [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
//         [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//         [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
//         [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
//     }];
//     
//     
//     // add image data
//     
//     int counter = 1;
//     
//     for (UIImage *image in images) {
//         
//         
//         
//         
//         //-- Append data into posr url using following method
//         NSMutableData *body = [NSMutableData data];
//         
//         
//         //-- For Sending text
//         
//         //-- "firstname" is keyword form service
//         //-- "first_name" is the text which we have to send
//         [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//         [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"firstname"] dataUsingEncoding:NSUTF8StringEncoding]];
//         [body appendData:[[NSString stringWithFormat:@"%@",first_name] dataUsingEncoding:NSUTF8StringEncoding]];
//         
//         
//         //-- For sending image into service if needed (send image as imagedata)
//         
//         //-- "image_name" is file name of the image (we can set custom name)
//         [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//         
//         [body appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data; name=\"file\"; filename=\"%@\"\r\n",image_name] dataUsingEncoding:NSUTF8StringEncoding]];
//         [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//         [body appendData:[NSData dataWithData:imageData]];
//         [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//         
//         
//         
//         
//         
//         
//         
//         
//         
//         NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
//         
//         [httpBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//         //[httpBody appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",[NSString stringWithFormat:@"file_%d_%f",counter,[self currentTimeStamp]],keyForImages]] dataUsingEncoding:NSUTF8StringEncoding]];
//         [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpg\r\n", @"photo"] dataUsingEncoding:NSUTF8StringEncoding]];
//         //[httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=\"%@\r\n", keyForImages,[NSString stringWithFormat:@"file_%d_%f",counter,[self currentTimeStamp]]] dataUsingEncoding:NSUTF8StringEncoding]];
//         
//         
//         [httpBody appendData:[@"Content-Type:application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//         [httpBody appendData:imageData];
//         [httpBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//         counter++;
//     }
//     
//     
//         for (NSString *path in paths) {
//             NSString *filename  = [path lastPathComponent];
//             NSData   *data      = [NSData dataWithContentsOfFile:path];
//             NSString *mimetype  = [self mimeTypeForPath:path];
//     
//             [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//             [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
//     
//             [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
//             [httpBody appendData:data];
//             [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//         }
//     
//     [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//     
//     return httpBody;
// }
//






//- (NSString *)mimeTypeForPath:(NSString *)path {
//    // get a mime type for an extension using MobileCoreServices.framework
//
//    CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
//    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
//    assert(UTI != NULL);
//
//    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
//    assert(mimetype != NULL);
//    
//    CFRelease(UTI);
//    
//    return mimetype;
//}

+ (void)progressHud:(BOOL)status {
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MBProgressHUD *hud = [MBProgressHUD HUDForView:[APPDELEGATE window]];

        if (status) {
            if (hud == nil) {
                hud = [MBProgressHUD showHUDAddedTo:[APPDELEGATE window] animated:YES];
            }
            [hud setCornerRadius:8.0];
            [hud.bezelView setColor:RGBCOLOR(0, 0, 0, 0.8)];
            [hud setMargin:12];
            [hud setActivityIndicatorColor:[UIColor whiteColor]];
            
        } else {
            
            [hud hideAnimated:true afterDelay:0.1];
        }
    });
    
}

@end

// See for multi part request
// http://stackoverflow.com/questions/19099448/send-post-request-using-nsurlsession
// https://gist.github.com/mombrea/8467128
// http://stackoverflow.com/questions/8564833/ios-upload-image-and-text-using-http-post
// http://stackoverflow.com/questions/24250475/post-multipart-form-data-with-objective-c
/*
 
 // http://www.iana.org/assignments/http-status-codes/http-status-codes.xhtml
 
 if status == 400 { description = "Bad Request" }
 
 if status == 401 { description = "Unauthorized" }
 
 if status == 402 { description = "Payment Required" }
 
 if status == 403 { description = "Forbidden" }
 
 if status == 404 { description = "Not Found" }
 
 if status == 405 { description = "Method Not Allowed" }
 
 if status == 406 { description = "Not Acceptable" }
 
 if status == 407 { description = "Proxy Authentication Required" }
 
 if status == 408 { description = "Request Timeout" }
 
 if status == 409 { description = "Conflict" }
 
 if status == 410 { description = "Gone" }
 
 if status == 411 { description = "Length Required" }
 
 if status == 412 { description = "Precondition Failed" }
 
 if status == 413 { description = "Payload Too Large" }
 
 if status == 414 { description = "URI Too Long" }
 
 if status == 415 { description = "Unsupported Media Type" }
 
 if status == 416 { description = "Requested Range Not Satisfiable" }
 
 if status == 417 { description = "Expectation Failed" }
 
 if status == 422 { description = "Unprocessable Entity" }
 
 if status == 423 { description = "Locked" }
 
 if status == 424 { description = "Failed Dependency" }
 
 if status == 425 { description = "Unassigned" }
 
 if status == 426 { description = "Upgrade Required" }
 
 if status == 427 { description = "Unassigned" }
 
 if status == 428 { description = "Precondition Required" }
 
 if status == 429 { description = "Too Many Requests" }
 
 if status == 430 { description = "Unassigned" }
 
 if status == 431 { description = "Request Header Fields Too Large" }
 
 if status == 432 { description = "Unassigned" }
 
 if status == 500 { description = "Internal Server Error" }
 
 if status == 501 { description = "Not Implemented" }
 
 if status == 502 { description = "Bad Gateway" }
 
 if status == 503 { description = "Service Unavailable" }
 
 if status == 504 { description = "Gateway Timeout" }
 
 if status == 505 { description = "HTTP Version Not Supported" }
 
 if status == 506 { description = "Variant Also Negotiates" }
 
 if status == 507 { description = "Insufficient Storage" }
 
 if status == 508 { description = "Loop Detected" }
 
 if status == 509 { description = "Unassigned" }
 
 if status == 510 { description = "Not Extended" }
 
 if status == 511 { description = "Network Authentication Required" }
 
 */
