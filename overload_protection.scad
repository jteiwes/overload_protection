/**
 * Überlastshutz für BMW C1 Ständer // Overload protection for BMW C1 stand.
 * 
 * (Similar to BMW part No. 46528524293)
 *
 * Author:  Johannes Teiwes <johannes.teiwes@me.com>
 * Date:    2021/04/09
 * License: CC-BY-4.0
 *
 */

$fn=80;

// Measurments of the original part
body_thickness = 15.6;
inner_radius = 14.25/2;
outer_radius = inner_radius + 10.3;

top_pin_radius = 5.3/2;
top_pin_height = 14.11;
top_pin_circle_radius = 13;
top_pin_rot_z = 0;

bottom_pin_radius = 7.8/2;
bottom_pin_height = 4.85;
bottom_pin_cicrle_radius = outer_radius - 6.58 + bottom_pin_radius;

module pin_with_chamfer(r, h, c, c_b=0) {
    height = h-c;
    cylinder(r2=r, r1=r+c_b, h=c_b);
    cylinder(r=r, h=height);
    translate([0,0,height])
    cylinder(r1=r, r2=r-c, h=c);
}

module top_pins() {
    rotate([0,0,20])
    translate([top_pin_circle_radius,0,0])
    pin_with_chamfer(r=top_pin_radius, h=top_pin_height, c=0.75, c_b=0.5);
    rotate([0,0,180-20])
    translate([top_pin_circle_radius,0,0])
    pin_with_chamfer(r=top_pin_radius, h=top_pin_height, c=0.75, c_b=0.5);
}

module bottom_pins() {

    translate([0,0,0]) {

        rotate([0,0,20])
        translate([bottom_pin_cicrle_radius, 0, 0])
        rotate([180,0,0]) {
            pin_with_chamfer(r=bottom_pin_radius, h=bottom_pin_height, c=0.5);
            translate([0,0,-bottom_pin_height/1.5])
            cylinder(r2=bottom_pin_radius, r1=bottom_pin_radius-bottom_pin_height/2, h=bottom_pin_height/1.5);
        }

        intersection() {
            translate([0,0,-body_thickness])
            outer_shape();

            rotate([0,0,180-20])
            translate([bottom_pin_cicrle_radius, 0, 0])
            rotate([180,0,0]) {
                pin_with_chamfer(r=bottom_pin_radius, h=bottom_pin_height, c=0.5);
                hull() {
                    translate([0,-bottom_pin_radius+0.5,0])
                    cube([bottom_pin_radius,2*bottom_pin_radius-1,bottom_pin_height]);
                    translate([0,-bottom_pin_radius,0])
                    cube([bottom_pin_radius,2*bottom_pin_radius,bottom_pin_height-0.5]);
                }
            }
        }

        intersection() {
            translate([0,0,-body_thickness])
            outer_shape();

            rotate([0,0,90])
            translate([bottom_pin_cicrle_radius, 0, 0])
            rotate([180,0,0]) {
                pin_with_chamfer(r=bottom_pin_radius, h=bottom_pin_height, c=0.5);
                hull() {
                    translate([0,-bottom_pin_radius+0.5,0])
                    cube([bottom_pin_radius,2*bottom_pin_radius-1,bottom_pin_height]);
                    translate([0,-bottom_pin_radius,0])
                    cube([bottom_pin_radius,2*bottom_pin_radius,bottom_pin_height-0.5]);
                }
            }
        }        
    }
}

module outer_shape() {
    hull() {
        difference() {
            cylinder(r=outer_radius, h=body_thickness);
            rotate([0,0,22+top_pin_rot_z])
            translate([-outer_radius, -outer_radius, -body_thickness/2])
            cube([2*outer_radius, outer_radius, 2*body_thickness]);
            rotate([0,0,-22+top_pin_rot_z])
            translate([-outer_radius, -outer_radius, -body_thickness/2])
            cube([2*outer_radius, outer_radius, 2*body_thickness]);
        }

        rotate([0,0,top_pin_rot_z]) {
            rotate([0,0,20])
            translate([top_pin_circle_radius,0,0])
            cylinder(r=top_pin_radius+1.75, h=body_thickness);
            rotate([0,0,180-10])
            translate([top_pin_circle_radius,0,0])
            cylinder(r=top_pin_radius+1.75, h=body_thickness);
        }

        translate([0,0,0])
        cylinder(r=inner_radius+2.2, h=body_thickness);

        translate([inner_radius+1.5,-inner_radius-1.7+top_pin_radius, 0])
        cylinder(r=top_pin_radius, h=body_thickness);
    }
}

module overload_protection() {
    difference() {
        union() {
            outer_shape();
            translate([0,0,body_thickness]) {
                // color("green")
                top_pins();
            }
            // color("red")
            bottom_pins();
        }
        translate([0,0,-body_thickness/2])
        cylinder(r=inner_radius, h=2*body_thickness);
    }
}
// For maximum strength I recommend to print the part in this orientation:
rotate([90,-60,0])
overload_protection();
