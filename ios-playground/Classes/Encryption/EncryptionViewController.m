//
//  EncryptionViewController.m
//  ios-playground
//
//  Created by 小方 亮佑 on 2015/11/10.
//  Copyright © 2015年 oganity. All rights reserved.
//

#import "EncryptionViewController.h"
#import <CommonCrypto/CommonCrypto.h>

@interface EncryptionViewController ()

@end

@implementation EncryptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *salt = @"salt";
    int iterations = 1000;
    int derivedKeyLength = 32;
    NSLog(@"%@", [self encryptStringWithPassword:@"pass" salt:salt iterations:iterations derivedKeyLength:derivedKeyLength]);
    NSLog(@"%@", [self encryptStringWithPassword:@"passw" salt:salt iterations:iterations derivedKeyLength:derivedKeyLength]);
    NSLog(@"%@", [self encryptStringWithPassword:@"passwo" salt:salt iterations:iterations derivedKeyLength:derivedKeyLength]);
    NSLog(@"%@", [self encryptStringWithPassword:@"passwor" salt:salt iterations:iterations derivedKeyLength:derivedKeyLength]);
    NSLog(@"%@", [self encryptStringWithPassword:@"password" salt:salt iterations:iterations derivedKeyLength:derivedKeyLength]);
}

- (NSString *)encryptStringWithPassword:(NSString *)password salt:(NSString *)salt iterations:(int)iterations derivedKeyLength:(int)derivedKeyLength {
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    NSData *saltData = [salt dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *derivedKey = [NSMutableData dataWithLength:derivedKeyLength];
    int retKeyDer = CCKeyDerivationPBKDF(kCCPBKDF2,
                         passwordData.bytes, passwordData.length,
                         saltData.bytes, saltData.length,
                         kCCPRFHmacAlgSHA256,
                         iterations,
                         derivedKey.mutableBytes,
                         derivedKey.length);
    if (retKeyDer == kCCSuccess) {
        return [derivedKey base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//        NSMutableString *result = [NSMutableString string];
//        const char *bytes = [derivedKey bytes];
//        for (int i = 0; i < [derivedKey length]; i++)
//        {
//            [result appendFormat:@"%02hhx", (unsigned char)bytes[i]];
//        }
//        return result;
    }
    return nil;
}

@end
