//
//  AsyncURLConnection.m
//  
//  Created by Vladimir Boychentsov on 4/20/10.
//  Copyright www.injoit.com 2010. All rights reserved.
//
//  Modified by kivlara on 01/15/2013
//  [+] added advancedModifyRequest, advancedModifyRequestBlockGetFirstBytes



#import "AdvancedAsyncURLConnection.h"

@implementation AdvancedAsyncURLConnection

@synthesize stringURLRequest = _stringURLRequest;
@synthesize pauseOperation = _pauseOperation;
@synthesize cancelAfterResponse = _cancelAfterResponse;

+ (id) request:(NSString *)requestUrl
completeBlock:(completeBlock)completeBlock 
   errorBlock:(errorBlock)errorBlock
{
    
	return [[self alloc] initWithRequest:requestUrl
                            modifyRequest:^(NSMutableURLRequest *r) {}
                            completeBlock:completeBlock 
                               errorBlock:errorBlock
                                 progress:^(float progress) {}];
}

+ (id) request:(NSString *)requestUrl
modifyRequest:(modifyRequestBlock)modifyRequestBlock
completeBlock:(completeBlock)completeBlock 
   errorBlock:(errorBlock)errorBlock
{
    
	return [[self alloc] initWithRequest:requestUrl
                            modifyRequest:modifyRequestBlock
                            completeBlock:completeBlock 
                               errorBlock:errorBlock
                                 progress:^(float progress) {}];
}

+ (id) request:(NSString *)requestUrl
advancedModifyRequest:(advancedModifyRequestBlockGetFirstBytes)modifyRequestBlock
completeBlock:(completeBlock)completeBlock
   errorBlock:(errorBlock)errorBlock
{

	return [[self alloc] initWithRequest:requestUrl
                           advancedModifyRequest:modifyRequestBlock
                           completeBlock:completeBlock
                              errorBlock:errorBlock
                                progress:^(float progress) {}];

}

//#########
+ (id) request:(NSString *)requestUrl
advancedModifyRequest:(advancedModifyRequestBlockGetFirstBytes)modifyRequestBlock
responseBlock:(responseBlock)responseBlock
   errorBlock:(errorBlock)errorBlock
{
    
	return [[self alloc] initWithRequest:requestUrl
                   advancedModifyRequest:modifyRequestBlock
                           responseBlock:responseBlock
                              errorBlock:errorBlock];
    
}
//#########

+ (id) request:(NSString *)requestUrl
completeBlock:(completeBlock)completeBlock 
   errorBlock:(errorBlock)errorBlock
     progress:(progressBlock)progressBlock
{
    
	return [[self alloc] initWithRequest:requestUrl
                            modifyRequest:^(NSMutableURLRequest *r) {}
                            completeBlock:completeBlock 
                               errorBlock:errorBlock
                                 progress:progressBlock];
}

+ (id) request:(NSString *)requestUrl
modifyRequest:(modifyRequestBlock)modifyRequestBlock
completeBlock:(completeBlock)completeBlock 
   errorBlock:(errorBlock)errorBlock
     progress:(progressBlock)progressBlock
{
    
	return [[self alloc] initWithRequest:requestUrl
                            modifyRequest:modifyRequestBlock
                            completeBlock:completeBlock 
                               errorBlock:errorBlock
                            progress:progressBlock];
}

- (id) initWithRequest:(NSString *)requestUrl
        modifyRequest:(modifyRequestBlock)modifyRequestBlock
        completeBlock:(completeBlock)completeBlock 
           errorBlock:(errorBlock)errorBlock 
             progress:(progressBlock)progressBlock
{
    
    _stringURLRequest = [[NSString stringWithString:requestUrl] copy];
    
	NSURL *url = [NSURL URLWithString:requestUrl];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    modifyRequestBlock(request);
    
	if ((self = [super initWithRequest:request delegate:self startImmediately:NO]))
    {
		dataReceived = [[NSMutableData alloc] init];
        _pauseOperation = NO;
        _cancelAfterResponse = NO;
		_completeBlock = [completeBlock copy];
		_errorBlock = [errorBlock copy];
        _progressBlock = [progressBlock copy];
        
        bytesReceived = progressValue = 0;
        
        [self start];
	}

	return self;
}

- (id) initWithRequest:(NSString *)requestUrl
        advancedModifyRequest:(advancedModifyRequestBlockGetFirstBytes)advancedModifyRequest
        completeBlock:(completeBlock)completeBlock
           errorBlock:(errorBlock)errorBlock
             progress:(progressBlock)progressBlock
{
    
    _stringURLRequest = [[NSString stringWithString:requestUrl] copy];
    
	NSURL *url = [NSURL URLWithString:requestUrl];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    advancedModifyRequest(request, &(_advancedModifications));
    
	if ((self = [super initWithRequest:request delegate:self startImmediately:NO]))
    {
		dataReceived = [[NSMutableData alloc] init];
        _pauseOperation = NO;
        _cancelAfterResponse = NO;
		_completeBlock = [completeBlock copy];
		_errorBlock = [errorBlock copy];
        _progressBlock = [progressBlock copy];
        _advancedModifyRequestBlockGetFirstBytes = [advancedModifyRequest copy];
        
       // lenghtOfFirstBytes = firstBytes;
        bytesReceived = progressValue = 0;
        
        [self start];
	}
    
	return self;
}

- (id) initWithRequest:(NSString *)requestUrl
advancedModifyRequest:(advancedModifyRequestBlockGetFirstBytes)advancedModifyRequest
        responseBlock:(responseBlock)responseBlock
           errorBlock:(errorBlock)errorBlock
{
	NSURL *url = [NSURL URLWithString:requestUrl];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    advancedModifyRequest(request, &(_advancedModifications));

	if ((self = [super initWithRequest:request delegate:self startImmediately:NO]))
    {
        _responseBlock = [responseBlock copy];
        _pauseOperation = YES;
        _cancelAfterResponse = YES;
		_errorBlock = [errorBlock copy];
        _advancedModifyRequestBlockGetFirstBytes = [advancedModifyRequest copy];
        [self start];
	}
    
	return self;
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (_cancelAfterResponse)
    {
        _responseBlock([response suggestedFilename],response.MIMEType);
        [self cancel];
        return;
    }
    
	NSHTTPURLResponse *r = (NSHTTPURLResponse*)response;
	NSDictionary *headers = [r allHeaderFields];
	if (headers)
    {
		if ([headers objectForKey: @"Content-Range"])
        {
			NSString *contentRange = [headers objectForKey: @"Content-Range"];
			NSRange range = [contentRange rangeOfString: @"/"];
			NSString *totalBytesCount = [contentRange substringFromIndex: range.location + 1];
			expectedBytes = [totalBytesCount floatValue];
		} else if ([headers objectForKey: @"Content-Length"])
        {
			expectedBytes = [[headers objectForKey: @"Content-Length"] floatValue];
		} else expectedBytes = -1;
        
		if ([@"Identity" isEqualToString: [headers objectForKey: @"Transfer-Encoding"]])
        {
			expectedBytes = bytesReceived;
		}
	}
    [dataReceived setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!_pauseOperation)
    {
        [dataReceived appendData:data];
        
        float receivedLen = [data length];
        bytesReceived = (bytesReceived + receivedLen);
        
        if(bytesReceived > _advancedModifications.lenghtToDownload)
        {
            [connection cancel];
            [self connectionDidFinishLoading:connection];
            [self cancel];
        }
        
        if(expectedBytes != NSURLResponseUnknownLength)
        {
            progressValue = ((bytesReceived/(float)expectedBytes)*100.0)/100.0;
            _progressBlock(progressValue);
        }
    }
    else
    {
        [self cancel];
    }
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
	_completeBlock(dataReceived, _stringURLRequest, _fileMimeType);
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	_errorBlock(error);
}

- (void) pause
{
	_pauseOperation = YES;
}

- (void) resume
{
	_pauseOperation = NO;
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.stringURLRequest]];    
	[request addValue: [NSString stringWithFormat: @"bytes=%.0f-", bytesReceived ] forHTTPHeaderField: @"Range"];	
    //self = (AsyncURLConnection*)[AsyncURLConnection connectionWithRequest:request delegate:self];
	
}

@end