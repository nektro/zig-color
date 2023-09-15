//! object representing a single color in the HSL colorspace with h channel value from 0-360 and s,l channel values from 0-1

const std = @import("std");
const Self = @This();

h: f32, // hue
s: f32, // saturation
l: f32, // luminance
a: f32, // alpha

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
