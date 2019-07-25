
reset
set terminal wxt size 1400,700

set style line 1 lc rgb 'black' pt 7 ps .5

unset key
set xtics font ',12'
set ytics font ',12'
set xlabel "1000 timesteps" font ',14'
set ylabel "energy / 1000 kJ/mol" font ',14'

plot "min_energy.dat" using 2:4 with points ls 1
