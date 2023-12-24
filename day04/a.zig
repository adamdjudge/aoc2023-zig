const std = @import("std");
const debug = std.debug;
const fmt = std.fmt;
const fs = std.fs;
const heap = std.heap;
const mem = std.mem;

pub fn main() !void {
    var gpa = heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const input = try fs.cwd().openFile("input.txt", .{});
    defer input.close();
    const reader = input.reader();

    var buffer: [200]u8 = undefined;
    var total: i32 = 0;
    
    while (try reader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        var tokens = mem.tokenizeAny(u8, line, " :");
        _ = tokens.next().?; // Skip "Card"
        const card = try fmt.parseInt(i32, tokens.next().?, 10);

        var wins = std.ArrayList(i32).init(allocator);
        defer wins.deinit();

        while (tokens.next()) |token| {
            if (token[0] == '|')
                break;
            try wins.append(try fmt.parseInt(i32, token, 10));
        }

        var value: i32 = 0;
        while (tokens.next()) |token| {
            const num = try fmt.parseInt(i32, token, 10);
            if (mem.count(i32, wins.items, &.{num}) > 0)
                value = if (value == 0) 1 else value * 2;
        }

        total += value;
        debug.print("Card {d} value: {d}\n", .{card, value});
    }

    debug.print("Total: {d}\n", .{total});
}
