function g = call_gNB(gNB,tgNB_num,UE,noise,allUE,bw,command,value,multi)
    g = gNB;
    %In future, unicast may be change to SFN!
    if command == 1 %add UE 
            %disp('ADD UE')
            UE.num;
            
            if UE.unicast == true
                disp(UE.num)
                error('Wrong added')
            end
            l = length(g(tgNB_num).joinUE);
            g(tgNB_num).joinUE(l+1) = UE.num;
            if UE.SINR>value
                g = call_gNB(g,tgNB_num,UE,noise,allUE,bw,3,value,multi);%Add MBS
                g(tgNB_num).unicast_member(UE.num) = false;        
            else
                disp('ENTER UNICAST:')
                UE.num;
                g(tgNB_num).saveMBS = [true,-1];
                g(tgNB_num).unicast_member(UE.num) = true;
            end
    end
    if command == 2
            %disp('REMOVE UE')
            UE.num;
            index = find(g(tgNB_num).joinUE==UE.num);
            if isempty(index) == false 
                g(tgNB_num).joinUE(index) = [];
            else
                error('Nothing to remove')
            end
            if UE.MBS ~= -1
                g = call_gNB(gNB,tgNB_num,UE,noise,allUE,bw,4,value,multi);%Remove MBS
            end
    end
    if command == 3
            %disp('ADD MBS')
            insert = false;
            i=1;
            UE.MBS = assignMBS(g,UE,tgNB_num,bw,multi);
            while insert == false
                s = size(g(tgNB_num).MBS);
                if i>s(2)
                    g(tgNB_num).MBS(UE.MBS,end+1) = UE.num;
                    insert = true;                
                else                    
                    if g(tgNB_num).MBS(UE.MBS,i) == UE.num
                        disp(UE.unicast)
                        disp(g(tgNB_num).MBS)
                        error('Repeat MBS Member.')
                    end
                    
                    if g(tgNB_num).MBS(UE.MBS,i) == 0
                        g(tgNB_num).MBS(UE.MBS,i) = UE.num;
                        insert = true;
                    end
                end
                i=i+1;
            end
            g(tgNB_num).saveMBS = [true,UE.MBS];
            clear insert
            sinr = SINR(UE,tgNB_num,g,noise);
            if sinr<g(tgNB_num).worstSINR(UE.MBS)
                g(tgNB_num).worstSINR(UE.MBS) = sinr;
            end
            
    end
    if command == 4
            rmbs = false;
            s = size(g(tgNB_num).MBS,2);
            for i=1:s
                if g(tgNB_num).MBS(UE.MBS,i) == UE.num 
                    %disp('REMOVE MBS')
                    rmbs = true;
                    g(tgNB_num).MBS(UE.MBS,i)=0;
                end
            end
            if rmbs == true
                %disp('REMOVE WORST SINR')
                g(tgNB_num).worstSINR(UE.MBS) = inf;
                for i = 1:s
                    UEnow = g(tgNB_num).MBS(UE.MBS,i);
                    if UEnow ~= 0
                        each_sinr = SINR(allUE(UEnow),tgNB_num,g,noise);
                        if each_sinr<g(tgNB_num).worstSINR(UE.MBS)
                            g(tgNB_num).worstSINR(UE.MBS) = each_sinr;
                        end
                    end
                end
            else
                disp(UE)
                error('Remove failed!')
            end
    end

    if command == 5
            %disp('IN UNICAST')
            %UE.num
            if UE.SINR>value
                index = find(g(tgNB_num).unicast_member == UE.num);                
                g(tgNB_num).unicast_member(UE.num) = false; %remove the record in unicast
                g = call_gNB(g,tgNB_num,UE,noise,allUE,bw,3,value,multi);
                %disp('LEAVE UNICAST')
                %UE.num
            else
                g(tgNB_num).unicast_member(UE.num) = true;
            end
    end
    


    

