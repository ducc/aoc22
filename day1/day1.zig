const std = @import("std");
const debug = std.debug;
const fmt = std.fmt;
const heap = std.heap;
const fs = std.fs;

pub fn main() !void {
    // Setup allocator
    var arena_state = heap.ArenaAllocator.init(std.heap.c_allocator);
    defer arena_state.deinit();

    const allocator = arena_state.allocator();

    // Open input.txt
    var file = try fs.cwd().openFile("input.txt", .{});
    defer file.close();

    // Get a reader for the file
    var in_stream = file.reader();

    // Create a list to store calorie counts per elf
    var calorie_counts = std.ArrayList(u32).init(allocator);
    defer calorie_counts.deinit();

    // Buffer to read the file into
    var buf: [1024]u8 = undefined;

    var calories: u32 = 0;

    // Read each line of the file until the end.
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (line.len == 0) {
            // If the line is empty then we have read all the calories for the current elf.
            // Add the total calorie count for this elf into the list.
            try calorie_counts.append(calories);
            calories = 0;
            continue;
        } else {
            // The elf is carrying more calories, so parse the line as a number
            // and append it to the running count for this elf.
            calories += try fmt.parseUnsigned(u32, line, 10);
        }
    }

    try calorie_counts.append(calories);

    var items = calorie_counts.items;

    // Sort array in place
    std.sort.insertionSort(u32, calorie_counts.items, {}, compareDesc);

    debug.print("1: {d}\n2: {d}\n3: {d}\ntotal: {d}\n", .{items[0], items[1], items[2], items[0] + items[1] + items[2]});
}

fn compareDesc(context: void, a: u32, b: u32) bool {
    return std.sort.desc(u32)(context, a, b);
}
