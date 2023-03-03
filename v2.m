function v2 = v2(UE_num,time,value)
tic; %Fix grouping.
UE.num = 0;
UE.pos = [0,0];
UE.MBS = 0;
UE.now_gNB = 0;
UE.velocity = [0,0];
UE.unicast = false;
UE.SINR = 0;

gNB.num = 0;
gNB.pos = [inf,inf];
gNB.type = false;
gNB.joinUE = 0;
gNB.MBS = 0;
gNB.worstSINR = [];
gNB.to_unicast = 0;
gNB.unicast_member = [];
gNB.saveMBS = [false,0];

for i=1:19
    gNB(i).pos = [inf,inf];
    gNB(i).type = false;
    gNB(i).joinUE = 0;
    gNB(i).worstSINR = inf;
end

gNB = set_gNB(gNB,UE_num);

bw = 1e8;
noise = -174+10*log10(bw); %db

cost = zeros(7,1);
overall_cost = 0;

for i=1:UE_num
    X = [inf,inf];
    while boundary(X(1),X(2)) == false
        X = 400*rand(2,1)-200;
    end
    UE(i).num = i;
    UE(i).pos = X;%generate random initial position of UEs
    UE(i).unicast = false;
    UE(i).now_gNB = now_gNB(UE(i),gNB,noise);
    UE(i).SINR = SINR(UE(i),UE(i).now_gNB,gNB,noise);
    gNB = call_gNB2(gNB,UE(i).now_gNB,UE(i),noise,UE,bw,1,value);
    if gNB(UE(i).now_gNB).saveMBS(1)==true
        UE(i).MBS = gNB(UE(i).now_gNB).saveMBS(2);
        gNB(UE(i).now_gNB).saveMBS = [false,0];
        disp(UE(i))
    end
    if gNB(UE(i).now_gNB).unicast_member(i) == true
        UE(i).unicast = true; %To unicast
    end    
end
for i=1:UE_num
    pos = UE(i).pos;
    x(i) = pos(1);
    y(i) = pos(2);
end

figure(1)

c = gNB_color(UE);

scatter(x,y,[],c)
%Set velocity
for i=1:UE_num
    UE(i).velocity = velocity(UE(i).pos);
end

%Loop

for t=1:time %600 %1 minutes
    t
   
    for i=1:UE_num
        %move
        i;
        for j=1:2
            UE(i).pos(j) = UE(i).pos(j)+UE(i).velocity(j);
        end
        %check boundary
        if boundary(UE(i).pos(1),UE(i).pos(2)) == false
            v = UE(i).velocity;
            UE(i).velocity = velocity(UE(i).pos,v);
        end
        %check nowgNB
        now = now_gNB(UE(i),gNB,noise);
       %disp('----now gNB----')
        now;
        if UE(i).now_gNB~=now
            old = UE(i).now_gNB;
            UE(i).now_gNB = now;
            UE(i).SINR = SINR(UE(i),now,gNB,noise);
            gNB = call_gNB2(gNB,old,UE(i),noise,UE,bw,2,value);%Remove UE
            UE(i).unicast = false;
            gNB = call_gNB2(gNB,now,UE(i),noise,UE,bw,1,value);%add UE
            if gNB(UE(i).now_gNB).saveMBS(1)==true
                UE(i).MBS = gNB(UE(i).now_gNB).saveMBS(2);
                gNB(UE(i).now_gNB).saveMBS = [false,0];
                %disp(UE(i))
            end
            if gNB(now).unicast_member(i) == true  
                UE(i).unicast = true;
            end
        else
            UE(i).SINR = SINR(UE(i),now,gNB,noise);
            if UE(i).SINR<value
                if gNB(now).unicast_member(i) == false
                    %disp('DROP OUT')
                    %disp(UE(i))
                    call_gNB2(gNB,UE(i).now_gNB,UE(i),noise,UE,bw,2,value)
                    call_gNB2(gNB,UE(i).now_gNB,UE(i),noise,UE,bw,1,value)
                end
            else
                if gNB(now).unicast_member(i) == true 
                    UE(i).SINR = SINR(UE(i),UE(i).now_gNB,gNB,noise);
                    gNB = call_gNB2(gNB,UE(i).now_gNB,UE(i),noise,UE,bw,5,value);
                    if gNB(UE(i).now_gNB).unicast_member(i) == false
                        UE(i).unicast = false;
                    end
                    if gNB(UE(i).now_gNB).saveMBS(1)==true
                        UE(i).MBS = gNB(UE(i).now_gNB).saveMBS(2);
                        gNB(UE(i).now_gNB).saveMBS = [false,0];
                        %disp(UE(i))
                    end
                end
            end
        end
    end
end
%Throughput
total = 0;
for i=1:7
    gNB(i).MBS
    for j=1:UE_num
        s = size(gNB(i).MBS);
        num = 0;
        for k=1:s(2)
            if gNB(i).MBS(j,k) ~= 0
                num = num+1;
            end
        end
        r = rate(10^(gNB(i).worstSINR(j)/10),bw); %Highest rate under channel capacity           
        if num ~= 0
                total = total+r*num;
        end
    end
end
count_uni = [];
for i=1:UE_num
    if UE(i).unicast() == true
        count_uni(end+1) = i;
    end
end
for i=1:length(count_uni)
    UE(count_uni(i)).SINR = SINR(UE(count_uni(i)),UE(count_uni(i)).now_gNB,gNB,noise);
    r = rate(10^(UE(count_uni(i)).SINR/10),bw);
    total = total+r;
end
%End loop


for i=1:UE_num
    pos = UE(i).pos;
    x2(i) = pos(1);
    y2(i) = pos(2);
    gnb = UE(i).now_gNB
end
figure(2)

c2 = gNB_color(UE);

scatter(x2,y2,[],c2)

for i=1:7
    gNB(i).MBS
end
total
toc