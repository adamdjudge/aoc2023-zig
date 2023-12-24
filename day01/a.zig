const std = @import("std");
const ascii = std.ascii;
const debug = std.debug;
const fs = std.fs;

pub fn main() !void {
    const input = try fs.cwd().openFile("input.txt", .{});
    defer input.close();
    const reader = input.reader();

    var buffer: [80]u8 = undefined;
    var total: i32 = 0;

    while (try reader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        var first: i32 = -1;
        var last: i32 = 0;
        for (line) |ch| {
            if (ascii.isDigit(ch)) {
                if (first == -1)
                    first = ch - '0';
                last = ch - '0';
            }
        }
        total += first * 10 + last;
    }

    debug.print("{d}\n", .{total});
}
