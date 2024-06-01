const std = @import("std");

// $ zig version
// 0.12.0
// $ zig targets | jq -r '.native.triple'
// aarch64-macos.14.5...14.5-none
// $ zig build-exe fibonacci.zig
// $ ./fibonacci 185
// 205697230343233228174223751303346572685
// $

fn tail_call_fib(i: u128, c: u128, n: u128) u128 {
    return if (i == 0) c else @call(.always_tail, tail_call_fib, .{i - 1, n, c + n});
}

pub fn fib(i: u128) u128 {
    return tail_call_fib(i, 0, 1);
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const args = try std.process.argsAlloc(allocator);
    const index: u128 = try std.fmt.parseInt(u128, args[1], 10);
    try stdout.print("{d}\n", .{fib(index)});
}
