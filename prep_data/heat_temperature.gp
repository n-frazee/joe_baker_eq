
reset
set terminal wxt size 1400,700

set style line 1 lc rgb 'black' pt 7 ps .8
set style line 2 lc rgb 'grey' pt 7 ps .8 lw 10

unset key
set xtics font ',12'
set ytics font ',12'
set xlabel "1000 timesteps" font ',14'
set ylabel "temperature / K" font ',14'

f(x)= x<=290 ? x-90 : x>=490 ? .2*(x-490)+300: .5*(x-290)+200

plot [90:540] [] f(x) ls 2, "heat_temperature.dat" using 2:3 with points ls 1
