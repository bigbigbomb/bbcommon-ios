#import <Foundation/Foundation.h>

#ifndef NS_BLOCK_ASSERTIONS
#define DAssert(...) NSAssert(__VA_ARGS__)
#else
#define DAssert(...)
#endif

#define KVO_SET(_key_, _value_) [self willChangeValueForKey:@#_key_]; \
self._key_ = (_value_); \
[self didChangeValueForKey:@#_key_];

id objc_getProperty(id self, SEL _cmd, ptrdiff_t offset, BOOL atomic);
void objc_setProperty(id self, SEL _cmd, ptrdiff_t offset, id newValue, BOOL atomic,
    BOOL shouldCopy);
void objc_copyStruct(void *dest, const void *src, ptrdiff_t size, BOOL atomic,
    BOOL hasStrong);

#define AtomicRetainedSetToFrom(dest, source) \
    objc_setProperty(self, _cmd, (ptrdiff_t)(&dest) - (ptrdiff_t)(self), source, YES, NO)
#define AtomicCopiedSetToFrom(dest, source) \
    objc_setProperty(self, _cmd, (ptrdiff_t)(&dest) - (ptrdiff_t)(self), source, YES, YES)
#define AtomicAutoreleasedGet(source) \
    objc_getProperty(self, _cmd, (ptrdiff_t)(&source) - (ptrdiff_t)(self), YES)
#define AtomicStructToFrom(dest, source) \
    objc_copyStruct(&dest, &source, sizeof(__typeof__(source)), YES, NO)
#define NonatomicRetainedSetToFrom(a, b) do{if(a!=b){[a release];a=[b retain];}}while(0)
#define NonatomicCopySetToFrom(a, b) do{if(a!=b){[a release];a=[b copy];}}while(0)

#ifdef CONFIGURATION_Debug
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define CGRectDescription(CGRECT) [NSString stringWithFormat:@"x:%f y:%f w:%f h:%f", CGRECT.origin.x, CGRECT.origin.y, CGRECT.size.width, CGRECT.size.height]

#define BBRnd ((arc4random()%256) / 255.0f)

#define BBRndInt(low, high) ((int)low + arc4random() % (high - low + 1))
