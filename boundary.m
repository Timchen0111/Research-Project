function judge = boundary(x,y)
if y>100*sqrt(3) || y<-100*sqrt(3)
    judge = false;
else
    if x<100 && x>-100
        judge = true;
    else
        if x<-100
            if y<sqrt(3)*x+200*sqrt(3) && y>-sqrt(3)*x-200*sqrt(3)
                judge = true;
            else
                judge = false;
            end
        else
            if y<-sqrt(3)*x+200*sqrt(3) && y>sqrt(3)*x-200*sqrt(3)
                judge = true;
            else
                judge = false;
            end
        end
    end
end
