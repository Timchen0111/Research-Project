function PL = pathloss(Hbs,Hut,h,d2d,fc)
%calculate pathloss. Output is [pathloss,type(PL1 or PL2)]
d3d = sqrt((Hbs-Hut)^2+d2d^2);
c = physconst('LightSpeed');
dbp = 2*pi*Hbs*Hut*fc*(1e9)/c;
PL1 = 28+22*log10(d3d)+20*log10(fc);
PL2 = 28+40*log10(d3d)+20*log10(fc)-9*log10((dbp)^2+(Hbs-Hut)^2);

if d2d<dbp
    %PL1
    PL = PL1;
else
    %PL2
    PL = PL2;
end
