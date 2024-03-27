//
//  MPSymbolTable.h
//  MachOParsing
//
//  Created by 小七 on 2023/12/10.
//

#import <Foundation/Foundation.h>
#import "Prefix.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPSymbolTable : NSObject

// The parts of struct nlist_64 pulled out so that our property accessors can be synthesized.
@property(assign, nonatomic) uint32_t n_strx;
@property(assign, nonatomic) uint8_t n_type;
@property(assign, nonatomic) uint8_t n_sect;
@property(assign, nonatomic) uint16_t n_desc;
@property(assign, nonatomic) uint64_t n_value;

@property(assign, nonatomic) NSMutableArray *descriptions;
@property(assign, nonatomic) NSMutableArray *values;

+ (instancetype)_initWithDataN_strx:(uint32_t)_n_strx
                             n_type:(uint8_t)_n_type
                             n_sect:(uint8_t)_n_sect
                             n_desc:(uint16_t)_n_desc
                            n_value:(uint64_t)_n_value;

- (NSMutableArray *)getDetailsFromCursor:(DataCursor *)cursor strtab:(char *)strtab section:(MPSection *)section;

@end

NS_ASSUME_NONNULL_END
