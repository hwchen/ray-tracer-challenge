package ray_tracer

import "core:bufio"
import "core:fmt"
import "core:log"
import "core:math"
import "core:os"
import "core:reflect"
import "core:slice"
import "core:strings"

main :: proc() {
    context.logger = log.create_console_logger(.Info)

    opts := parse_opts()
    if opts.list_scenes {
        for scene in reflect.enum_field_names(Scene) {
            fmt.println(scene)
        }
        return
    }
    log.infof("Scene: %v", opts.scene)
    log.infof("Output path: %v", opts.out_path)

    c: Canvas
    switch opts.scene {
    case .projectile:
        c = scene_projectile()
    case .clock:
        c = scene_clock()
    }
    defer canvas_destroy(c)

    canvas_to_file(c, opts.out_path)
}

Opts :: struct {
    list_scenes: bool,
    scene:       Scene,
    out_path:    string,
}

Scene :: enum {
    projectile,
    clock,
}

parse_opts :: proc() -> Opts {
    opts: Opts

    for i := 1; i < len(os.args); {
        switch os.args[i] {
        case "--out", "-o":
            opts.out_path = get_opt_arg(i + 1)
            i += 2
        case "--scene", "-s":
            s := get_opt_arg(i + 1)
            scene, eok := reflect.enum_from_name(Scene, strings.to_lower(s))
            if eok {
                opts.scene = scene
            } else {
                os.exit(1)
            }
            i += 2
        case "--list-scenes", "-l":
            opts.list_scenes = true
            i += 1
        case:
            break
        }
    }

    return opts
}

get_opt_arg :: proc(args_idx: int) -> string {
    arg, sok := slice.get(os.args, args_idx)
    if !sok {
        fmt.println("Flag missing argument")
        os.exit(1)
    }
    return arg
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
    c := canvas_init(500, 500)

    c1 := color(1, 0.8, 0.6)

    hour := point(0, 200, 0)
    rotate_hour := rotation_z(math.π / 6)

    for _i in 0 ..< 12 {
        hour = rotate_hour * hour
        log.infof("Hour: %v", hour)
        write_pixel(c, (c.width / 2) + u32(hour[0]), (c.height / 2) - u32(hour[1]), c1)
    }

    return c
}
