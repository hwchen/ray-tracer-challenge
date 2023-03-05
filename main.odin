package ray_tracer

import "core:fmt"
import "core:testing"
import "core:math"

expect :: testing.expect

Tuple :: [4]f32

// A point is a coordinate in three-dimensional space.
// It's represented as a tuple w/ last entry as 1, useful
// for various calculations.
point :: proc(x: f32, y: f32, z: f32) -> Tuple {
    return {x, y, z, 1}
}

// A vector is a direction and magnitude in three-dimensional space.
// It's represented as a tuple w/ last entry as 0, useful
// for various calculations.
vector :: proc(x: f32, y: f32, z: f32) -> Tuple {
    return {x, y, z, 0}
}

magnitude :: proc(v: Tuple) -> f32 {
    return math.sqrt(v[0] * v[0] + v[1] * v[1] + v[2] * v[2] + v[3] * v[3])
}

// Given a vector, return a unit vector w/ the same direction
normalize :: proc(v: Tuple) -> Tuple {
    return v / magnitude(v)
}

// Note that a scalar will be spread onto a tuple, so this works the same for
// scalars as well as tuples
expect_tuples_eq :: proc(
    t: ^testing.T,
    found: Tuple,
    expected: Tuple,
    loc := #caller_location,
) -> bool {
    EPSILON: f32 : 0.00001

    err_msg := fmt.tprintf("Found tuple %v, expected approx %v", found, expected)

    for i in 0 ..< 4 {
        if !testing.expect(t, math.abs(found[i] - expected[i]) < EPSILON, err_msg, loc) {
            return false
        }
    }

    return true
}

// Grouped because this is basic, sanity-check types of tests
@(test)
test_tuples_basic_operations :: proc(t: ^testing.T) {
    // Basic point and vector construction
    expect_tuples_eq(t, point(4, -4, 3), Tuple{4, -4, 3, 1})
    expect_tuples_eq(t, vector(4, -4, 3), Tuple{4, -4, 3, 0})

    // Basic tuple addition
    expect_tuples_eq(t, {3, -2, 5, 1} + {-2, 3, 1, 0}, {1, 1, 6, 1})

    // Subtracting two points =  vector!
    expect_tuples_eq(t, point(3, 2, 1) - point(5, 6, 7), vector(-2, -4, -6))

    // Subtracting vector from a point =  point!
    expect_tuples_eq(t, point(3, 2, 1) - vector(5, 6, 7), point(-2, -4, -6))

    // Subtracting vector from vector = vector!
    expect_tuples_eq(t, vector(3, 2, 1) - vector(5, 6, 7), vector(-2, -4, -6))

    // Negating a tuple
    expect_tuples_eq(t, -1 * {1, -2, 3, -4}, {-1, 2, -3, 4})

    // Scalar multiplication
    expect_tuples_eq(t, 3.5 * {1, -2, 3, -4}, {3.5, -7, 10.5, -14})
    expect_tuples_eq(t, 0.5 * {1, -2, 3, -4}, {0.5, -1, 1.5, -2})

    // Scalar division
    expect_tuples_eq(t, {1, -2, 3, -4} / 2, {0.5, -1, 1.5, -2})
}

@(test)
test_vector_magnitude :: proc(t: ^testing.T) {
    expect_tuples_eq(t, magnitude(vector(1, 0, 0)), 1)
    expect_tuples_eq(t, magnitude(vector(0, 1, 0)), 1)
    expect_tuples_eq(t, magnitude(vector(0, 0, 1)), 1)
    expect_tuples_eq(t, magnitude(vector(1, 2, 3)), math.sqrt_f32(14))
    expect_tuples_eq(t, magnitude(vector(-1, -2, -3)), math.sqrt_f32(14))
}

@(test)
test_vector_normalize :: proc(t: ^testing.T) {
    expect_tuples_eq(t, normalize(vector(4, 0, 0)), vector(1, 0, 0))
    expect_tuples_eq(t, normalize(vector(1, 2, 3)), vector(0.26726, 0.53452, 0.80178))
    expect_tuples_eq(t, magnitude(normalize(vector(1, 2, 3))), 1)
}
