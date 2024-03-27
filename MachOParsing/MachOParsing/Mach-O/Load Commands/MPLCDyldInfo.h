//
//  MPLCDyldInfo.h
//  MachOParsing
//
//  Created by 小七 on 2023/12/2.
//

#import <Foundation/Foundation.h>
#import "Prefix.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPLCDyldInfo : NSObject

// The parts of struct dyld_info_command pulled out so that our property accessors can be synthesized.
@property(assign, nonatomic) uint32_t cmd;
@property(assign, nonatomic) uint32_t cmdsize;
@property(assign, nonatomic) uint32_t rebase_off;
@property(assign, nonatomic) uint32_t rebase_size;
@property(assign, nonatomic) uint32_t bind_off;
@property(assign, nonatomic) uint32_t bind_size;
@property(assign, nonatomic) uint32_t weak_bind_off;
@property(assign, nonatomic) uint32_t weak_bind_size;
@property(assign, nonatomic) uint32_t lazy_bind_off;
@property(assign, nonatomic) uint32_t lazy_bind_size;
@property(assign, nonatomic) uint32_t export_off;
@property(assign, nonatomic) uint32_t export_size;

@property(assign, nonatomic) NSMutableArray *descriptions;
@property(assign, nonatomic) NSMutableArray *values;

+ (instancetype)_initWithDataCmd:(uint32_t)cmd
                         cmdsize:(uint32_t)_cmdsize
                      rebase_off:(uint32_t)_rebase_off
                     rebase_size:(uint32_t)_rebase_size
                        bind_off:(uint32_t)_bind_off
                       bind_size:(uint32_t)_bind_size
                   weak_bind_off:(uint32_t)_weak_bind_off
                  weak_bind_size:(uint32_t)_weak_bind_size
                   lazy_bind_off:(uint32_t)_lazy_bind_off
                  lazy_bind_size:(uint32_t)_lazy_bind_size
                      export_off:(uint32_t)_export_off
                     export_size:(uint32_t)_export_size;

@end

NS_ASSUME_NONNULL_END
