package ray_tracer

import "core:testing"

inverse :: proc() -> matrix[4, 4]f32 {
    return matrix[4, 4]f32 {
            1, 0, 0, 0, 
            0, 1, 0, 0, 
            0, 0, 1, 0, 
            0, 0, 0, 1, 
        }
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
test_matrix_inverse :: proc(t: ^testing.T) {
    m1 := matrix[4, 4]f32 {
        1, 2, 3, 4, 
        2, 4, 4, 2, 
        8, 6, 4, 1, 
        0, 0, 0, 1, 
    }

    testing.expect_value(t, m1 * inverse(), m1)
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
