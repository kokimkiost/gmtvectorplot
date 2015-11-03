#ifort vectorplot.f
./vectorplot.exe xyuv.in 0.15 | psxy -R0/4/0/4 -JX15 -B1::WSne -G0 -P -W1,0 -m > zz.ps 
convert -density 200 -trim zz.ps zz.png
