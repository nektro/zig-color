//! object representing a single color in the YCbCr colorspace with channel values from 0-255

const std = @import("std");
const Self = @This();
const color = @import("./mod.zig");

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
