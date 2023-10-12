//! object representing a single color in the YCbCr colorspace with channel values from 0-255

const std = @import("std");
const Self = @This();
const color = @import("./mod.zig");
const _x = @import("./_x.zig");

y: u8,
cb: u8,
cr: u8,
a: u8,

pub fn initYCbCrA(y: u8, cb: u8, cr: u8, a: u8) Self {
    return Self{
        .y = y,
        .cb = cb,
        .cr = cr,
        .a = a,
    };
}

pub fn initYCbCr(y: u8, cb: u8, cr: u8) Self {
    return initYCbCrA(y, cb, cr, 255);
}

pub fn eql(x: Self, y: Self) bool {
    return x.y == y.y and x.cb == y.cb and x.cr == y.cr and x.a == y.a;
}

pub usingnamespace _x.mixin(@This(), .y, .cb, .cr);

pub fn to_srgb(x: Self) color.sRGB {
    // zig fmt: off
    const f = x.to_vec();
    return color.sRGB.from_vec(.{
        @max(0, @min(255, f[0]                        + 1.402   * (f[2]-128))),
        @max(0, @min(255, f[0] - 0.34414 * (f[1]-128) - 0.71414 * (f[2]-128))),
        @max(0, @min(255, f[0] + 1.772   * (f[1]-128))),
        @max(0, @min(255, f[3])),
    });
    // zig fmt: on
}
