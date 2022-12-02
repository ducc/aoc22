const std = @import("std");
const debug = std.debug;
const fs = std.fs;

const Error = error {
    InvalidShape,
};

const Shape = enum {
    rock,
    paper,
    scissors,
};

fn shapeFromChar(c: u8) !Shape {
    if (c == 'A' or c == 'X') {
        return Shape.rock;
    }

    if (c == 'B' or c == 'Y') {
        return Shape.paper;
    }

    if (c == 'C' or c == 'Z') {
        return Shape.scissors;
    }

    return Error.InvalidShape;
}

fn getShapeScore(shape: Shape) u8 {
    return switch (shape) {
        Shape.rock => 1,
        Shape.paper => 2,
        Shape.scissors => 3,
    };
}

fn getRoundScore(opponent: Shape, us: Shape) u8 {
    if (opponent == us) {
        return 3;
    }

    var win = false;

    switch (opponent) {
        Shape.rock => {
            if (us == Shape.paper) {
                win = true;
            }
        },
        Shape.paper => {
            if (us == Shape.scissors) {
                win = true;
            }
        },
        Shape.scissors => {
            if (us == Shape.rock) {
                win = true;
            }
        }
    }

    if (win) {
        return 6;
    }

    return 0;
}

pub fn main() !void {
    var file = try fs.cwd().openFile("input.txt", .{});
    defer file.close();

    var inStream = file.reader();

    var buf: [1024]u8 = undefined;
    var sum: u16 = 0;

    while (try inStream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var opponentShape = try shapeFromChar(line[0]);
        var ourShape = try shapeFromChar(line[2]);

        var shapeScore = getShapeScore(ourShape);
        var roundScore = getRoundScore(opponentShape, ourShape);

        sum += shapeScore + roundScore;

        debug.print("{c} + {c} -> {} \n", .{opponentShape, ourShape, roundScore + shapeScore});
    }

    debug.print("{d}\n", .{sum});
}
