//! object representing a single color in the sRGB colorspace with channel values from 0-255

const std = @import("std");
const Self = @This();
const color = @import("./mod.zig");
const _x = @import("./_x.zig");

r: u8, // red value
g: u8, // green value
b: u8, // blue value
a: u8, // alpha value

pub const Float = struct {
    r: f32,
    g: f32,
    b: f32,
    a: f32,
};

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
    return x.r == y.r and x.g == y.g and x.b == y.b and x.a == y.a;
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

pub usingnamespace _x.mixin(@This(), u8, .r, .g, .b);

// https://www.w3.org/TR/WCAG/#dfn-relative-luminance
// https://webstore.iec.ch/publication/6169
pub fn to_linear_rgb(x: Self) color.LinearRgb {
    const lut = comptime blk: {
        @setEvalBranchQuota(10_000);
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

pub fn to_float(x: Self) Float {
    return .{
        .r = @as(f32, @floatFromInt(x.r)) / 255.0,
        .g = @as(f32, @floatFromInt(x.g)) / 255.0,
        .b = @as(f32, @floatFromInt(x.b)) / 255.0,
        .a = @as(f32, @floatFromInt(x.a)) / 255.0,
    };
}

pub fn from_float(y: @Vector(4, f32)) Self {
    const r, const g, const b, const a = y * @as(@Vector(4, f32), @splat(255.0));
    return .{
        .r = @intFromFloat(r),
        .g = @intFromFloat(g),
        .b = @intFromFloat(b),
        .a = @intFromFloat(a),
    };
}

// https://www.rapidtables.com/convert/color/rgb-to-cmyk.html
pub fn to_cmyk(x: Self) color.CMYK {
    const f = x.to_float();
    const k = 1 - @max(f.r, f.g, f.b);
    const c = (1 - f.r - k) / (1 - k);
    const m = (1 - f.g - k) / (1 - k);
    const y = (1 - f.b - k) / (1 - k);
    const a = f.a;
    return color.CMYK.initCMYKA(c, m, y, k, a);
}

// https://www.rapidtables.com/convert/color/rgb-to-hsl.html
pub fn to_hsl(x: Self) color.HSL {
    const f = x.to_float();
    const cmax = @max(f.r, f.g, f.b);
    const cmin = @min(f.r, f.g, f.b);
    const delta = cmax - cmin;
    const h = blk: {
        if (delta == 0) break :blk 0;
        if (cmax == f.r) break :blk @rem(((f.g - f.b) / delta), 6.0) / 6.0;
        if (cmax == f.g) break :blk (((f.b - f.r) / delta) + 2) / 6.0;
        if (cmax == f.b) break :blk (((f.r - f.g) / delta) + 4) / 6.0;
        unreachable;
    };
    const l = (cmax + cmin) / 2;
    const s = if (delta == 0) 0 else delta / (1 - @abs(2 * l - 1));
    const a = f.a;
    return color.HSL.initHSLA(h, s, l, a);
}

// https://www.rapidtables.com/convert/color/rgb-to-hsv.html
pub fn to_hsv(x: Self) color.HSV {
    const f = x.to_float();
    const cmax = @max(f.r, f.g, f.b);
    const cmin = @min(f.r, f.g, f.b);
    const delta = cmax - cmin;
    const h = blk: {
        if (delta == 0) break :blk 0;
        if (cmax == f.r) break :blk (@rem(((f.g - f.b) / delta), 6.0) / 6.0);
        if (cmax == f.g) break :blk ((((f.b - f.r) / delta) + 2) / 6.0);
        if (cmax == f.b) break :blk ((((f.r - f.g) / delta) + 4) / 6.0);
        unreachable;
    };
    const s = if (cmax == 0) 0 else delta / cmax;
    const v = cmax;
    const a = f.a;
    return color.HSV.initHSVA(h, s, v, a);
}

pub fn to_ycbcr(x: Self) color.YCbCr {
    // zig fmt: off
    const r, const g, const b, const a  = x.to_vec();
    return color.YCbCr.from_vec(.{
        ( 0.299  * r +  0.587  * g +  0.114  * b) + 0,
        (-0.1687 * r + -0.3313 * g +  0.5    * b) + 128,
        ( 0.5    * r + -0.4187 * g + -0.0813 * b) + 128,
        a,
    });
    // zig fmt: on
}
