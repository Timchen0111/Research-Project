function rate = rate(SINR,fc)
B = 2e5; %bandwidth (may be wrong!)
rate = B*log2(1+SINR);
