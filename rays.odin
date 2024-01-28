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

position :: proc(r: Ray, t: f32) -> Tuple {
    return r.origin + (r.direction * t)
}

@(test)
test_compute_point_from_distance :: proc(t: ^testing.T) {
    r := ray(point(2, 3, 4), vector(1, 0, 0))
    expect_tuples_eq(t, position(r, 0), point(2, 3, 4))
    expect_tuples_eq(t, position(r, 1), point(3, 3, 4))
    expect_tuples_eq(t, position(r, -1), point(1, 3, 4))
    expect_tuples_eq(t, position(r, 2.5), point(4.5, 3, 4))
}
