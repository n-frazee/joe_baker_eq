
reset
set terminal wxt size 1400,700

# Sets the graphs to be well spaced along with the margins line in multiplot
if (!exists("MP_LEFT"))   MP_LEFT = .125
if (!exists("MP_RIGHT"))  MP_RIGHT = .95
if (!exists("MP_BOTTOM")) MP_BOTTOM = .15
if (!exists("MP_TOP"))    MP_TOP = .9
if (!exists("MP_GAP"))    MP_GAP = 0.05

set multiplot layout 2,3 rowsfirst  margins screen MP_LEFT, MP_RIGHT, MP_BOTTOM, MP_TOP spacing screen MP_GAP

set style line 1 lc rgb 'black' pt 7 ps .5

unset key


set xtics 5 font ',12'
set ytics font ',12'
POS = "at graph 0.70,0.88 font ',16'"

set ylabel "energy / 1000 kJ/mol" font ',14' offset -1.5,-9
set label 1 "Water" @POS
plot [0:19.999] [] "min_energy.dat" using 2:4 with points ls 1
unset ylabel

set label 1 "Lipid" @POS
plot [20.001:39.999] [] "min_energy.dat" using 2:4 with points ls 1

set label 1 "Non-BB" @POS
plot [40.001:59.999] [] "min_energy.dat" using 2:4 with points ls 1

set xtics 2.5 font ',12'
set label 1 "BB" @POS
plot [60.001:69.999] [] "min_energy.dat" using 2:4 with points ls 1

set xlabel "1000 timesteps" font ',14'
set label 1 "CAs" @POS
plot [70.001:79.999] [] "min_energy.dat" using 2:4 with points ls 1
unset xlabel

set label 1 "All" @POS
plot [80.001:89.999] [] "min_energy.dat" using 2:4 with points ls 1

unset multiplot
