//
//  AsyncURLConnection.m
//  
//  Created by Vladimir Boychentsov on 4/20/10.
//  Copyright www.injoit.com 2010. All rights reserved.
//
//  Modified by kivlara on 01/15/2013
//  [+] added advancedModifyRequest, advancedModifyRequestBlockGetFirstBytes

#import <Foundation/Foundation.h>

struct AdvancedModifications
{
    float lenghtToDownload;
    int startFromEnd;
};

typedef void (^responseBlock) (NSString *fileName,NSString *mimeType);
typedef void (^completeBlock) (NSData *data, NSString *url, NSString *mimeType);
typedef void (^errorBlock) (NSError *error);
typedef void (^progressBlock) (float progress);
typedef void (^modifyRequestBlock) (NSMutableURLRequest *request);
typedef void (^advancedModifyRequestBlockGetFirstBytes) (NSMutableURLRequest *request, struct AdvancedModifications *advancedModifications);

@interface AdvancedAsyncURLConnection : NSURLConnection
{

@private
	NSMutableData *dataReceived;
	
	errorBlock _errorBlock;
    completeBlock _completeBlock;
    responseBlock _responseBlock;
    progressBlock _progressBlock;
    advancedModifyRequestBlockGetFirstBytes _advancedModifyRequestBlockGetFirstBytes;
    
    float				bytesReceived;
    float               progressValue;
	long long			expectedBytes;
}

@property (readonly, strong) NSString *stringURLRequest;
@property (readonly, strong) NSString *fileMimeType;
@property (readonly, getter = isPaused) BOOL pauseOperation;
@property (readonly, assign) BOOL cancelAfterResponse;
@property (nonatomic) struct AdvancedModifications advancedModifications;

+ (id)request:(NSString *)requestUrl 
completeBlock:(completeBlock)completeBlock
   errorBlock:(errorBlock)errorBlock;

+ (id)request:(NSString *)requestUrl
modifyRequest:(modifyRequestBlock)modifyRequestBlock
completeBlock:(completeBlock)completeBlock 
   errorBlock:(errorBlock)errorBlock;

+ (id)request:(NSString *)requestUrl
advancedModifyRequest:(advancedModifyRequestBlockGetFirstBytes)modifyRequestBlock
completeBlock:(completeBlock)completeBlock
   errorBlock:(errorBlock)errorBlock;

+ (id)request:(NSString *)requestUrl
advancedModifyRequest:(advancedModifyRequestBlockGetFirstBytes)modifyRequestBlock
responseBlock:(responseBlock)responseBlock
   errorBlock:(errorBlock)errorBlock;

+ (id)request:(NSString *)requestUrl 
completeBlock:(completeBlock)completeBlock 
   errorBlock:(errorBlock)errorBlock
     progress:(progressBlock)progressBlock;

+ (id)request:(NSString *)requestUrl 
modifyRequest:(modifyRequestBlock)modifyRequestBlock
completeBlock:(completeBlock)completeBlock 
   errorBlock:(errorBlock)errorBlock
     progress:(progressBlock)progressBlock;

- (id)initWithRequest:(NSString *)requestUrl 
        modifyRequest:(modifyRequestBlock)modifyRequestBlock
        completeBlock:(completeBlock)completeBlock 
           errorBlock:(errorBlock)errorBlock
             progress:(progressBlock)progressBlock;

- (void) pause;
- (void) resume;

@end