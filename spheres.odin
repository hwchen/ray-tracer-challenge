package ray_tracer

import "core:math"

// sphere is always unit sphere. spheres are transformed/translated by keeping sphere
// fixed and transforming/translating the intersecting ray
Sphere :: struct {}

// convenience constructor
sphere :: proc() -> Sphere {
    return Sphere{}
}
