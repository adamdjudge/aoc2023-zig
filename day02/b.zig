const std = @import("std");
const debug = std.debug;
const fmt = std.fmt;
const fs = std.fs;
const mem = std.mem;

pub fn main() !void {
    const input = try fs.cwd().openFile("input.txt", .{});
    defer input.close();
    const reader = input.reader();

    var buffer: [200]u8 = undefined;
    var total: i32 = 0;

    while (try reader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        var tokens = mem.tokenizeAny(u8, line, " :;,");
        _ = tokens.next().?; // Skip "Game"
        const game = try fmt.parseInt(i32, tokens.next().?, 10);

        var max_red: i32 = 0;
        var max_green: i32 = 0;
        var max_blue: i32 = 0;

        while (tokens.next()) |token| {
            const num = try fmt.parseInt(i32, token, 10);
            const color = tokens.next().?;
            switch (color[0]) {
                'r' => max_red = @max(max_red, num),
                'g' => max_green = @max(max_green, num),
                'b' => max_blue = @max(max_blue, num),
                else => unreachable,
            }
        }

        const power = max_red * max_green * max_blue;
        total += power;
        debug.print("Game {d} min: {d} red, {d} green, {d} blue, power {d}\n",
                    .{game, max_red, max_green, max_blue, power});
    }

    debug.print("Total: {d}\n", .{total});
}
