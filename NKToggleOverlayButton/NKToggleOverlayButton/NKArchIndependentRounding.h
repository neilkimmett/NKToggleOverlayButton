//
//  NKArchIndependentRounding.h
//

/*
 * CREDIT TO SIMON WHITAKER: https://gist.github.com/simonwhitaker/8213159
 *
 * Calling math.h functions like `floor` and `floorf` on CGFloat variables
 * becomes problematic when compiling the same code for both 32-bit and
 * 64-bit platforms, since CGFloat is double on 64-bit, float on 32-bit.
 * Hence, if you compile with -Wconversion set, `floorf` will give a warning
 * on 64-bit, while `floor` gives a warning on 32-bit.
 *
 * Here's a suggested implementation of an architecture-independent `floor`
 * function, written using plain old function overloading which is enabled
 * using the `__attribute__((overloadable))` Clang language extension.
 *
 * See http://clang.llvm.org/docs/LanguageExtensions.html#function-overloading-in-c
 */

float __attribute__((overloadable)) nk_floor(float f);
double __attribute__((overloadable)) nk_floor(double d);

float __attribute__((overloadable)) nk_ceil(float f);
double __attribute__((overloadable)) nk_ceil(double d);

float __attribute__((overloadable)) nk_round(float f);
double __attribute__((overloadable)) nk_round(double d);
