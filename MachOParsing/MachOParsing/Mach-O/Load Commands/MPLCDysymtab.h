//
//  MPLCDysymtab.h
//  MachOParsing
//
//  Created by 小七 on 2023/12/2.
//

#import <Foundation/Foundation.h>
#import "Prefix.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPLCDysymtab : NSObject

// The parts of struct dysymtab_command pulled out so that our property accessors can be synthesized.
@property(assign, nonatomic) uint32_t cmd;
@property(assign, nonatomic) uint32_t cmdsize;
@property(assign, nonatomic) uint32_t ilocalsym;
@property(assign, nonatomic) uint32_t nlocalsym;
@property(assign, nonatomic) uint32_t iextdefsym;
@property(assign, nonatomic) uint32_t nextdefsym;
@property(assign, nonatomic) uint32_t iundefsym;
@property(assign, nonatomic) uint32_t nundefsym;
@property(assign, nonatomic) uint32_t tocoff;
@property(assign, nonatomic) uint32_t ntoc;
@property(assign, nonatomic) uint32_t modtaboff;
@property(assign, nonatomic) uint32_t nmodtab;
@property(assign, nonatomic) uint32_t extrefsymoff;
@property(assign, nonatomic) uint32_t nextrefsyms;
@property(assign, nonatomic) uint32_t indirectsymoff;
@property(assign, nonatomic) uint32_t nindirectsyms;
@property(assign, nonatomic) uint32_t extreloff;
@property(assign, nonatomic) uint32_t nextrel;
@property(assign, nonatomic) uint32_t locreloff;
@property(assign, nonatomic) uint32_t nlocrel;

@property(assign, nonatomic) NSMutableArray *descriptions;
@property(assign, nonatomic) NSMutableArray *values;

+ (instancetype)_initWithDataCmd:(uint32_t)cmd
                         cmdsize:(uint32_t)_cmdsize
                       ilocalsym:(uint32_t)_ilocalsym
                       nlocalsym:(uint32_t)_nlocalsym
                      iextdefsym:(uint32_t)_iextdefsym
                      nextdefsym:(uint32_t)_nextdefsym
                       iundefsym:(uint32_t)_iundefsym
                       nundefsym:(uint32_t)_nundefsym
                          tocoff:(uint32_t)_tocoff
                            ntoc:(uint32_t)_ntoc
                       modtaboff:(uint32_t)_modtaboff
                         nmodtab:(uint32_t)_nmodtab
                    extrefsymoff:(uint32_t)_extrefsymoff
                     nextrefsyms:(uint32_t)_nextrefsyms
                  indirectsymoff:(uint32_t)_indirectsymoff
                   nindirectsyms:(uint32_t)_nindirectsyms
                       extreloff:(uint32_t)_extreloff
                         nextrel:(uint32_t)_nextrel
                       locreloff:(uint32_t)_locreloff
                         nlocrel:(uint32_t)_nlocrel;

- (NSMutableArray *)getDetailsFromCursor:(DataCursor *)cursor;

@end

NS_ASSUME_NONNULL_END
