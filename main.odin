package ray_tracer

import "core:fmt"
import "core:testing"
import "core:math"

expect:: testing.expect

Tuple :: [4]f32

point :: proc(x: f32, y: f32, z: f32) -> [4]f32 {
    return {x, y, z, 1}
}

vector :: proc(x: f32, y: f32, z: f32) -> [4]f32 {
    return {x, y, z, 0}
}

expect_tuples_eq :: proc(t: ^testing.T, found: Tuple, expected: Tuple, loc := #caller_location) -> bool {
    EPSILON : f32 : 0.00001

    err_msg := fmt.tprintf("Found tuple %v, expected approx %v", found, expected)

    for i in 0..<4 {
        if !testing.expect(t, math.abs(found[i] - expected[i]) < EPSILON, err_msg, loc) {
            return false
        }
    }

    return true
}

@test
test_tuples :: proc(t: ^testing.T) {
    expect_tuples_eq(t, point(4, -4, 3), Tuple{4, -4, 3, 1})
    expect_tuples_eq(t, vector(4, -4, 3), Tuple{4, -4, 3, 0})
}
