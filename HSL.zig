//! object representing a single color in the HSL colorspace with h channel value from 0-360 and s,l channel values from 0-1

const std = @import("std");
const Self = @This();
const color = @import("./mod.zig");
const _x = @import("./_x.zig");

h: f32, // hue         [ 0 .. 1 ]
s: f32, // saturation  [ 0 .. 1 ]
l: f32, // luminance   [ 0 .. 1 ]
a: f32, // alpha       [ 0 .. 1 ]

pub fn initHSLA(h: f32, s: f32, l: f32, a: f32) Self {
    std.debug.assert(h >= 0.0 and h <= 1.0);
    std.debug.assert(s >= 0.0 and s <= 1.0);
    std.debug.assert(l >= 0.0 and l <= 1.0);
    std.debug.assert(a >= 0.0 and a <= 1.0);
    return Self{
        .h = h,
        .s = s,
        .l = l,
        .a = a,
    };
}

pub fn eql(x: Self, y: Self) bool {
    return x.h == y.h and x.s == y.s and x.l == y.l and x.a == y.a;
}

pub usingnamespace _x.mixin(@This(), f32, .h, .s, .l);

// https://en.wikipedia.org/wiki/HSL_and_HSV#HSL_to_RGB
// https://www.rapidtables.com/convert/color/hsl-to-rgb.html
pub fn to_srgb(t: Self) color.sRGB {
    var h, const s, const l, const a = t.to_array();
    h *= 360.0;
    h /= 60.0;
    const c = (1.0 - @abs(2 * l - 1.0)) * s;
    const x = c * (1 - @abs(@rem(h, 2.0) - 1.0));
    const r, const g, const b = blk: {
        if (h >= 0.0 and h < 1.0) break :blk .{ c, x, 0 };
        if (h >= 1.0 and h < 2.0) break :blk .{ x, c, 0 };
        if (h >= 2.0 and h < 3.0) break :blk .{ 0, c, x };
        if (h >= 3.0 and h < 4.0) break :blk .{ 0, x, c };
        if (h >= 4.0 and h < 5.0) break :blk .{ x, 0, c };
        if (h >= 5.0 and h < 6.0) break :blk .{ c, 0, x };
        unreachable;
    };
    const m = l - c / 2.0;
    return color.sRGB.from_float(.{ r + m, g + m, b + m, a });
}
