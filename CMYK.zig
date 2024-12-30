//! object representing a single color in the CMYK colorspace with channel values from 0-1

const std = @import("std");
const Self = @This();
const color = @import("./mod.zig");

c: f32, // cyan     [ 0 .. 1 ]
m: f32, // magenta  [ 0 .. 1 ]
y: f32, // yellow   [ 0 .. 1 ]
k: f32, // black    [ 0 .. 1 ]
a: f32, // alpha    [ 0 .. 1 ]

pub fn initCMYKA(c: f32, m: f32, y: f32, k: f32, a: f32) Self {
    std.debug.assert(c >= 0.0 and c <= 1.0);
    std.debug.assert(m >= 0.0 and m <= 1.0);
    std.debug.assert(y >= 0.0 and y <= 1.0);
    std.debug.assert(k >= 0.0 and k <= 1.0);
    std.debug.assert(a >= 0.0 and a <= 1.0);
    return Self{
        .c = c,
        .m = m,
        .y = y,
        .k = k,
        .a = a,
    };
}

pub fn eql(x: Self, y: Self) bool {
    return x.c == y.c and x.m == y.m and x.y == y.y and x.k == y.k and x.a == y.a;
}

pub fn to_array(x: Self) [5]f32 {
    return .{
        x.c,
        x.m,
        x.y,
        x.k,
        x.a,
    };
}

// https://www.rapidtables.com/convert/color/cmyk-to-rgb.html
pub fn to_srgb(x: Self) color.sRGB {
    const c, const m, const y, const k, const a = x.to_array();
    const r = (1 - c) * (1 - k);
    const g = (1 - m) * (1 - k);
    const b = (1 - y) * (1 - k);
    return color.sRGB.from_float(.{ r, g, b, a });
}
