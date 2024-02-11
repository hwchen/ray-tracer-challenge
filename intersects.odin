package ray_tracer

import "core:math"
import "core:testing"

// The t along the ray which correspond to intersection points of a shape
Intersects :: union {
    Hit,
    Miss,
}

Hit :: [2]f32
Miss :: struct {}

intersects_sphere :: proc(ray: Ray, sphere: Sphere) -> Intersects {
    return nil
}

intersects ::proc{intersects_sphere}

@(test)
test_ray_sphere_intersection_two_points :: proc(t: ^testing.T) {
    r := ray(point(0, 0, -5), vector(0, 0, 1))
    s := sphere()
    xs := intersects(r, s).(Hit)

    expect_tuples_eq(t, xs[0], 4.0)
    expect_tuples_eq(t, xs[1], 6.0)
}

@(test)
test_ray_sphere_intersection_tangent :: proc(t: ^testing.T) {
    r := ray(point(0, 1, -5), vector(0, 0, 1))
    s := sphere()
    xs := intersects(r, s).(Hit)

    expect_tuples_eq(t, xs[0], 5.0)
    expect_tuples_eq(t, xs[1], 5.0)
}

@(test)
test_ray_sphere_intersection_miss :: proc(t: ^testing.T) {
    r := ray(point(0, 2, -5), vector(0, 0, 1))
    s := sphere()
    _ = intersects(r, s).(Miss)
}

@(test)
test_ray_sphere_intersection_inside_sphere :: proc(t: ^testing.T) {
    r := ray(point(0, 0, 0), vector(0, 0, 1))
    s := sphere()
    xs := intersects(r, s).(Hit)

    expect_tuples_eq(t, xs[0], -1.0)
    expect_tuples_eq(t, xs[1], 1.0)
}

@(test)
test_ray_sphere_intersection_sphere_behind_ray :: proc(t: ^testing.T) {
    r := ray(point(0, 0, 5), vector(0, 0, 1))
    s := sphere()
    xs := intersects(r, s).(Hit)

    expect_tuples_eq(t, xs[0], -6.0)
    expect_tuples_eq(t, xs[1], -4.0)
}
