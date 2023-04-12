package ray_tracer

import "core:fmt"
import "core:math"
import "core:testing"

translation :: proc(x: f32, y: f32, z: f32) -> matrix[4, 4]f32 {
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

scaling :: proc(x: f32, y: f32, z: f32) -> matrix[4, 4]f32 {
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

rotation_x :: proc(r: f32) -> matrix[4, 4]f32 {
    return matrix[4, 4]f32 {
        1, 0, 0, 0,
        0, math.cos(r), -math.sin(r), 0,
        0, math.sin(r), math.cos(r), 0,
        0, 0, 0, 1,
    }
}

rotation_y :: proc(r: f32) -> matrix[4, 4]f32 {
    return matrix[4, 4]f32 {
        math.cos(r), 0, math.sin(r), 0,
        0, 1, 0, 0,
        -math.sin(r), 0, math.cos(r), 0,
        0, 0, 0, 1,
    }
}

rotation_z :: proc(r: f32) -> matrix[4, 4]f32 {
    return matrix[4, 4]f32 {
        math.cos(r), -math.sin(r), 0, 0,
        math.sin(r), math.cos(r), 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1,
    }
}

@(test)
test_rotation_x_axis :: proc(t: ^testing.T) {
    p := point(0, 1, 0)
    half_quarter := rotation_x(math.π / 4)
    full_quarter := rotation_x(math.π / 2)
    expect_tuples_eq(t, half_quarter * p, point(0, math.sqrt_f32(2)/2, math.sqrt_f32(2)/2))
    expect_tuples_eq(t, full_quarter * p, point(0, 0, 1))
    expect_tuples_eq(t, inverse(half_quarter) * p, point(0, math.sqrt_f32(2)/2, -math.sqrt_f32(2)/2))
}

@(test)
test_rotation_y_axis :: proc(t: ^testing.T) {
    p := point(0, 0, 1)
    half_quarter := rotation_y(math.π / 4)
    full_quarter := rotation_y(math.π / 2)
    expect_tuples_eq(t, half_quarter * p, point(math.sqrt_f32(2)/2, 0, math.sqrt_f32(2)/2))
    expect_tuples_eq(t, full_quarter * p, point(1, 0, 0))
}

@(test)
test_rotation_z_axis :: proc(t: ^testing.T) {
    p := point(0, 1, 0)
    half_quarter := rotation_z(math.π / 4)
    full_quarter := rotation_z(math.π / 2)
    expect_tuples_eq(t, half_quarter * p, point(-math.sqrt_f32(2)/2, math.sqrt_f32(2)/2, 0))
    expect_tuples_eq(t, full_quarter * p, point(-1, 0, 0))
}

shear :: proc(xy: f32, xz: f32, yx: f32, yz: f32, zx: f32, zy: f32) -> matrix[4, 4]f32 {
    return matrix[4, 4]f32 {
        1, xy, xz, 0,
        yx, 1, yz, 0,
        zx, zy, 1, 0,
        0, 0, 0, 1,
    }
}

@(test)
test_shear :: proc(t: ^testing.T) {
    p := point(2, 3, 4)
    expect_tuples_eq(t, shear(1, 0, 0, 0, 0, 0) * p, point(5, 3, 4))
    expect_tuples_eq(t, shear(0, 1, 0, 0, 0, 0) * p, point(6, 3, 4))
    expect_tuples_eq(t, shear(0, 0, 1, 0, 0, 0) * p, point(2, 5, 4))
    expect_tuples_eq(t, shear(0, 0, 0, 1, 0, 0) * p, point(2, 7, 4))
    expect_tuples_eq(t, shear(0, 0, 0, 0, 1, 0) * p, point(2, 3, 6))
    expect_tuples_eq(t, shear(0, 0, 0, 0, 0, 1) * p, point(2, 3, 7))
}
