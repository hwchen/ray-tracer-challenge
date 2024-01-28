package ray_tracer

import "core:testing"

Ray :: struct {
    origin:    Tuple,
    direction: Tuple,
}

// constructor, checks for point and vector
// TODO check if there's a better way to handle Point and Vector. The issue is that I want
// the primitive types to do array operations, so I don't want to wrap (like I probably would in Rust).
// Then the question is where to sprinkle these asserts. I guess in constructors?
ray :: proc(origin: Tuple, direction: Tuple) -> Ray {
    // asserts can be removed w/ ODIN_DISABLE_ASSERT
    assert(is_point(origin))
    assert(is_vector(direction))
    return Ray{origin, direction}
}

@(test)
test_ray_construction :: proc(t: ^testing.T) {
    origin := point(1, 2, 3)
    direction := vector(4, 5, 6)
    r := ray(origin, direction)
    expect_tuples_eq(t, r.origin, origin)
    expect_tuples_eq(t, r.direction, direction)
}
