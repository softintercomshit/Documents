//
//  FileTypeDetector.h
//  Music DL
//
//  Created by Radoo on 11.11.13.
//  Copyright (c) 2013 Radoo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FileTypeResultBlock)(NSString *fileName, NSString *mimeType);

@interface FileTypeDetector : NSObject

+ (void) findFileTypeFromURL:(NSString *) url resultBlock:(FileTypeResultBlock) resultBlock;

@end
