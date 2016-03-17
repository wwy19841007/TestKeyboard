//
//  redefinesizet.h
//  TestKeyboard2
//
//  Created by autonavi\wang.weiyang on 4/1/15.
//  Copyright (c) 2015 autonavi\wang.weiyang. All rights reserved.
//


#ifndef _REDEFINE_SIZE_T_
#define _REDEFINE_SIZE_T_
#if defined(__LP64__) && __LP64__
#define size_t unsigned int
#endif
#endif
