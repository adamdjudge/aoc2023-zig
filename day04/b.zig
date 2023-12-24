const std = @import("std");
const debug = std.debug;
const fmt = std.fmt;
const fs = std.fs;
const heap = std.heap;
const mem = std.mem;

const Card = struct {
    matches: usize,
    multiplier: usize = 1,
};

pub fn main() !void {
    var gpa = heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const input = try fs.cwd().openFile("input.txt", .{});
    defer input.close();
    const reader = input.reader();

    var buffer: [200]u8 = undefined;
    var cards = std.ArrayList(Card).init(allocator);
    defer cards.deinit();
    
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

        var matches: usize = 0;
        while (tokens.next()) |token| {
            const num = try fmt.parseInt(i32, token, 10);
            if (mem.count(i32, wins.items, &.{num}) > 0)
                matches += 1;
        }

        try cards.append(.{ .matches = matches });
        debug.print("Card {d} matches: {d}\n", .{card, matches});
    }

    for (cards.items, 0..) |card, i| {
        if (card.matches == 0)
            continue;
        for (i+1..i+card.matches+1) |j| {
            if (j >= cards.items.len)
                break;
            cards.items[j].multiplier += card.multiplier;
        }
    }

    var total: usize = 0;
    for (cards.items) |card| {
        total += card.multiplier;
    }

    debug.print("Total: {d}\n", .{total});
}
