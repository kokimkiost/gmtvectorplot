#!/bin/csh

set region3 = -8/2/0.5/10.5
set scale2 = 0.4
set case = regend

echo 8 > format.in1
echo     0     2   0.500   0.500   0.000   0.200   0.300   2 >> format.in1
echo     2     5   1.000   1.000   0.000   0.200   0.300   1 >> format.in1
echo     5    10   1.000   1.000   0.000   0.200   0.300   2 >> format.in1
echo    10    15   1.000   1.000   0.000   0.200   0.300   3 >> format.in1
echo    15    20   1.000   1.000   0.000   0.200   0.300   4 >> format.in1
echo    20    25   1.000   1.000   0.000   0.200   0.300   5 >> format.in1
echo    25    30   1.000   1.000   0.000   0.200   0.300   6 >> format.in1
echo    30    40   1.000   1.000   0.000   0.200   0.300   8 >> format.in1
echo 4 > format.in2
echo    40    50   1.000   0.800   0.000   0.200   0.300  11 >> format.in2
echo    50    60   1.000   0.600   0.000   0.200   0.300  12 >> format.in2
echo    60    70   1.000   0.400   0.000   0.200   0.300  13 >> format.in2
echo    70    80   1.000   0.200   0.000   0.200   0.300  14 >> format.in2
echo 4 > format.in3
echo    80   100   1.000   0.800   0.100   0.200   0.300  11 >> format.in3
echo   100   120   1.000   0.800   0.100   0.200   0.300  12 >> format.in3
echo   120   150   1.000   0.800   0.100   0.200   0.300  13 >> format.in3
echo   150   200   1.000   0.800   0.100   0.200   0.300  14 >> format.in3
echo 2 > format.in4 
echo   200   250   1.000   0.000   0.000   1.000   0.300   2 >> format.in4
echo   250   300   1.000   0.000   0.000   1.000   0.300  11 >> format.in4
echo 1 > format.in5 
echo   300   400   1.000   0.000   0.300   1.000   0.300  11 >> format.in5
#       v1    v2   Length     BL      BW      AL      AW  AK

gmtset PLOT_DEGREE_FORMAT +ddd:mmF
gmtset HEADER_FONT_SIZE 16p

#regend
psxy -R$region3 -JX12 -P -L -W3,0 -G255 -K << END > $case.ps
0   5.1
0   9.1
1.6 9.1
1.6 5.1
#0   5.1
#0   9.6
#1.6 9.6
#1.6 5.1
END

echo   0   2 8.9 > regend.in
echo   2   5 8.7 >> regend.in
echo   5  10 8.5 >> regend.in
echo  10  15 8.3 >> regend.in
echo  15  20 8.1 >> regend.in
echo  20  25 7.9 >> regend.in
echo  25  30 7.7 >> regend.in
echo  30  40 7.5 >> regend.in
echo  40  50 7.3 >> regend.in
echo  50  60 7.1 >> regend.in
echo  60  70 6.9 >> regend.in
echo  70  80 6.7 >> regend.in
echo  80 100 6.5 >> regend.in
echo 100 120 6.3 >> regend.in
echo 120 150 6.1 >> regend.in
echo 150 200 5.9 >> regend.in
echo 200 250 5.7 >> regend.in
echo 250 300 5.5 >> regend.in
echo 300 400 5.3 >> regend.in

cat regend.in | awk '{print 0.1,$3,$2,0}' > regend.xyuv
vectorplot format.in1 regend.xyuv $scale2 | psxy -R -JX -W1,100 -m -K -O >> $case.ps
vectorplot format.in2 regend.xyuv $scale2 | psxy -R -JX -W1,0/0/255 -m -K -O >> $case.ps
vectorplot format.in3 regend.xyuv $scale2 | psxy -R -JX -W1,0/255/0 -G0/255/0 -m -K -O >> $case.ps
vectorplot format.in4 regend.xyuv $scale2 | psxy -R -JX -W1,255/0/0 -m -K -O >> $case.ps
vectorplot format.in5 regend.xyuv $scale2 | psxy -R -JX -W1,255/0/0 -G255/0/0 -m -K -O >> $case.ps

cat regend.in | awk '{print 0.6,$3,8,0,0,5,$1 "~" $2}' > regend.text
pstext regend.text -R -JX -O >> $case.ps
#pstext regend.text -R -JX -K -O >> $case.ps
#pstext -R -JX -O << END >> $case.ps
#0.8 9.4 8 0 0 6 Current Vel.
#0.8 9.2 8 0 0 6 (cm/sec)
#END

convert -density 72 -trim $case.ps $case-72.png
convert -density 100 -trim $case.ps $case-100.png
convert -density 200 -trim $case.ps $case-200.png
convert -density 300 -trim $case.ps $case-300.png
convert -density 600 -trim $case.ps $case-600.png
