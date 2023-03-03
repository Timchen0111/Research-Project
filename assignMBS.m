function MBS  = assignMBS(g,UE,tgNB_num,bw,multi)
%disp("------ASSIGN MBS------")
UE_num = size(g(tgNB_num).MBS,1);
for i = 1:UE_num
    all(i) = 0;
    r(i) = 0;
    n(i) = 0;
end
for i = 1:UE_num %把UE放進第i個MBS group
    if UE.SINR<g(tgNB_num).worstSINR(i)
        worst = UE.SINR;
    else 
        worst = g(tgNB_num).worstSINR(i);
    end %得到第i個MBS group的worst SINR,其他不變

    for j = 1:UE_num
        if j == i
            WorstSINR = worst;
        else
            WorstSINR = g(tgNB_num).worstSINR(j);
        end
        r(j) = rate(10^(WorstSINR),bw); %算出rj
        if j == i
            n(j) = 1;
        else
            n(j) = 0;
        end
        siz = size(g(tgNB_num).MBS(1));
        for k=1:siz(2)
            if g(tgNB_num).MBS(j,k) ~= 0
                n(j) = n(j)+1;
            end
        end%算出n(j)

        if n(j) ~= 0
            all(i) = all(i)+r(j)*n(j);
        end
    end
    
end
g(tgNB_num).MBS
%all
chosen = max(all);

if chosen == 0
    MBS = randi([1,UE_num]);
else
    for i=1:UE_num
            if all(i) == chosen
                MBS = i;
            end
        end
end
%MBS

