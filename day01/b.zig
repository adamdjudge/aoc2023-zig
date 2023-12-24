const std = @import("std");
const ascii = std.ascii;
const debug = std.debug;
const fs = std.fs;
const mem = std.mem;

const digits = [_][]const u8 {
    "zero", "one", "two", "three", "four",
    "five", "six", "seven", "eight", "nine"
};

fn parseDigit(s: []u8) ?i32 {
    if (ascii.isDigit(s[0]))
        return s[0] - '0';

    for (digits, 0..) |digit, i| {
        if (mem.startsWith(u8, s, digit))
            return @intCast(i32, i);
    }

    return null;
}

pub fn main() !void {
    const input = try fs.cwd().openFile("input.txt", .{});
    defer input.close();
    const reader = input.reader();

    var buffer: [80]u8 = undefined;
    var total: i32 = 0;

    while (try reader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        var first: i32 = -1;
        var last: i32 = 0;
        for (0..line.len) |i| {
            if (parseDigit(line[i..])) |digit| {
                if (first == -1)
                    first = digit;
                last = digit;
            }
        }
        total += first * 10 + last;
    }

    debug.print("{d}\n", .{total});
}
