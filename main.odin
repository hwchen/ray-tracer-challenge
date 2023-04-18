package ray_tracer

import "core:bufio"
import "core:fmt"
import "core:log"
import "core:os"

main :: proc() {
    context.logger = log.create_console_logger(.Info)

    opts := parse_opts()
    log.infof("Scene: %v", opts.scene)
    log.infof("Output path: %v", opts.out_path)

    c: Canvas
    switch opts.scene {
    case .Projectile:
        c = scene_projectile()
    case .Clock:
        c = scene_clock()
    }
    defer canvas_destroy(c)

    canvas_to_file(c, opts.out_path)
}

Opts :: struct {
    scene:    Scene,
    out_path: string,
}

Scene :: enum {
    Projectile,
    Clock,
}

parse_opts :: proc() -> Opts {
    opts: Opts

    for i := 1; i < len(os.args); {
        switch os.args[i] {
        case "--out", "-o":
            opts.out_path = os.args[i + 1]
            i += 2
        case "--scene", "-s":
            switch os.args[i + 1] {
            case "projectile":
                opts.scene = .Projectile
            case "clock":
                opts.scene = .Clock
            case:

            }
            i += 2
        case:
            break
        }
    }

    return opts
}

scene_projectile :: proc() -> Canvas {
    c := canvas_init(900, 550)

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

    return c
}

scene_clock :: proc() -> Canvas {
    c := canvas_init(900, 550)
    return c
}
