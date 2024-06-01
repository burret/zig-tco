const std = @import("std");

// $ zig version
// 0.12.0
// $ zig targets | jq -r '.native.triple'
// aarch64-macos.14.5...14.5-none
// $ zig build-exe stackoverflow.zig
// $ time ./stackoverflow 
// info: 1
// [...]
// info: 104762
// Segmentation fault: 11
// 
// real	0m12.026s
// user	0m11.713s
// sys	0m0.050s
// $

fn noStackOverflow(count: u128, limit: u128) u128 {
    return if (count == limit) count else @call(.always_tail, noStackOverflow, .{count + 1, limit});
}

fn stackOverflow(count: u128, limit: u128) u128 {
    std.log.info("{d}", .{count});
    return if (count == limit) count else stackOverflow(count + 1, limit);
}

pub fn main() !void {
    const limit = 1_000_000_000;
    _ = noStackOverflow(0, limit);
    _ = stackOverflow(0, limit);
}
