const std = @import("std");
const color = @import("color");

test {
    // https://www.colorhexa.com/4fc3f7
    const o = color.sRGB.parseHexConst("#4FC3F7");
    {
        const r, const g, const b, const a = o.to_array();
        try std.testing.expect(r == 79);
        try std.testing.expect(g == 195);
        try std.testing.expect(b == 247);
        try std.testing.expect(a == 255);
    }
    {
        // 68% cyan, 21.1% magenta, 0% yellow and 3.1% black
        const c, const m, const y, const k, const a = o.to_cmyk().to_array();
        try std.testing.expectApproxEqAbs(0.68, c, 0.01);
        try std.testing.expectApproxEqAbs(0.21, m, 0.01);
        try std.testing.expectApproxEqAbs(0.00, y, 0.01);
        try std.testing.expectApproxEqAbs(0.03, k, 0.01);
        try std.testing.expect(a == 1.0);
    }
    {
        // 198.6°, 91.3, 63.9
        const h, const s, const l, const a = o.to_hsl().to_array();
        try std.testing.expectApproxEqAbs(0.552, h, 0.001);
        try std.testing.expectApproxEqAbs(0.913, s, 0.001);
        try std.testing.expectApproxEqAbs(0.639, l, 0.001);
        try std.testing.expect(a == 1.0);
    }
    {
        // 198.6°, 68, 96.9
        const h, const s, const v, const a = o.to_hsv().to_array();
        try std.testing.expectApproxEqAbs(0.552, h, 0.001);
        try std.testing.expectApproxEqAbs(0.680, s, 0.001);
        try std.testing.expectApproxEqAbs(0.969, v, 0.001);
        try std.testing.expect(a == 1.0);
    }
    {
        // 0.0781874218051863, 0.545724461370187, 0.930110858375424
        const r, const g, const b, const a = o.to_linear_rgb().to_array();
        try std.testing.expectApproxEqAbs(0.078, r, 0.001);
        try std.testing.expectApproxEqAbs(0.545, g, 0.001);
        try std.testing.expectApproxEqAbs(0.930, b, 0.001);
        try std.testing.expect(a == 1.0);
    }
}
