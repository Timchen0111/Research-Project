function gNB = set_gNB(g,UE_num)
gNB = g;
for i=1:19
    gNB(i).num = i;
    gNB(i).MBS = zeros(UE_num,1);
end
for i=1:7
    gNB(i).type = true;
    gNB(i).to_unicast = 0.5;
    for k=1:UE_num
        gNB(i).unicast_member(k) = false;
    end
    for j=1:UE_num
        gNB(i).worstSINR(j) = inf;
    end
    gNB(i).saveMBS = [false,0];
end
gNB(1).pos = [0,0];
gNB(2).pos = [200,0];
gNB(3).pos = [100,100*sqrt(3)];
gNB(4).pos = [-100,100*sqrt(3)];
gNB(5).pos = [-200,0];
gNB(6).pos = [-100,-100*sqrt(3)];
gNB(7).pos = [100,-100*sqrt(3)];
gNB(8).pos = [400,0];
gNB(9).pos = [300,100*sqrt(3)];
gNB(10).pos = [200,200*sqrt(3)];
gNB(11).pos = [0,200*sqrt(3)];
gNB(12).pos = [-200,200*sqrt(3)];
gNB(13).pos = [-300,100*sqrt(3)];
gNB(14).pos = [-400,0];
gNB(15).pos = [-300,-100*sqrt(3)];
gNB(16).pos = [-200,-200*sqrt(3)];
gNB(17).pos = [0,-200*sqrt(3)];
gNB(18).pos = [200,-200*sqrt(3)];
gNB(19).pos = [300,-100*sqrt(3)];
