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
    sphere_to_ray := ray.origin - point(0, 0, 0)
    a := dot(ray.direction, ray.direction)
    b := 2 * dot(ray.direction, sphere_to_ray)
    c := dot(sphere_to_ray, sphere_to_ray) - 1
    discriminant := (b * b) - (4 * a * c)
    if discriminant < 0 {
        return Miss{}
    } else {
        t1 := (-b - math.sqrt(discriminant)) / (2 * a)
        t2 := (-b + math.sqrt(discriminant)) / (2 * a)
        return Hit{t1, t2}
    }
}

intersects :: proc {
    intersects_sphere,
}

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
