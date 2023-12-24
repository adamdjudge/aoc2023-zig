const std = @import("std");
const debug = std.debug;
const fmt = std.fmt;
const fs = std.fs;
const mem = std.mem;

const NUM_RED: i32 = 12;
const NUM_GREEN: i32 = 13;
const NUM_BLUE: i32 = 14;

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

        while (tokens.next()) |token| {
            const num = try fmt.parseInt(i32, token, 10);
            const color = tokens.next().?;
            switch (color[0]) {
                'r' => if (num > NUM_RED) break,
                'g' => if (num > NUM_GREEN) break,
                'b' => if (num > NUM_BLUE) break,
                else => unreachable,
            }
        } else {
            debug.print("Game {d} is possible\n", .{game});
            total += game;
        }
    }

    debug.print("Total: {d}\n", .{total});
}
