//
//  NKArchIndependentRounding.m
//


#import "NKArchIndependentRounding.h"

float __attribute__((overloadable)) nk_floor(float f) { return floorf(f); }
double __attribute__((overloadable)) nk_floor(double d) { return floor(d); }

float __attribute__((overloadable)) nk_ceil(float f) { return ceilf(f); }
double __attribute__((overloadable)) nk_ceil(double d) { return ceil(d); }

float __attribute__((overloadable)) nk_round(float f) { return roundf(f); }
double __attribute__((overloadable)) nk_round(double d) { return round(d); }
