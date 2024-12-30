const std = @import("std");
const Self = @This();
const color = @import("./mod.zig");
const _x = @import("./_x.zig");
const vec4 = @Vector(4, f32);

y: f32, // [ 0 .. 1 ]
u: f32, // [ -0.436 .. +0.436 ]
v: f32, // [ -0.615 .. +0.615 ]
a: f32, // [ 0 .. 1 ]

pub fn initYUVA(y: f32, u: f32, v: f32, a: f32) Self {
    return Self{
        .y = y,
        .u = u,
        .v = v,
        .a = a,
    };
}

pub fn initYUV(y: f32, u: f32, v: f32) Self {
    return initYUVA(y, u, v, 255);
}

pub fn eql(x: Self, y: Self) bool {
    return x.y == y.y and x.u == y.u and x.v == y.v and x.a == y.a;
}

pub usingnamespace _x.mixin(@This(), f32, .y, .u, .v);

// https://web.archive.org/web/20180423091842/http://www.equasys.de/colorconversion.html
pub fn to_srgb(x: Self) color.sRGB {
    // zig fmt: off
    const y, const u, const v, const a = x.to_array();
    const r = y * 1.000 + u *  0.000 + v *  1.140;
    const g = y * 1.000 + u * -0.395 + v * -0.581;
    const b = y * 1.000 + u *  2.032 + v *  0.000;
    return color.sRGB.from_float(.{ r, g, b, a });
    // zig fmt: on
}

pub fn normal(x: Self) vec4 {
    const v: vec4 = x.to_array();
    return v * @as(vec4, .{ 255, 255, 255, 1 });
}
