//
//  MPDysymbolTable.h
//  MachOParsing
//
//  Created by 小七 on 2023/12/13.
//

#import <Foundation/Foundation.h>
#import "Prefix.h"
#import "MPSymbolTable.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPDysymbolTable : NSObject

// The parts of struct nlist_64 pulled out so that our property accessors can be synthesized.
@property(assign, nonatomic) uint32_t indirectIndex;
@property(copy, nonatomic) NSString *symbolTable;
@property(copy, nonatomic) NSString *sectionIndex;
@property(assign, nonatomic) uint64_t indirectAddress;

@property(assign, nonatomic) NSMutableArray *descriptions;
@property(assign, nonatomic) NSMutableArray *values;

+ (instancetype)_initWithDataIndirectIndex:(uint32_t)_indirectIndex
                               symbolTable:(NSString *)_symbolTable
                              sectionIndex:(NSString *)_sectionIndex
                           indirectAddress:(uint64_t)_indirectAddress;

- (NSMutableArray *)getDetailsFromCursor:(DataCursor *)cursor;

@end

NS_ASSUME_NONNULL_END
