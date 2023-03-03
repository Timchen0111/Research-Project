function c = gNB_color(UE)
    c=[length(UE),0,0];
    for i=1:length(UE)
        switch UE(i).now_gNB
            case(1)
                c(i,:) = [1 0 0]; %red
            case(2)
                c(i,:) = [0 1 0]; %green
            case(3)
                c(i,:) = [0 0 1]; %blue
            case(4)
                c(i,:) = [0 1 1]; %light blue
            case(5)
                c(i,:) = [1 0 1]; %pink
            case(6)
                c(i,:) = [0.4940 0.1840 0.5560]; %purple
            case(7)
                c(i,:) = [1 1 0]; %yellow
            otherwise
                error('Wrong gNB')
        end
    end