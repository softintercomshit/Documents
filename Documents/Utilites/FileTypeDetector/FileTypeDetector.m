//
//  FileTypeDetector.m
//  Music DL
//
//  Created by Radoo on 11.11.13.
//  Copyright (c) 2013 Radoo. All rights reserved.
//

#import "FileTypeDetector.h"
#import "AdvancedAsyncURLConnection.h"

@implementation FileTypeDetector

+ (void) findFileTypeFromURL:(NSString *) url resultBlock:(FileTypeResultBlock) resultBlock
{
    [AdvancedAsyncURLConnection request:url
    advancedModifyRequest:^(NSMutableURLRequest *request, struct AdvancedModifications *advancedModifications)
    {
         advancedModifications->lenghtToDownload = 10;
    }
    responseBlock:^(NSString *fileName, NSString *mimeType)
    {
         resultBlock(fileName, mimeType);
    }
    errorBlock:^(NSError *error)
    {
         NSLog(@"Error while getting file type from url: %@",error.localizedDescription);
         resultBlock(nil, nil);
    }];
}

@end
