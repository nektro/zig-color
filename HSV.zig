//! object representing a single color in the HSV colorspace with h channel value from 0-360 and s,v channel values from 0-1

const std = @import("std");
const Self = @This();
const _x = @import("./_x.zig");

h: f32, // hue
s: f32, // saturation
v: f32, // value
a: f32, // alpha

pub fn initHSVA(h: f32, s: f32, v: f32, a: f32) Self {
    std.debug.assert(h >= 0.0 and h <= 1.0);
    std.debug.assert(s >= 0.0 and s <= 1.0);
    std.debug.assert(v >= 0.0 and v <= 1.0);
    std.debug.assert(a >= 0.0 and a <= 1.0);
    return Self{
        .h = h,
        .s = s,
        .v = v,
        .a = a,
    };
}

pub fn eql(x: Self, y: Self) bool {
    return x.h == y.h and x.s == y.s and x.v == y.v and x.a == y.a;
}

pub usingnamespace _x.mixin(@This(), f32, .h, .s, .v);
