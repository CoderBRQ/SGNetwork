//
//  SGNetworkFileHander.h
//  SGNetwork
//
//  Created by bianrongqiang on 2020/2/26.
//

#ifndef SGNetworkFileHander_h
#define SGNetworkFileHander_h


#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * SG_resumeDataSubdirectory = @"com.sgnetwork.resumedatas";
static NSString * SG_fileSubdirectory = @"com.sgnetwork.sgfiles";


// Create file name by url
#define SG_MAX_FILE_EXTENSION_LENGTH (NAME_MAX - CC_MD5_DIGEST_LENGTH * 2 - 1)
NSString * SGFileNameWithURLString(NSString * key) {
    const char *str = key.UTF8String;
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSURL *keyURL = [NSURL URLWithString:key];
    NSString *ext = keyURL ? keyURL.pathExtension : key.pathExtension;
    // File system has file name length limit, we need to check if ext is too long, we don't add it to the filename
    if (ext.length > SG_MAX_FILE_EXTENSION_LENGTH) {
        ext = nil;
    }
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%@",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
                          r[11], r[12], r[13], r[14], r[15], ext.length == 0 ? @"" : [NSString stringWithFormat:@".%@", ext]];
    return filename;
}

BOOL SGIsResumeDataExitWithURLString(NSString * URLString) {
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        
    NSFileManager *fileManager = [NSFileManager defaultManager];
    cachesPath = [cachesPath stringByAppendingPathComponent:SG_resumeDataSubdirectory];
    cachesPath = [cachesPath stringByAppendingPathComponent:SGFileNameWithURLString(URLString)];
    BOOL isDir;
    BOOL isExit = [fileManager fileExistsAtPath:cachesPath isDirectory:&isDir];
    return isExit;
}

BOOL SGIsFileExitWithURLString(NSString * URLString) {
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        
    NSFileManager *fileManager = [NSFileManager defaultManager];
    cachesPath = [cachesPath stringByAppendingPathComponent:SG_fileSubdirectory];
    cachesPath = [cachesPath stringByAppendingPathComponent:SGFileNameWithURLString(URLString)];
    BOOL isDir;
    BOOL isExit = [fileManager fileExistsAtPath:cachesPath isDirectory:&isDir];
    return isExit;
}

// Create file path
NSString * SGCreateFilePath(NSString * URLString) {
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
       
   NSFileManager *fileManager = [NSFileManager defaultManager];
   cachesPath = [cachesPath stringByAppendingPathComponent:SG_fileSubdirectory];
   BOOL isDir;
   BOOL isExit = [fileManager fileExistsAtPath:cachesPath isDirectory:&isDir];
   if (!isExit || !isDir) {
       [fileManager createDirectoryAtPath:cachesPath withIntermediateDirectories:YES attributes:nil error:nil];
   }
   
   NSString *path = [cachesPath stringByAppendingPathComponent:SGFileNameWithURLString(URLString)];
   return path;
}

// Create resumeData file path
NSString * SGCreateResumeDataFilePath(NSString * URLString) {
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    cachesPath = [cachesPath stringByAppendingPathComponent:SG_resumeDataSubdirectory];
    BOOL isDir;
    BOOL isExit = [fileManager fileExistsAtPath:cachesPath isDirectory:&isDir];
    if (!isExit || !isDir) {
        [fileManager createDirectoryAtPath:cachesPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *path = [cachesPath stringByAppendingPathComponent:SGFileNameWithURLString(URLString)];
    return path;
}

NSString * SGFilePathWithURLString(NSString * URLString) {
    return SGCreateFilePath(URLString);
}

// Get resumedata file path
NSString * SGResumeDataFilePathWithURLString(NSString * URLString) {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:SG_resumeDataSubdirectory];
    path = [path stringByAppendingPathComponent:SGFileNameWithURLString(URLString)];
    return path;
}

// Get data by url string
NSData * SGResumeDataWithURLString(NSString * URLString) {
    return [NSData dataWithContentsOfFile:SGResumeDataFilePathWithURLString(URLString)];
}

// Remove resume data
void SGRemoveResumeDataWithURLString(NSString * URLString) {
    [NSFileManager.defaultManager removeItemAtURL:[NSURL fileURLWithPath:SGResumeDataFilePathWithURLString(URLString)] error:nil];
}

NS_ASSUME_NONNULL_END

#endif /* SGNetworkFileHander_h */
