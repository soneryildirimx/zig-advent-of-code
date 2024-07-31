const std = @import("std");

pub fn main() !void {
    const filePath = "input.txt";

    const file = try std.fs.cwd().openFile(filePath, .{});
    defer file.close();
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();

    const fileBuffer = try file.readToEndAlloc(allocator, 1024 * 1024);
    defer allocator.free(fileBuffer);

    var iter = std.mem.splitScalar(u8, fileBuffer, '\n');
    var sum: i32 = 0;
    while (iter.next()) |line| {
        const firstDigitChar: u8 = block: {
            for (0..line.len) |char_i| {
                if (std.ascii.isDigit(line[char_i])) break :block line[char_i];
            }
            break :block '0';
        };

        const lastDigitChar: u8 = block: {
            for (0..line.len) |i| {
                const char_i = line.len - i - 1;
                if (std.ascii.isDigit(line[char_i])) break :block line[char_i];
            }
            break :block '0';
        };

        const firstDigit: i32 = firstDigitChar - '0';
        const lastDigit: i32 = lastDigitChar - '0';
        const lineResult = (firstDigit * 10) + lastDigit;

        sum += lineResult;

        std.debug.print("This is the line chars {d} - {d} \n", .{ firstDigit, lastDigit });
        std.debug.print("This is the line result {d} \n", .{lineResult});

        std.debug.print("This is the sum {d} \n", .{sum});
    }
}
