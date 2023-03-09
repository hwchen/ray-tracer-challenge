package ray_tracer

import "core:fmt"
import "core:math"
import "core:testing"

identity :: proc() -> matrix[4, 4]f32 {
    return matrix[4, 4]f32 {
            1, 0, 0, 0, 
            0, 1, 0, 0, 
            0, 0, 1, 0, 
            0, 0, 0, 1, 
        }
}

expect_matrices_eq :: proc(
    t: ^testing.T,
    found: matrix[4, 4]f32,
    expected: matrix[4, 4]f32,
    loc := #caller_location,
) -> bool {
    EPSILON: f32 : 0.00001

    err_msg := fmt.tprintf("Found tuple %v, expected approx %v", found, expected)

    for i in 0 ..< 4 {
        for j in 0 ..< 4 {
            if !testing.expect(t, math.abs(found[i, j] - expected[i, j]) < EPSILON, err_msg, loc) {
                return false
            }
        }
    }

    return true
}

@(test)
test_matrix_multiplication :: proc(t: ^testing.T) {
    m1 := matrix[4, 4]f32 {
        1, 2, 3, 4, 
        5, 6, 7, 8, 
        9, 8, 7, 6, 
        5, 4, 3, 2, 
    }

    m2 := matrix[4, 4]f32 {
        -2, 1, 2, 3, 
        3, 2, 1, -1, 
        4, 3, 6, 5, 
        1, 2, 7, 8, 
    }

    expected := matrix[4, 4]f32 {
        20, 22, 50, 48, 
        44, 54, 114, 108, 
        40, 58, 110, 102, 
        16, 26, 46, 42, 
    }

    testing.expect_value(t, m1 * m2, expected)
}

@(test)
test_matrix_tuple_multiplication :: proc(t: ^testing.T) {
    m1 := matrix[4, 4]f32 {
        1, 2, 3, 4, 
        2, 4, 4, 2, 
        8, 6, 4, 1, 
        0, 0, 0, 1, 
    }

    v := Tuple{1, 2, 3, 1}

    expected := Tuple{18, 24, 33, 1}

    testing.expect_value(t, m1 * v, expected)
}

@(test)
test_matrix_identity :: proc(t: ^testing.T) {
    m1 := matrix[4, 4]f32 {
        1, 2, 3, 4, 
        2, 4, 4, 2, 
        8, 6, 4, 1, 
        0, 0, 0, 1, 
    }

    testing.expect_value(t, m1 * identity(), m1)
}

@(test)
test_matrix_transpose :: proc(t: ^testing.T) {
    m1 := matrix[4, 4]f32 {
        1, 2, 3, 4, 
        2, 4, 4, 2, 
        8, 6, 4, 1, 
        0, 0, 0, 1, 
    }

    expected := matrix[4, 4]f32 {
        1, 2, 8, 0, 
        2, 4, 6, 0, 
        3, 4, 4, 0, 
        4, 2, 1, 1, 
    }

    testing.expect_value(t, transpose(m1), expected)
}

@(test)
test_matrix_inverse :: proc(t: ^testing.T) {
    m1 := matrix[4, 4]f32 {
        -5, 2, 6, -8, 
        1, -5, 1, 8, 
        7, 7, -6, -7, 
        1, -3, 7, 4, 
    }

    expected := matrix[4, 4]f32 {
        0.21805, 0.45113, 0.24060, -0.04511, 
        -0.80827, -1.45677, -0.44361, 0.52068, 
        -0.07895, -0.22368, -0.05263, 0.19737, 
        -0.52256, -0.81391, -0.30075, 0.30639, 
    }

    expect_matrices_eq(t, inverse(m1), expected)

    m2 := matrix[4, 4]f32 {
        3, -9, 7, 3, 
        3, -8, 2, -9, 
        -4, 4, 4, 1, 
        -6, 5, -1, 1, 
    }
    m3 := matrix[4, 4]f32 {
        8, 2, 2, 2, 
        3, -1, 7, 0, 
        7, 0, 5, 4, 
        6, -2, 0, 5, 
    }

    m4 := m2 * m3
    expect_matrices_eq(t, m4 * inverse(m3), m2)
}
