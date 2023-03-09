package ray_tracer

import "core:testing"

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
