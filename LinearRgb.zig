//! object representing a single color in the Linear RGB colorspace with channel values from 0-1

const std = @import("std");
const Self = @This();
const color = @import("./mod.zig");
const _x = @import("./_x.zig");
const vec4 = @Vector(4, f32);

r: f32, // red    [ 0 .. 1]
g: f32, // green  [ 0 .. 1]
b: f32, // blue   [ 0 .. 1]
a: f32, // alpha  [ 0 .. 1]

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

// https://www.w3.org/TR/WCAG/#dfn-relative-luminance
pub fn relative_luminance(x: Self) f32 {
    const r, const g, const b, _ = x.to_array();
    return (0.2126 * r) + (0.7152 * g) + (0.0722 * b);
}

pub usingnamespace _x.mixin(@This(), f32, .r, .g, .b);

// https://gamedev.stackexchange.com/a/194038
pub fn to_srgb(x: Self) color.sRGB {
    const v = x.to_vec();
    const cutoff = v < @as(vec4, @splat(0.0031308));
    const higher = @as(vec4, @splat(1.055)) * std.math.pow(vec4, v, @splat(1.0 / 2.4)) - @as(vec4, @splat(0.055));
    const lower = v * @as(vec4, @splat(12.92));
    return color.sRGB.from_float(@select(f32, cutoff, higher, lower));
}
