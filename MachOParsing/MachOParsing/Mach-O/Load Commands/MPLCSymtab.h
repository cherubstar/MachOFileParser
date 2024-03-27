//
//  MPLCSymtab.h
//  MachOParsing
//
//  Created by 小七 on 2023/12/2.
//

#import <Foundation/Foundation.h>
#import "Prefix.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPLCSymtab : NSObject

// The parts of struct symtab_command pulled out so that our property accessors can be synthesized.
@property(assign, nonatomic) uint32_t cmd;
@property(assign, nonatomic) uint32_t cmdsize;
@property(assign, nonatomic) uint32_t symoff;
@property(assign, nonatomic) uint32_t nsyms;
@property(assign, nonatomic) uint32_t stroff;
@property(assign, nonatomic) uint32_t strsize;

@property(assign, nonatomic) NSMutableArray *descriptions;
@property(assign, nonatomic) NSMutableArray *values;

+ (instancetype)_initWithDataCmd:(uint32_t)cmd
                         cmdsize:(uint32_t)_cmdsize
                          symoff:(uint32_t)_symoff
                           nsyms:(uint32_t)_nsyms
                          stroff:(uint32_t)_stroff
                         strsize:(uint32_t)_strsize;

- (NSMutableArray *)getDetailsFromCursor:(DataCursor *)cursor;

@end

NS_ASSUME_NONNULL_END
