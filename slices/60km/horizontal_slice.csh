#!/bin/csh
#
# IRIS Horizontal Slice Viewer
# GMT script
# generated: 13:37:34 07/12/18 PDT
#
gmt gmtset  MAP_FRAME_TYPE plain
gmt gmtset  COLOR_FOREGROUND 100
gmt gmtset  PS_MEDIA letter
gmt gmtset  DIR_GSHHG /usr/share/gshhg-gmt-2.3.6
gmt gmtset  FORMAT_GEO_MAP dddF
gmt gmtset  FONT_TITLE 20
gmt gmtset  PROJ_LENGTH_UNIT  inch
gmt gmtset  COLOR_NAN 255/255/255
gmt gmtset  FONT_LABEL 8p
gmt gmtset  MAP_FRAME_PEN 0.001p
gmt gmtset  MAP_FRAME_WIDTH 0.001i
gmt gmtset  MAP_FRAME_WIDTH 0.001i

set ps="./testDensity.ps"
set grd="./horizontal_slice1.grd"
set cpt="./horizontal_slice1.cpt"
set Dgrd1="./D_grd1.grd"
set Dgrd2="./D_grd2.grd"

gmt surface  ./horizontal_slice1.dat  -G$grd -T0.7 -R-125.79/24.47/-66.81/50.03r -I30m/30m

# Getting density grd ρ=(Vp(1+grd)+2.4)/3.125
# vp=11261.55/3.125 = 3603.696
# c=2.40/3.125 = 0.768
# extra=$vp+$c = 3604.464
set extra=3604.464

# (grd*vp)/3.125 = D.grd
gmt grdmath $grd 11261.55 MUL = $Dgrd1
gmt grdmath $Dgrd1 3.125 DIV = $Dgrd1
gmt grdmath $Dgrd1 3604.464 ADD = $Dgrd1
#gmt grdmath $Dgrd1 1000 DIV = $Dgrd1

# Getting density another method 
# ρ=ρ(1+grd)
gmt grdmath $grd 13087.6 MUL = $Dgrd2
gmt grdmath $Dgrd2 13087.6 ADD = $Dgrd2

gmt grd2cpt -D -Z $Dgrd2  -Cseis >$cpt
gmt psmask ./horizontal_slice1.dat -JM-96.30000000000001/37.25/7.5i  -P   -R-125.79/24.47/-66.81/50.03r -I30m/30m -K -X0.5i -Y2.0i  > $ps
gmt grdimage $Dgrd2 -E200 -JM-96.30000000000001/37.25/7.5i  -P  -K -R-125.79/24.47/-66.81/50.03r -C$cpt -Q  -O >>$ps
gmt psmask -C  -K -O  >> $ps
gmt psscale -C$cpt -D5i/-0.2i/6/0.07ih -F  -P -O -K -I0.3 -Xa-1.75 -Ya0 -B50000:"":/:"density(kg/m^3)":>>$ps
gmt pstext ./horizontal_slice1_legend.txt -F  -R0/3.75/0/1 -JX1i/1i -Xa0.8 -Ya-0.1  -P  -N -K  -O >>   $ps
gmt pscoast -B5g5:.'US-SL-2014 (dVs %) horizontal slice (depth = 60 km)':wENs -E180/90 -JM-96.30000000000001/37.25/7.5i  -R-125.79/24.47/-66.81/50.03r -Df -N1/0 -N2/0 -W1/0 -W2/0 -A5000  -O >> $ps

open $ps