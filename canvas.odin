package ray_tracer

import "core:fmt"
import "core:testing"

Canvas :: struct {
    width:  u32,
    height: u32,
    pixels: []Tuple,
}

canvas_init :: proc(width: u32, height: u32) -> Canvas {
    return Canvas{width = width, height = height, pixels = make([]Tuple, width * height)}
}

canvas_destroy :: proc(canvas: Canvas) {
    delete(canvas.pixels)
}

write_pixel :: proc(c: Canvas, x: u32, y: u32, color: Tuple) {
    c.pixels[c.width * y + x] = color
}

pixel_at :: proc(c: Canvas, x: u32, y: u32) -> Tuple {
    return c.pixels[c.width * y + x]
}

canvas_to_ppm :: proc(c: Canvas) -> string {
    header := fmt.aprintf("P3\n%d %d\n255\n", c.width, c.height)

    return header
}

@(test)
test_canvas_creation :: proc(t: ^testing.T) {
    c := canvas_init(10, 20)
    defer canvas_destroy(c)

    for pixel in c.pixels {
        expect_tuples_eq(t, pixel, color(0, 0, 0))
    }
}

@(test)
test_write_pixel :: proc(t: ^testing.T) {
    c := canvas_init(10, 20)
    defer canvas_destroy(c)

    red := color(1, 0, 0)

    write_pixel(c, 2, 3, red)
    expect_tuples_eq(t, pixel_at(c, 2, 3), red)
}

@(test)
test_ppm_header :: proc(t: ^testing.T) {
    c := canvas_init(5, 3)
    defer canvas_destroy(c)

    ppm := canvas_to_ppm(c)
    defer delete(ppm)

    testing.expect_value(t, ppm[:10], "P3\n5 3\n255")
}
