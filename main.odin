package ray_tracer

import "core:bufio"
import "core:fmt"
import "core:os"

main :: proc() {
    c := canvas_init(1024, 768)
    defer canvas_destroy(c)

    c1 := color(1, 0.8, 0.6)

    for x in 0 ..< 1024 {
        for y in 0 ..< 768 {
            write_pixel(c, u32(x), u32(y), c1)
        }
    }

    canvas_to_file(c, "scratch/test.ppm")
}
