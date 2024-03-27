//
//  MPLCEncryptionInfo.h
//  MachOParsing
//
//  Created by 小七 on 2023/12/2.
//

#import <Foundation/Foundation.h>
#import "Prefix.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPLCEncryptionInfo : NSObject

// The parts of struct encryption_info_command_64 pulled out so that our property accessors can be synthesized.
@property(assign, nonatomic) uint32_t cmd;
@property(assign, nonatomic) uint32_t cmdsize;
@property(assign, nonatomic) uint32_t cryptoff;
@property(assign, nonatomic) uint32_t cryptsize;
@property(assign, nonatomic) uint32_t cryptid;
@property(assign, nonatomic) uint32_t pad;

@property(assign, nonatomic) NSMutableArray *descriptions;
@property(assign, nonatomic) NSMutableArray *values;

+ (instancetype)_initWithDataCmd:(uint32_t)cmd
                         cmdsize:(uint32_t)_cmdsize
                        cryptoff:(uint32_t)_cryptoff
                       cryptsize:(uint32_t)_cryptsize
                         cryptid:(uint32_t)_cryptid
                             pad:(uint32_t)_pad;

- (NSMutableArray *)getDetailsFromCursor:(DataCursor *)cursor;

@end

NS_ASSUME_NONNULL_END
