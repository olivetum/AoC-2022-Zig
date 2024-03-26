//  #zig AoC Ideas
//  Use mem.eql to compare....
//  How to get char in line.items????
//  asd
//  ad

const std = @import("std");
const fs = std.fs;
const print = std.debug.print;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const file = try fs.cwd().openFile("./1_input", .{});
    defer file.close();

    // Wrap the file reader in a buffered reader.
    // Since it's usually faster to read a bunch of bytes at once.
    var buf_reader = std.io.bufferedReader(file.reader());
    const reader = buf_reader.reader();

    var line = std.ArrayList(u8).init(allocator);
    defer line.deinit();

    var all_elves = std.ArrayList(i32).init(allocator);
    defer all_elves.deinit();
    var current_elf: i32 = 0;

    const writer = line.writer();
    var line_no: usize = 1;
    while (reader.streamUntilDelimiter(writer, '\n', null)) : (line_no += 1) {
        // Clear the line so we can reuse it.
        defer line.clearRetainingCapacity();

        // TODO: check if last item in a line (line.items) is a '\n' - use for loop
        if (!std.mem.eql(u8, line.items, "")) {
            const line_count = try std.fmt.parseInt(i32, line.items, 10);
            current_elf += line_count;
            // print("{d}--{s}\n", .{ line_no, line.items });
        } else {
            // std.debug.print("Empty line: test_number = {d}\n", .{current_elf});
            try all_elves.append(current_elf);
            current_elf = 0;
        }
    } else |err| switch (err) {
        error.EndOfStream => {
            try all_elves.append(current_elf);
        }, // Continue on
        else => return err, // Propagate error
    }

    const sorted = std.mem.sort(i32, all_elves.items, {}, comptime std.sort.desc(i32));
    _ = sorted;
    var top_three: i32 = 0;

    var counter: u8 = 0;
    while (counter < 3) : (counter += 1) {
        top_three += all_elves.items[counter];
    }
    std.debug.print("Top three = {d}\n", .{top_three});
}
