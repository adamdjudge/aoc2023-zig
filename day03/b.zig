const std = @import("std");
const ascii = std.ascii;
const debug = std.debug;
const fs = std.fs;
const heap = std.heap;

const Coordinate = struct {
    row: usize,
    col: usize,
};

const PartNumber = struct {
    num: i32,
    coord: Coordinate,
    length: usize,

    fn isAdjacentTo(self: PartNumber, point: Coordinate) bool {
        return point.row >= self.coord.row-1
               and point.row <= self.coord.row+1
               and point.col >= self.coord.col-1
               and point.col <= self.coord.col+self.length;
    }
};

pub fn main() !void {
    var gpa = heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var part_numbers = std.ArrayList(PartNumber).init(allocator);
    defer part_numbers.deinit();
    var gears = std.ArrayList(Coordinate).init(allocator);
    defer gears.deinit();

    const input = try fs.cwd().openFile("input.txt", .{});
    defer input.close();
    const reader = input.reader();

    var buffer: [200]u8 = undefined;
    var row: usize = 1;
    var current = PartNumber{
        .num = 0,
        .coord = .{ .row = 0, .col = 0 },
        .length = 0,
    };

    while (try reader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        for (line, 1..) |ch, col| {
            if (ascii.isDigit(ch)) {
                if (current.num == 0)
                    current.coord = .{ .row = row, .col = col };
                current.num = current.num * 10 + (ch - '0');
                current.length += 1;
            } else if (ch == '*')
                try gears.append(.{ .row = row, .col = col });

            if ((!ascii.isDigit(ch) or col == line.len) and current.num != 0) {
                try part_numbers.append(current);
                current.num = 0;
                current.length = 0;
            }
        }

        row += 1;
    }

    var total: i32 = 0;
    for (gears.items) |gear| {
        var ratio: i32 = 1;
        var count: i32 = 0;
        
        for (part_numbers.items) |part| {
            if (part.isAdjacentTo(gear)) {
                ratio *= part.num;
                count += 1;
            }
        }

        if (count == 2)
            total += ratio;
    }

    debug.print("{d}\n", .{total});
}
