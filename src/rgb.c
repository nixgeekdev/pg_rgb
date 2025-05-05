#include "postgres.h"
#include "fmgr.h"
#include "access/gist.h"
#include "access/hash.h"
#include "access/skey.h"
#include "libpq/pqformat.h"
#include "utils/float.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>
#include <ctype.h>
#include <math.h>

PG_MODULE_MAGIC;

#define USE_ASSERT_CHECKING

#define HEX_DIGITS "0123456789ABCDEF"
#define RGB_BASE (int)16
#define RGB_MAX_VALUE 255
#define RGB_MIN_VALUE 0
#define RGB_STR_LEN 7
#define RGB_MATCHED 3
#define RGB_HASH '#'

typedef struct RGB {
    int32 red;
    int32 green;
    int32 blue;
} RGB;

static uint32_t hash_color(const RGB *rgb);
static bool in_range(int32_t x);
static uint32_t compare_color(const RGB *a, const RGB *b);

Datum to_rgb(PG_FUNCTION_ARGS);
Datum hash_rgb(PG_FUNCTION_ARGS);

Datum rgb_in(PG_FUNCTION_ARGS);
Datum rgb_out(PG_FUNCTION_ARGS);

Datum rgb_cmp(PG_FUNCTION_ARGS);
Datum rgb_eq(PG_FUNCTION_ARGS);
Datum rgb_lt(PG_FUNCTION_ARGS);
Datum rgb_le(PG_FUNCTION_ARGS);
Datum rgb_ge(PG_FUNCTION_ARGS);
Datum rgb_gt(PG_FUNCTION_ARGS);

/**
 * Function to hash an RGB struct.
 * This function compactly encodes the RGB struct into a 24-bit integer
 * (packed into a uint32_t).
 * @param rgb Pointer to the RGB struct.
 */
static uint32_t
hash_color(const RGB *rgb)
{
    return ((uint32_t)rgb->red << 16) |
           ((uint32_t)rgb->green << 8) |
           ((uint32_t)rgb->blue);
}

/**
 * Function to check if an integer is within the valid RGB range.
 * @param x The integer to check.
 */
static bool
in_range(int32_t x) {
    return ((x - RGB_MAX_VALUE) * (x - RGB_MIN_VALUE) <= 0);
}

/**
 * Function to compare two RGB colors.
 * This function provides a total order consistent with equality and hash_color().
 * @param a Pointer to the first RGB color.
 * @param b Pointer to the second RGB color.
 */
static uint32_t
compare_color(const RGB *a, const RGB *b)
{
    uint32_t result = 0;
    if (a->red != b->red) {
        result = a->red < b->red ? -1 : 1;
    }
    if (a->green != b->green) {
        result = a->green < b->green ? -1 : 1;
    }
    if (a->blue != b->blue) {
        result = a->blue < b->blue ? -1 : 1;
    }
    return result;
}

PG_FUNCTION_INFO_V1(to_rgb);
/**
 * Function to convert RGB values to an RGB struct.
 * This function is used when RGB values are passed as separate arguments.
 */
Datum
to_rgb(PG_FUNCTION_ARGS)
{
    int32 r = (int32)PG_GETARG_INT32(0);
    int32 g = (int32)PG_GETARG_INT32(1);
    int32 b = (int32)PG_GETARG_INT32(2);

    RGB *rgb = (RGB *)palloc(sizeof(RGB));
    rgb->red = r;
    rgb->green = g;
    rgb->blue = b;

    PG_RETURN_POINTER(rgb);
};

PG_FUNCTION_INFO_V1(hash_rgb);
/**
 * Function to hash an RGB struct.
 * This function combines the RGB values into a single integer and hashes it
 * so the '=' function can be 'hashes' for performance.
 */
Datum
hash_rgb(PG_FUNCTION_ARGS)
{
    RGB *rgb = (RGB *)PG_GETARG_POINTER(0);
    uint32 raw = hash_color(rgb);
    uint32 hash = hash_uint32(raw);
    PG_RETURN_UINT32(hash);
};

PG_FUNCTION_INFO_V1(rgb_in);
/**
 * RGB type input function
 * This function takes a string input and converts it into an RGB struct.
 * converts data from the type's external textual form to its internal form
 */
Datum
rgb_in(PG_FUNCTION_ARGS)
{
    char *str = PG_GETARG_CSTRING(0);
    RGB *rgb = (RGB *) palloc(sizeof(RGB));

    if (str[0] == RGB_HASH && strlen(str) == RGB_STR_LEN) {
        if (sscanf(str + 1, "%02x%02x%02x", &rgb->red, &rgb->green, &rgb->blue) != RGB_MATCHED) {
            ereport(ERROR,
                    (errcode(ERRCODE_INVALID_TEXT_REPRESENTATION),
                     errmsg("Invalid input syntax for type rgb: \"%s\"", str)));
        } else {
            if (!in_range(rgb->red) || !in_range(rgb->green) || !in_range(rgb->blue)) {
                ereport(ERROR, (errmsg("Invalid hexadecimal RGB value: \"%s\"", str)));
            }
        }
    } else {
        if (sscanf(str, " %d , %d , %d", &rgb->red, &rgb->green, &rgb->blue) != RGB_MATCHED) {
            ereport(ERROR,
                    (errcode(ERRCODE_INVALID_TEXT_REPRESENTATION),
                     errmsg("Invalid input syntax for type rgb: \"%s\"", str)));
        } else {
            if (!in_range(rgb->red) || !in_range(rgb->green) || !in_range(rgb->blue)) {
                ereport(ERROR, (errmsg("RGB values must be >= 0 and <= 255")));
            }
        }
    }

    PG_RETURN_POINTER(rgb);
};

PG_FUNCTION_INFO_V1(rgb_out);
/**
 * RGB type output function
 * This function takes an RGB struct and converts it into a string representation.
 * converts data from the type's internal form to its external textual form.
 */
Datum
rgb_out(PG_FUNCTION_ARGS)
{
    RGB *rgb = (RGB *) PG_GETARG_POINTER(0);
    char *result = (char *) palloc(RGB_STR_LEN + 1);
    snprintf(result, sizeof(result), "#%02X%02X%02X", rgb->red, rgb->green, rgb->blue);
    PG_RETURN_CSTRING(result);
};

PG_FUNCTION_INFO_V1(rgb_cmp);
/**
 * RGB type comparison function
 *
 * This function compares two RGB structs and returns an integer indicating their order.
 * This provides a stable, total order consistent with equality and hash_color().
 */
Datum
rgb_cmp(PG_FUNCTION_ARGS)
{
    RGB *a = (RGB *)PG_GETARG_POINTER(0);
    RGB *b = (RGB *)PG_GETARG_POINTER(1);
    PG_RETURN_INT32(compare_color(a, b));
}

PG_FUNCTION_INFO_V1(rgb_eq);
/**
 * RGB type equality function
 * This should match the comparison logic hash_rgb
 */
Datum
rgb_eq(PG_FUNCTION_ARGS)
{
    RGB *a = (RGB *)PG_GETARG_POINTER(0);
    RGB *b = (RGB *)PG_GETARG_POINTER(1);
    bool result = (a->red == b->red) &&
                  (a->green == b->green) &&
                  (a->blue == b->blue);

#ifdef USE_ASSERT_CHECKING
    if (result) {
        Assert(hash_color(a) == hash_color(b));
    }
#endif

    PG_RETURN_BOOL(result);
}

PG_FUNCTION_INFO_V1(rgb_lt);
/**
 * RGB type less than or equal function
 */
Datum
rgb_lt(PG_FUNCTION_ARGS)
{
    RGB *a = (RGB *)PG_GETARG_POINTER(0);
    RGB *b = (RGB *)PG_GETARG_POINTER(1);
    PG_RETURN_BOOL(compare_color(a, b) < 0);
}

PG_FUNCTION_INFO_V1(rgb_le);
/**
 * RGB type less than function
 */
Datum
rgb_le(PG_FUNCTION_ARGS)
{
    RGB *a = (RGB *)PG_GETARG_POINTER(0);
    RGB *b = (RGB *)PG_GETARG_POINTER(1);
    PG_RETURN_BOOL(compare_color(a, b) <= 0);
}

PG_FUNCTION_INFO_V1(rgb_gt);
/**
 * RGB type greater than function
 */
Datum
rgb_gt(PG_FUNCTION_ARGS)
{
    RGB *a = (RGB *)PG_GETARG_POINTER(0);
    RGB *b = (RGB *)PG_GETARG_POINTER(1);
    PG_RETURN_BOOL(compare_color(a, b) > 0);
}

PG_FUNCTION_INFO_V1(rgb_ge);
/**
 * RGB type greater or equal than function
 */
Datum
rgb_ge(PG_FUNCTION_ARGS)
{
    RGB *a = (RGB *)PG_GETARG_POINTER(0);
    RGB *b = (RGB *)PG_GETARG_POINTER(1);
    PG_RETURN_BOOL(compare_color(a, b) >= 0);
}
