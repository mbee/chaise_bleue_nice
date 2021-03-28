use <Naca_sweep.scad>
use <splines.scad>
use <curvedPipe.scad>

d = 2.4; // tube diameter
N=200; // interpolation points
$fn=75;

function gen_dat(S, N=100, tube) = [
for (i=[0:len(S)-1])
    let(
        dat = Tz_(S[i][2], // apply Tz
              Rx_(S[i][4], // apply Rx
              Ry_(S[i][5], // apply Ry
              tube?circle_(S[i][3], N):square_(S[i][3], N))))) // generate circle data using rad
        T_(S[i][0], S[i][1], 0, dat)
]; // apply Tx and Ty

function circle_(r=10, N=30) = [
    for (i=[0:N-1]) [
        r*sin(i*360/N), r*cos(i*360/N), 0
    ]
];

function square_(a=10, N=0) = [
    [ -a * 1.5, -a / 2, 0 ],
    [  a * 1.5, -a / 2, 0 ],
    [  a * 1.5,  a / 2, 0 ],
    [ -a * 1.5,  a / 2, 0 ],
];

module draw(outer_points, tube = true) {
    // inner skin data: reverse A with modified tube diameter
    inner_points = [
        for(i=[len(outer_points)-1:-1:0]) [
            for(j=[0:len(outer_points[0])-1])
                outer_points[i][j]-(j==3?d:0)
        ]
    ];
    outer = gen_dat(nSpline(outer_points,N), N/3, tube);    // outer skin
    inner = gen_dat(nSpline(inner_points,N), N/3, tube);    // inner skin
    sweep(concat(outer, inner), close = true, showslices = false);
}

// left arm
left_arm = [
    [0,  0,  0, d,    0, 0],
    [0,  0, 34, d,    0, 0],
    [0,  0, 43, d,    0, 0],
    [0, 20, 63, d,  -90, 0],
    [0, 54, 40, d, -125, 0],
    [0, 64,  0, d, -180, 0],
];
draw(left_arm);
left_arm_upper_part = [
    [0,  0,  0+d, d,    0, 0],
    [0,  0, 34+d, d,    0, 0],
    [0,  0, 43+d, d,    0, 0],
    [0, 20, 63+d, d,  -90, 0],
    [0, 54, 40+d, d, -125, 0],
    [0, 64,  0+d, d, -180, 0],
];
difference() {
    draw(left_arm_upper_part, tube = false);
    translate([-10, -10, -10]) rotate ([ 12, 0, 0]) cube(size=[20, 30, 100], center = false);
    translate([-10,  30, 0]) rotate ([-12, 0, 0]) cube(size=[20, 50, 100], center = false);
}

// right arm
right_arm = [
    [54,  0,  0, d,    0, 0],
    [54,  0, 34, d,    0, 0],
    [54,  0, 43, d,    0, 0],
    [54, 20, 63, d,  -90, 0],
    [54, 54, 40, d, -125, 0],
    [54, 64,  0, d, -180, 0],
];
draw(right_arm);
right_arm_upper_part = [
    [54,  0,  0+d, d,    0, 0],
    [54,  0, 34+d, d,    0, 0],
    [54,  0, 43+d, d,    0, 0],
    [54, 20, 63+d, d,  -90, 0],
    [54, 54, 40+d, d, -125, 0],
    [54, 64,  0+d, d, -180, 0],
];
difference() {
    draw(right_arm_upper_part, tube = false);
    translate([44, -10, -10]) rotate ([ 12, 0, 0]) cube(size=[20, 30, 100], center = false);
    translate([44,  30, 0]) rotate ([-12, 0, 0]) cube(size=[20, 50, 100], center = false);
}

// left seat
curvedPipe(
    [
        [5,  0, 34],    
        [5,  0, 45],
        [5, 45, 40],
        [5, 54, 80],
    ], 3, [ 7, 7 ], d * 2, 0);

// right seat
curvedPipe(
    [
        [49,  0, 34],    
        [49,  0, 45],
        [49, 45, 40],
        [49, 54, 80],
    ], 3, [ 7, 7 ], d * 2, 0);

// cross frames
translate([0,  0,     7]) rotate([0, 90, 0]) cylinder(h=54, r=d, center = false);
translate([0, 63.8,   7]) rotate([0, 90, 0]) cylinder(h=54, r=d, center = false);
translate([0,  0,    34]) rotate([0, 90, 0]) cylinder(h=54, r=d, center = false);
translate([0, 50,    45]) rotate([0, 90, 0]) cylinder(h=54, r=d, center = false);
translate([5, 53.55, 78]) rotate([0, 90, 0]) cylinder(h=44, r=d, center = false);

translate([27, 32, 0]) import("chaise-subparts.stl");