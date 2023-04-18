scratch scene out="scratch/test.ppm":
    odin run . -- --scene {{scene}} --out {{out}} && feh {{out}}
