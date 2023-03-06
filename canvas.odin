package ray_tracer

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
