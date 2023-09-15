//! object representing a single color in the sRGB colorspace with channel values from 0-255

const std = @import("std");
const Self = @This();
const color = @import("./mod.zig");

r: u8, // red value
g: u8, // green value
b: u8, // blue value
a: u8, // alpha value

pub fn initRGBA(r: u8, g: u8, b: u8, a: u8) Self {
    return Self{
        .r = r,
        .g = g,
        .b = b,
        .a = a,
    };
}

pub fn initRGB(r: u8, g: u8, b: u8) Self {
    return initRGBA(r, g, b, 255);
}

pub fn parseHexConst(comptime input: *const [7:0]u8) Self {
    comptime std.debug.assert(input[0] == '#');
    return comptime initRGB(
        std.fmt.parseInt(u8, input[1..3], 16) catch unreachable,
        std.fmt.parseInt(u8, input[3..5], 16) catch unreachable,
        std.fmt.parseInt(u8, input[5..7], 16) catch unreachable,
    );
}

pub fn parseHex(input: []const u8) Self {
    std.debug.assert(input.len == 7);
    std.debug.assert(input[0] == '#');
    return initRGB(
        std.fmt.parseInt(u8, input[1..3], 16) catch unreachable,
        std.fmt.parseInt(u8, input[3..5], 16) catch unreachable,
        std.fmt.parseInt(u8, input[5..7], 16) catch unreachable,
    );
}

pub fn eql(x: Self, y: Self) bool {
    return x.r == y.r and x.g == y.g and x.b == y.b;
}

pub fn format(x: Self, comptime fmt: []const u8, options: std.fmt.FormatOptions, writer: anytype) !void {
    _ = fmt;
    _ = options;
    if (x.a < 255) {
        @setCold(true);
        try writer.print("#{:0>2}{:0>2}{:0>2}{:0>2}", .{
            std.fmt.fmtSliceHexLower(&.{x.r}),
            std.fmt.fmtSliceHexLower(&.{x.g}),
            std.fmt.fmtSliceHexLower(&.{x.b}),
            std.fmt.fmtSliceHexLower(&.{x.a}),
        });
        return;
    }
    try writer.print("#{:0>2}{:0>2}{:0>2}", .{
        std.fmt.fmtSliceHexLower(&.{x.r}),
        std.fmt.fmtSliceHexLower(&.{x.g}),
        std.fmt.fmtSliceHexLower(&.{x.b}),
    });
}

pub fn to_linear_rgb(x: Self) color.LinearRgb {
    const lut = comptime blk: {
        var res: [256]f32 = undefined;
        for (0..256) |i| {
            const c = @as(f32, @floatFromInt(i)) / 255.0;
            res[i] = if (c <= 0.04045) c / 12.92 else std.math.pow(f32, (c + 0.055) / 1.055, 2.4);
        }
        break :blk res;
    };
    return color.LinearRgb.initRGBA(
        lut[x.r],
        lut[x.g],
        lut[x.b],
        lut[x.a],
    );
}