function [temp_mask,temp_rn]=compare_outside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Width=120;  %行
Height=160; %列
delta=5;%矩形框的大小
depthDelta=-15;%靠近矩形框的点的深度值与平均深度值得差值
closeDelta=40;%相邻点的深度差值（种子点生长分割区域时）
                        rn=rn+5;
                        mask(u,v) = rn;
                        stack(1,1)=u;
                        stack(1,2)=v;
                        Start = 1;
                        End = 1;
                        while(Start<=End)
                            CurrX=stack(Start,1);
                            CurrY=stack(Start,2);
                            for m = -1:1
                                for n = -1:1
                                    %首先先判断是否符合边界条件，是否是为1的点，是否跟父点深度差满足阈值，再看看是那个象限的点
                                    if ((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((CurrX+m)<topLine) && ((CurrY+n)<leftLine)
                                        %判断为第一象限里的点
                                        if ((sqrt(((CurrX+m)-topLine)^2+((CurrY+n)-leftLine)^2)) <= delta )
                                            %在delta的范围里内
                                            if (subline(CurrX+m,CurrY+n)-ave_color)<depthDelta 
                                                %并且深度值减去平均值满足条件，则为满足条件可以标记颜色的点
                                                End = End+1;
                                                stack(End,1)=CurrX+m;
                                                stack(End,2)=CurrY+n;
                                                mask(CurrX+m,CurrY+n)=rn;
                                            %否则即为delta内的点，但是不满足深度值-平均值的条件，此时不标记
                                            end
                                        %在delta范围外的点，则这时候不用判断-平均深度值的条件，可以直接标记颜色    
                                        else
                                            End = End+1;
                                            stack(End,1)=CurrX+m;
                                            stack(End,2)=CurrY+n;
                                            mask(CurrX+m,CurrY+n)=rn;
                                        end
                                        
                                    elseif ((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((CurrX+m)<topLine) && ((CurrY+n)>=leftLine) &&  ((CurrY+n)<rightLine) 
                                        %判断为第二象限里的点
                                        if ((topLine-(CurrX+m)) <= delta )
                                            %在delta的范围里内
                                            if (subline(CurrX+m,CurrY+n)-ave_color)<depthDelta 
                                                %并且深度值减去平均值满足条件，则为满足条件可以标记颜色的点
                                                End = End+1;
                                                stack(End,1)=CurrX+m;
                                                stack(End,2)=CurrY+n;
                                                mask(CurrX+m,CurrY+n)=rn;
                                            %否则即为delta内的点，但是不满足深度值-平均值的条件，此时不标记
                                            end
                                        %在delta范围外的点，则这时候不用判断-平均深度值的条件，可以直接标记颜色    
                                        else
                                            End = End+1;
                                            stack(End,1)=CurrX+m;
                                            stack(End,2)=CurrY+n;
                                            mask(CurrX+m,CurrY+n)=rn;
                                        end
                                    elseif ((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((CurrX+m)<topLine) && ((CurrY+n)>=rightLine) 
                                        %判断为第3象限里的点
                                        if ((sqrt(((CurrX+m)-topLine)^2+((CurrY+n)-rightLine)^2)) <= delta )
                                            %在delta的范围里内
                                            if (subline(CurrX+m,CurrY+n)-ave_color)<depthDelta 
                                                %并且深度值减去平均值满足条件，则为满足条件可以标记颜色的点
                                                End = End+1;
                                                stack(End,1)=CurrX+m;
                                                stack(End,2)=CurrY+n;
                                                mask(CurrX+m,CurrY+n)=rn;
                                            %否则即为delta内的点，但是不满足深度值-平均值的条件，此时不标记
                                            end
                                        %在delta范围外的点，则这时候不用判断-平均深度值的条件，可以直接标记颜色    
                                        else
                                            End = End+1;
                                            stack(End,1)=CurrX+m;
                                            stack(End,2)=CurrY+n;
                                            mask(CurrX+m,CurrY+n)=rn;
                                        end
                                    elseif ((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((CurrX+m)>=topLine) && ((CurrY+n)<leftLine) && ((CurrX+m)<bottomLine)
                                        %判断为第4象限里的点
                                        if ((leftLine-(CurrY+n)) <= delta )
                                            %在delta的范围里内
                                            if (subline(CurrX+m,CurrY+n)-ave_color)<depthDelta 
                                                %并且深度值减去平均值满足条件，则为满足条件可以标记颜色的点
                                                End = End+1;
                                                stack(End,1)=CurrX+m;
                                                stack(End,2)=CurrY+n;
                                                mask(CurrX+m,CurrY+n)=rn;
                                            %否则即为delta内的点，但是不满足深度值-平均值的条件，此时不标记
                                            end
                                        %在delta范围外的点，则这时候不用判断-平均深度值的条件，可以直接标记颜色    
                                        else
                                            End = End+1;
                                            stack(End,1)=CurrX+m;
                                            stack(End,2)=CurrY+n;
                                            mask(CurrX+m,CurrY+n)=rn;
                                        end
                                    elseif ((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((CurrX+m)>=topLine) && ((CurrY+n)>=leftLine) && ((CurrX+m)<bottomLine) && ((CurrY+n)<rightLine)
                                        %判断为第5象限里的点
                                            End = End+1;
                                            stack(End,1)=CurrX+m;
                                            stack(End,2)=CurrY+n;
                                            mask(CurrX+m,CurrY+n)=rn;
                                    elseif ((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((CurrX+m)>=topLine) && ((CurrY+n)>=rightLine) && ((CurrX+m)<bottomLine)
                                        %判断为第6象限里的点
                                        if (((CurrY+n)-rightLine) <= delta )
                                            %在delta的范围里内
                                            if (subline(CurrX+m,CurrY+n)-ave_color)<depthDelta 
                                                %并且深度值减去平均值满足条件，则为满足条件可以标记颜色的点
                                                End = End+1;
                                                stack(End,1)=CurrX+m;
                                                stack(End,2)=CurrY+n;
                                                mask(CurrX+m,CurrY+n)=rn;
                                            %否则即为delta内的点，但是不满足深度值-平均值的条件，此时不标记
                                            end
                                        %在delta范围外的点，则这时候不用判断-平均深度值的条件，可以直接标记颜色    
                                        else
                                            End = End+1;
                                            stack(End,1)=CurrX+m;
                                            stack(End,2)=CurrY+n;
                                            mask(CurrX+m,CurrY+n)=rn;
                                        end
                                    elseif ((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((CurrX+m)>=bottomLine) && ((CurrY+n)<leftLine)
                                        %判断为第7象限里的点
                                        if ((sqrt(((CurrX+m)-bottomLine)^2+((CurrY+n)-leftLine)^2)) <= delta )
                                            %在delta的范围里内
                                            if (subline(CurrX+m,CurrY+n)-ave_color)<depthDelta 
                                                %并且深度值减去平均值满足条件，则为满足条件可以标记颜色的点
                                                End = End+1;
                                                stack(End,1)=CurrX+m;
                                                stack(End,2)=CurrY+n;
                                                mask(CurrX+m,CurrY+n)=rn;
                                            %否则即为delta内的点，但是不满足深度值-平均值的条件，此时不标记
                                            end
                                        %在delta范围外的点，则这时候不用判断-平均深度值的条件，可以直接标记颜色    
                                        else
                                            End = End+1;
                                            stack(End,1)=CurrX+m;
                                            stack(End,2)=CurrY+n;
                                            mask(CurrX+m,CurrY+n)=rn;
                                        end
                                    elseif ((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((CurrX+m)>=bottomLine) && ((CurrY+n)>=leftLine) &&  ((CurrY+n)<rightLine) 
                                        %判断为第8象限里的点
                                        if (((CurrX+m)-bottomLine) <= delta )
                                            %在delta的范围里内
                                            if (subline(CurrX+m,CurrY+n)-ave_color)<depthDelta 
                                                %并且深度值减去平均值满足条件，则为满足条件可以标记颜色的点
                                                End = End+1;
                                                stack(End,1)=CurrX+m;
                                                stack(End,2)=CurrY+n;
                                                mask(CurrX+m,CurrY+n)=rn;
                                            %否则即为delta内的点，但是不满足深度值-平均值的条件，此时不标记
                                            end
                                        %在delta范围外的点，则这时候不用判断-平均深度值的条件，可以直接标记颜色    
                                        else
                                            End = End+1;
                                            stack(End,1)=CurrX+m;
                                            stack(End,2)=CurrY+n;
                                            mask(CurrX+m,CurrY+n)=rn;
                                        end
                                    elseif ((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((CurrX+m)>=bottomLine) && ((CurrY+n)>=rightLine) 
                                        %判断为第9象限里的点
                                        if ((sqrt(((CurrX+m)-bottomLine)^2+((CurrY+n)-rightLine)^2)) <= delta )
                                            %在delta的范围里内
                                            if (subline(CurrX+m,CurrY+n)-ave_color)<depthDelta 
                                                %并且深度值减去平均值满足条件，则为满足条件可以标记颜色的点
                                                End = End+1;
                                                stack(End,1)=CurrX+m;
                                                stack(End,2)=CurrY+n;
                                                mask(CurrX+m,CurrY+n)=rn;
                                            %否则即为delta内的点，但是不满足深度值-平均值的条件，此时不标记
                                            end
                                        %在delta范围外的点，则这时候不用判断-平均深度值的条件，可以直接标记颜色    
                                        else
                                            End = End+1;
                                            stack(End,1)=CurrX+m;
                                            stack(End,2)=CurrY+n;
                                            mask(CurrX+m,CurrY+n)=rn;
                                        end
                                    else
                                        
                                    end%对应if elseif
 
                                end
                            end
                            Start=Start+1;
                        end
                       temp_mask=mask;
                       temp_rn=rn;
                        
end

