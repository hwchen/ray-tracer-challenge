package ray_tracer

import "core:fmt"
import "core:math"
import "core:os"
import "core:strings"
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

// TODO handle breaking lines at 70 chars
canvas_to_ppm :: proc(c: Canvas) -> string {
    // cap accounts for 4 chars for each pixel, plus header len
    buf := strings.builder_make_len_cap(0, int(c.width * c.height * 4 + 50))

    fmt.sbprintf(&buf, "P3\n%d %d\n255\n", c.width, c.height)
    for pixel, idx in c.pixels {
        fmt.sbprintf(
            &buf,
            "%d %d %d ",
            u8(math.round(math.clamp(pixel[0] * 255, 0, 255))),
            u8(math.round(math.clamp(pixel[1] * 255, 0, 255))),
            u8(math.round(math.clamp(pixel[2] * 255, 0, 255))),
        )

        // each pixel set ends in space; for end of row (width), replace w/ \n
        if u32(idx + 1) % c.width == 0 {
            buf.buf[len(buf.buf) - 1] = '\n'
        }
    }

    return strings.to_string(buf)
}

canvas_to_file :: proc(c: Canvas, filepath: string) -> (success: bool) {
    ppm := canvas_to_ppm(c)
    defer delete(ppm)

    return os.write_entire_file(filepath, transmute([]u8)ppm)
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

@(test)
test_ppm_pixels :: proc(t: ^testing.T) {
    c := canvas_init(5, 3)
    defer canvas_destroy(c)

    c1 := color(1.5, 0, 0)
    c2 := color(0, 0.5, 0)
    c3 := color(-0.5, 0, 1)

    write_pixel(c, 0, 0, c1)
    write_pixel(c, 2, 1, c2)
    write_pixel(c, 4, 2, c3)

    ppm := canvas_to_ppm(c)
    defer delete(ppm)

    expected := `255 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 128 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 255
`

    testing.expect_value(t, ppm[11:], expected)
}

@(test)
test_ppm_terminated_by_newline :: proc(t: ^testing.T) {
    c := canvas_init(5, 3)
    defer canvas_destroy(c)

    c1 := color(0, 0, 0)

    write_pixel(c, 0, 0, c1)

    ppm := canvas_to_ppm(c)
    defer delete(ppm)

    testing.expect_value(t, ppm[len(ppm) - 1], '\n')
}
