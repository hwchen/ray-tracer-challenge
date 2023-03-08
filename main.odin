package ray_tracer

import "core:bufio"
import "core:fmt"
import "core:os"

main :: proc() {
    c := canvas_init(900, 550)
    defer canvas_destroy(c)

    c1 := color(1, 0.8, 0.6)

    gravity := vector(0, -0.1, 0)
    wind := vector(-0.01, 0, 0)

    projectile := point(0, 1, 0)
    velocity := normalize(vector(1, 1.8, 0)) * 11.25
    for projectile[1] >= 0 {
        write_pixel(c, u32(projectile[0]), c.height - u32(projectile[1]), c1)
        velocity += gravity
        velocity += wind

        projectile += velocity
    }

    canvas_to_file(c, "scratch/test.ppm")
}
