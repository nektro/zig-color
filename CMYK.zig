//! object representing a single color in the CMYK colorspace with channel values from 0-1

const std = @import("std");
const Self = @This();

c: f32, // cyan
m: f32, // magenta
y: f32, // yellow
k: f32, // black
a: f32, // alpha

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
