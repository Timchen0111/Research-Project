function sinr = SINR(UE,tgNB_num,gNB,noise) 
%UE:UE(struct),tgNB_num:num of tgNB(int),gNB:all of tgNB(array of struct gNB)
%noise(double),fading(random variable,parameter double)
tgNB = gNB(tgNB_num);

fc = 3;%frequency

for i=1:19
    distance(i) = norm(UE.pos-gNB(i).pos);
    pl(i) = 0;
end

for i=1:19
    result = pathloss(35,1.5,5,distance(i),fc); %Unit:db
    sigma = 4;
    fad = normrnd(0,sigma);
    pl(i) = fad-result; %pathloss, unit:db
    %disp('---------------')
    %disp(fad)
    
    %clear fad;
end
interference = 0;
for i=1:19
    if i ~= tgNB_num
        interference = interference+10^(pl(i)/10);
    end
end

Noise = 10^(noise/10);

sinr = pl(tgNB_num)-10*log10(interference+Noise); %db
%disp('sinr')
%disp(sinr)