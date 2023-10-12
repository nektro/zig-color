const std = @import("std");

pub fn mixin(
    comptime T: type,
    comptime f1: std.meta.FieldEnum(T),
    comptime f2: std.meta.FieldEnum(T),
    comptime f3: std.meta.FieldEnum(T),
) type {
    return struct {
        pub fn to_vec(x: T) @Vector(4, f32) {
            return .{
                @floatFromInt(@field(x, @tagName(f1))),
                @floatFromInt(@field(x, @tagName(f2))),
                @floatFromInt(@field(x, @tagName(f3))),
                @floatFromInt(x.a),
            };
        }

        pub fn from_vec(in: @Vector(4, f32)) T {
            var x: T = undefined;
            @field(x, @tagName(f1)) = @intFromFloat(in[0]);
            @field(x, @tagName(f2)) = @intFromFloat(in[1]);
            @field(x, @tagName(f3)) = @intFromFloat(in[2]);
            x.a = @intFromFloat(in[3]);
            return x;
        }
    };
}
