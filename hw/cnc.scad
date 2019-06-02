/**
 * Copyright 2019 Marc SIBERT
 * 
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

/**
 * Barre (réglable)
 */
module barre(l = 50) {
    color("grey") union() for (i=[0,1])translate([0,(1-i)*l*(9/20),i*l*(9/20)]) cube([1000,l*(1-9*i/10),l*(9*i/10+0.1)], center=true);
}

module roue() {
    color("grey") difference() {
        union() for (i=[-1,1]) {
            translate([0,0,2.5*i+2.5/2]) cylinder(d1=23.90,d2=19.61,h=2.5,center=true);
            translate([0,0,2.5*i-2.5/2]) cylinder(d2=23.90,d1=19.61,h=2.5,center=true);
        }
        cylinder(d=15.974,h=11,center=true);
    }
    color("darkgrey") for (i=[-1,1]) translate([0,0,i*2.5]) difference() {
         cylinder(d=16,h=5,center=true);
         cylinder(d=5,h=6,center=true,$fn=20);
    }
}

module chariotX(xPos) {
    for (i=[-1,1]) {

// 4 roues
        for (x=[-1,1], y=[-1,1])
            translate([xPos+x*50,i*531.8203,y*45.11]) rotate([90,0,0]) {
                roue();
// Tête de vis M5 low-profile (1.5mm max)
                color("black") translate([0,0,5.75]) cylinder(d=8.5,h=1.5,$fn=50,center=true);
                
        }
        
// Plaque    
        difference() {
           color("#FFA0A0") translate([xPos,i*540,0]) cube([120,5,110], center=true);

// 4 trous
        for (x=[-1,1], y=[-1,1])
            translate([xPos+x*50,i*540,y*45.11]) rotate([90,0,0]) cylinder(d=5,h=6,$fn=20,center=true);
        }
    }
}

//**
//* Support central
//*
//**
module support() {    
// Fond arrondi
    difference() {
        translate([0,5/sqrt(2)/2,-sqrt(2)-2.55]) cube([16,5/sqrt(2),15], center=true);
        translate([0,2,-10.5]) rotate([90,0,0]) cylinder(d=15,h=5/sqrt(2)+1,$fn=50,center=true);
    }
    rotate([-45,0,0]) {
// Plaque et trou supérieurs
        translate([0,0,25+2.5]) rotate([90,0,0]) {
            difference() {
                hull() {
                    cylinder(d=15,h=5,center=true);
                    translate([0,-25+2.5,0]) cube([25,5,5],center=true);
                }
                cylinder(d=8,h=6,$fn=20,center=true);
// Axe supérieur de percage vis sur rails
                #cylinder(d=1,h=20,center=true);
            }
        }
// Plaque et trou inférieurs
        translate([0,25+2.5,0]) difference() {
            cube([25,15,5],center=true);
            cylinder(d=8,h=6,$fn=20,center=true);
// Axe inférieur de percage vis sur rails
            #cylinder(d=1,h=20,center=true);
        }
    }
// 2 Côté
    for (i=[-1,1]) difference() {
        hull() {
            rotate([45-90,0,0]) translate([i*10,25-5,2.5]) #cube([5,45,0.01], center=true);
            translate([i*10,(10+1.25)*sqrt(2),-58.5]) rotate([0,0,0]) cube([5,45/sqrt(2),0.01], center=true);
        }
        hull() {
            translate([i*10,2.60*sqrt(2)+5,-8.85*sqrt(2)-5]) rotate([0,90,0]) cylinder(d=7.5,h=6,$fn=40,center=true);
            translate([i*10,2.6*sqrt(2)+5,-52.2]) rotate([0,90,0]) cylinder(d=7.5,h=6,$fn=40,center=true);
            translate([i*10,19.85*sqrt(2)-5,-52.2]) rotate([0,90,0]) cylinder(d=7.5,h=6,$fn=40,center=true);
            translate([i*10,19.85*sqrt(2)-5,-32.0]) rotate([0,90,0]) cylinder(d=7.5,h=6,$fn=40,center=true);
        }
    }
    
    difference() {
// Base
        translate([0,(11.25)*sqrt(2),-58.5]) cube([25,45/sqrt(2),5], center=true);
// Perçages Base
    for (y=[7.5,45/sqrt(2)-7.5]) translate([0,y,-58.5]) cylinder(d=4.5,h=6,$fn=20,center=true);
    }
    
// Axes perçage Base
#    for (y=[7.5,45/sqrt(2)-7.5]) translate([0,y,-58.5]) cylinder(d=1,h=20,$fn=20,center=true);
}    

//**
//* Support moteur
//*
//**
module supportM() {    
    support();
    difference() {
// Boite support moteur    
       translate([-40,55/sqrt(2),0]) rotate([45,0,0]) cube([65,60,60],center=true);
// Logement pour la barre
       translate([-9.5,(55+0.5)/sqrt(2),0]) rotate([45,0,0]) cube([6,50.5,50.5],center=true);
// Évidements intérieurs        
        hull() for (x=[-15,15],yz=[-15,15]) translate([-42.5-x,(47.5+yz+7.4455)/sqrt(2),(-7.5+yz+7.4455)/sqrt(2)]) rotate([45,0,0]) cylinder(d=20,h=61,$fn=50,center=true);
        hull() for (x=[-15,15],yz=[-15,15]) translate([-42.5+x,(47.5+yz+7.4455)/sqrt(2),(7.5-yz-7.4455)/sqrt(2)]) rotate([-45,0,0]) cylinder(d=20,h=61,$fn=50,center=true);
// Passage tige filetée
        translate([-15,55/sqrt(2),0]) rotate([0,90,0]) cylinder(d=20,h=10,$fn=50,center=true);
// Passage axe moteur
        translate([-70,55/sqrt(2),0]) rotate([0,90,0]) cylinder(d=25,h=10,$fn=50,center=true);
// Fixations moteur
        for(a=[-31/2,31/2],b=[-31/2,31/2])translate([-70,55/sqrt(2)+(a+b)/sqrt(2),(a-b)/sqrt(2)]) rotate([0,90,0]) cylinder(d=3.5,h=10,$fn=20,center=true);
// Fixations Roulement
        for(a=[-37/2,37/2])translate([-15,55/sqrt(2),a]) rotate([0,90,0]) cylinder(d=4.5,h=10,$fn=20,center=true);
    }
}    

//**
//* Support fin
//*
//**
module supportF() {    
    support();
    
    difference() {
// Boite support moteur    
        translate([7.5+5,55/sqrt(2),0]) rotate([45,0,0]) cube([10,60,60],center=true);
// Logement pour la barre
       translate([9.5,(55+0.5)/sqrt(2),0]) rotate([45,0,0]) cube([6,50.5,50.5],center=true);
// Passage tige filetée
        translate([15,55/sqrt(2),0]) rotate([0,90,0]) cylinder(d=20,h=10,$fn=50,center=true);
// Fixations Roulement
        for(a=[-37/2,37/2])translate([15,55/sqrt(2),a]) rotate([0,90,0]) cylinder(d=4.5,h=10,$fn=20,center=true);
    }
}    

/**
 * Moteur Néma 17
 */
module nema17(Lmax = 34) {
    translate([0,Lmax/2,0]) difference() {
        color("lightgrey") {
// Bloc
            intersection() {
                cube([42.3, Lmax, 42.3], center=true);
                rotate([0,45,0]) cube([50, Lmax+1, 50], center=true);
            }
// Cylindre de centrage
            translate([0,-(Lmax/2+0.5),0]) rotate([90,0,0]) cylinder(d=22,h=3,$fn=100,center=true);
// Axe rotatif
            translate([0,-(Lmax/2+24/2),0]) rotate([90,0,0]) cylinder(d=5,h=24,$fn=20,center=true);
        }
        for (x=[-1,1], z=[-1,1]) {
            translate([-31/2*x,-Lmax/2+2,-31/2*z]) rotate([90,0,0]) cylinder(d=3,h=5,$fn=20,center=true);
// Axes vis M3 moteur
    #translate([-31/2*x,-Lmax/2+2,-31/2*z]) rotate([90,0,0]) cylinder(d=1,h=20,$fn=20,center=true);
        }
    }
}


/** 
 * KFL08    
 */
module KFL08() {
    color("LightGrey") difference() {
        union() {
            hull() {
// Diamètre central
                cylinder(d1=27,d2=26.5,h=4.5,$fn=50);
// Oreilles de fixation
                for (i=[-1,1]) translate([i*37/2,0,0]) cylinder(d1=48-37,d2=48-37-0.5,h=4.5,$fn=30);
        }
// Cercle supérieur
            cylinder(d1=26.5,d2=26,h=8.5,$fn=50);
// Cercle intérieur (roulement)
            cylinder(d=12,h=16,$fn=25);
    }
// Trous pour vis M4    
        for (i=[-1,1]) translate([i*37/2,0,-0.5]) cylinder(d=4.8,h=5.5,$fn=20);
// Trou barre (ds roulement)
        translate([0,0,-0.5]) cylinder(d=8,h=17,$fn=25);
    }
// Axes vis M4
#        for (i=[-1,1]) translate([i*37/2,0,-0.5]) cylinder(d=1,h=15,$fn=20,center=true);
}

/**
 * Plaque de support inférieure (planche martyr)
 */
%translate([0,0,-70]) cube([1200,1200,18], center=true);

/**
 * Axe X1
 */
 module axeX1(s = 195) {
// Barre
    translate([0,-(50*9/10)/sqrt(2),0]) rotate([-45,0,0]) barre(50);
// Leadscrew T8 * 1100mm
    color("gold") translate([15,0,0]) rotate([0,90,0]) cylinder(d=8,h=1100,$fn=50,center=true);
// Supports centraux
    for (x=[-3*s/2,-s/2,s/2,3*s/2,3*s/2]) translate([x,-(50*11/10)/sqrt(2),0]) support();

// Extrémité 0    
    translate([-5*s/2,0,0]) {
// Support moteur
        translate([0,(-50*11/10)/sqrt(2),0]) supportM();
// Moteur Nema17 48mm
        translate([-72.5,0,0]) rotate([0,45,90]) nema17(48);
// Roulement KFL08
        translate([-17.5,0,0]) rotate([0,-90,0]) KFL08();    
// Shaft Coupler (8/10mm - 25x30mm)
        color("blue") {
            translate([-50,0,0]) rotate([0,90,0]) cylinder(d=25,h=30,$fn=50,center=true);
        }
    }
    
// Extrémité 1000    
    translate([5*s/2,0,0]) {
        translate([0,(-50*11/10)/sqrt(2),0]) supportF();
// Roulement KFL08
        translate([17.5,0,0]) rotate([0,90,0]) KFL08();    
    }
}
 
translate([0,500,0]) axeX1();
translate([0,-500,0]) mirror([0,1,0]) axeX1();