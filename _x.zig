const std = @import("std");

pub fn mixin(
    comptime T: type,
    comptime I: type,
    comptime f1: std.meta.FieldEnum(T),
    comptime f2: std.meta.FieldEnum(T),
    comptime f3: std.meta.FieldEnum(T),
) type {
    return struct {
        pub fn to_vec(x: T) @Vector(4, f32) {
            if (I == f32) {
                return x.to_array();
            }
            return .{
                @floatFromInt(@field(x, @tagName(f1))),
                @floatFromInt(@field(x, @tagName(f2))),
                @floatFromInt(@field(x, @tagName(f3))),
                @floatFromInt(x.a),
            };
        }

        pub fn from_vec(in: @Vector(4, f32)) T {
            if (I == f32) {
                var x: T = undefined;
                @field(x, @tagName(f1)) = in[0];
                @field(x, @tagName(f2)) = in[1];
                @field(x, @tagName(f3)) = in[2];
                x.a = in[3];
                return x;
            }
            var x: T = undefined;
            @field(x, @tagName(f1)) = @intFromFloat(in[0]);
            @field(x, @tagName(f2)) = @intFromFloat(in[1]);
            @field(x, @tagName(f3)) = @intFromFloat(in[2]);
            x.a = @intFromFloat(in[3]);
            return x;
        }

        pub fn to_array(x: T) [4]I {
            return .{
                @field(x, @tagName(f1)),
                @field(x, @tagName(f2)),
                @field(x, @tagName(f3)),
                x.a,
            };
        }
    };
}
