//
//
//  Bridging-Header necessário para importação da Common Crypto
//  lib nativa utilizada com a finalidade de transformar a string
//  timeStamp + privateKey + publicKey em MD5, como requer a API da Marvel
//

#import <CommonCrypto/CommonDigest.h>
