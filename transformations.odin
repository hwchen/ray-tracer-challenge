package ray_tracer

import "core:fmt"
import "core:math"
import "core:testing"

translation :: proc(x: f32 = 1, y: f32 = 1, z: f32 = 1) -> matrix[4, 4]f32 {
    return matrix[4, 4]f32 {
        1, 0, 0, x,
        0, 1, 0, y,
        0, 0, 1, z,
        0, 0, 0, 1,
    }
}

@(test)
test_translation_point :: proc(t: ^testing.T) {
    p := point(-3, 4, 5)
    expect_tuples_eq(t, translation(5, -3, 2) * p, point(2, 1, 7))
    expect_tuples_eq(t, inverse(translation(5, -3, 2)) * p, point(-8, 7, 3))
}

// translation does not affect vectors
@(test)
test_translation_vector :: proc(t: ^testing.T) {
    v := vector(-3, 4, 5)
    expect_tuples_eq(t, translation(5, -3, 2) * v, v)
}

scaling :: proc(x: f32 = 1, y: f32 = 1, z: f32 = 1) -> matrix[4, 4]f32 {
    return matrix[4, 4]f32 {
        x, 0, 0, 0,
        0, y, 0, 0,
        0, 0, z, 0,
        0, 0, 0, 1,
    }
}

@(test)
test_scaling_point :: proc(t: ^testing.T) {
    p := point(-4, 6, 8)
    expect_tuples_eq(t, scaling(2, 3, 4) * p, point(-8, 18, 32))
    expect_tuples_eq(t, inverse(scaling(2, 3, 4)) * p, point(-2, 2, 2))
}

// scaling affects vectors
@(test)
test_scaling_vector :: proc(t: ^testing.T) {
    v := vector(-4, 6, 8)
    expect_tuples_eq(t, scaling(2, 3, 4) * v, vector(-8, 18, 32))
}

@(test)
test_reflection :: proc(t: ^testing.T) {
    p := point(2, 3, 4)
    expect_tuples_eq(t, scaling(-1, 1, 1) * p, point(-2, 3, 4))
}
