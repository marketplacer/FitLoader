// Generated by Apple Swift version 2.1 (swiftlang-700.1.101.6 clang-700.1.76)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if defined(__has_include) && __has_include(<uchar.h>)
# include <uchar.h>
#elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
#endif

typedef struct _NSZone NSZone;

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted) 
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
#endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
#if defined(__has_feature) && __has_feature(modules)
@import UIKit;
@import ObjectiveC;
@import CoreGraphics;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"

@interface UIView (SWIFT_EXTENSION(Dodo))
@end

@class NSLayoutConstraint;
@protocol UILayoutSupport;


/// Adjusts the length (constant value) of the bottom layout constraint when keyboard shows and hides.
SWIFT_CLASS("_TtC4Dodo29UnderKeyboardLayoutConstraint")
@interface UnderKeyboardLayoutConstraint : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;

/// Stop listening for keyboard notifications.
- (void)stop;

/// Supply a bottom Auto Layout constraint. Its constant value will be adjusted by the height of the keyboard when it appears and hides.
///
/// \param bottomLayoutConstraint Supply a bottom layout constraint. Its constant value will be adjusted when keyboard is shown and hidden.
///
/// \param view Supply a view that will be used to animate the constraint. It is usually the superview containing the view with the constraint.
///
/// \param minMargin Specify the minimum margin between the keyboard and the bottom of the view the constraint is attached to. Default: 10.
///
/// \param bottomLayoutGuide Supply an optional bottom layout guide (like a tab bar) that will be taken into account during height calculations.
- (void)setup:(NSLayoutConstraint * __nonnull)bottomLayoutConstraint view:(UIView * __nonnull)view minMargin:(CGFloat)minMargin bottomLayoutGuide:(id <UILayoutSupport> __nullable)bottomLayoutGuide;
@end



/// Detects appearance of software keyboard and calls the supplied closures that can be used for changing the layout and moving view from under the keyboard.
SWIFT_CLASS("_TtC4Dodo21UnderKeyboardObserver")
@interface UnderKeyboardObserver : NSObject

/// Function that will be called before the keyboard is shown and before animation is started.
@property (nonatomic, copy) void (^ __nullable willAnimateKeyboard)(CGFloat);

/// Function that will be called inside the animation block. This can be used to call layoutIfNeeded on the view.
@property (nonatomic, copy) void (^ __nullable animateKeyboard)(CGFloat);
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;

/// Start listening for keyboard notifications.
- (void)start;

/// Stop listening for keyboard notifications.
- (void)stop;
@end

#pragma clang diagnostic pop
