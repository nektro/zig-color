//! object representing a single color in the Linear RGB colorspace with channel values from 0-1

const std = @import("std");
const Self = @This();

r: f32, // red
g: f32, // green
b: f32, // blue
a: f32, // alpha

pub fn initRGBA(r: f32, g: f32, b: f32, a: f32) Self {
    std.debug.assert(r >= 0.0 and r <= 1.0);
    std.debug.assert(g >= 0.0 and g <= 1.0);
    std.debug.assert(b >= 0.0 and b <= 1.0);
    std.debug.assert(a >= 0.0 and a <= 1.0);
    return Self{
        .r = r,
        .g = g,
        .b = b,
        .a = a,
    };
}

pub fn eql(x: Self, y: Self) bool {
    return x.r == y.r and x.g == y.g and x.b == y.b and x.a == y.a;
}

pub fn relative_luminance(x: Self) f32 {
    return (0.2126 * x.r) + (0.7152 * x.g) + (0.0722 * x.b);
}
