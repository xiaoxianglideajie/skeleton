function [temp_mask,temp_rn]=compare_outside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Width=120;  %��
Height=160; %��
delta=5;%���ο�Ĵ�С
depthDelta=-15;%�������ο�ĵ�����ֵ��ƽ�����ֵ�ò�ֵ
closeDelta=40;%���ڵ����Ȳ�ֵ�����ӵ������ָ�����ʱ��
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
                                    %�������ж��Ƿ���ϱ߽��������Ƿ���Ϊ1�ĵ㣬�Ƿ��������Ȳ�������ֵ���ٿ������Ǹ����޵ĵ�
                                    if ((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((CurrX+m)<topLine) && ((CurrY+n)<leftLine)
                                        %�ж�Ϊ��һ������ĵ�
                                        if ((sqrt(((CurrX+m)-topLine)^2+((CurrY+n)-leftLine)^2)) <= delta )
                                            %��delta�ķ�Χ����
                                            if (subline(CurrX+m,CurrY+n)-ave_color)<depthDelta 
                                                %�������ֵ��ȥƽ��ֵ������������Ϊ�����������Ա����ɫ�ĵ�
                                                End = End+1;
                                                stack(End,1)=CurrX+m;
                                                stack(End,2)=CurrY+n;
                                                mask(CurrX+m,CurrY+n)=rn;
                                            %����Ϊdelta�ڵĵ㣬���ǲ��������ֵ-ƽ��ֵ����������ʱ�����
                                            end
                                        %��delta��Χ��ĵ㣬����ʱ�����ж�-ƽ�����ֵ������������ֱ�ӱ����ɫ    
                                        else
                                            End = End+1;
                                            stack(End,1)=CurrX+m;
                                            stack(End,2)=CurrY+n;
                                            mask(CurrX+m,CurrY+n)=rn;
                                        end
                                        
                                    elseif ((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((CurrX+m)<topLine) && ((CurrY+n)>=leftLine) &&  ((CurrY+n)<rightLine) 
                                        %�ж�Ϊ�ڶ�������ĵ�
                                        if ((topLine-(CurrX+m)) <= delta )
                                            %��delta�ķ�Χ����
                                            if (subline(CurrX+m,CurrY+n)-ave_color)<depthDelta 
                                                %�������ֵ��ȥƽ��ֵ������������Ϊ�����������Ա����ɫ�ĵ�
                                                End = End+1;
                                                stack(End,1)=CurrX+m;
                                                stack(End,2)=CurrY+n;
                                                mask(CurrX+m,CurrY+n)=rn;
                                            %����Ϊdelta�ڵĵ㣬���ǲ��������ֵ-ƽ��ֵ����������ʱ�����
                                            end
                                        %��delta��Χ��ĵ㣬����ʱ�����ж�-ƽ�����ֵ������������ֱ�ӱ����ɫ    
                                        else
                                            End = End+1;
                                            stack(End,1)=CurrX+m;
                                            stack(End,2)=CurrY+n;
                                            mask(CurrX+m,CurrY+n)=rn;
                                        end
                                    elseif ((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((CurrX+m)<topLine) && ((CurrY+n)>=rightLine) 
                                        %�ж�Ϊ��3������ĵ�
                                        if ((sqrt(((CurrX+m)-topLine)^2+((CurrY+n)-rightLine)^2)) <= delta )
                                            %��delta�ķ�Χ����
                                            if (subline(CurrX+m,CurrY+n)-ave_color)<depthDelta 
                                                %�������ֵ��ȥƽ��ֵ������������Ϊ�����������Ա����ɫ�ĵ�
                                                End = End+1;
                                                stack(End,1)=CurrX+m;
                                                stack(End,2)=CurrY+n;
                                                mask(CurrX+m,CurrY+n)=rn;
                                            %����Ϊdelta�ڵĵ㣬���ǲ��������ֵ-ƽ��ֵ����������ʱ�����
                                            end
                                        %��delta��Χ��ĵ㣬����ʱ�����ж�-ƽ�����ֵ������������ֱ�ӱ����ɫ    
                                        else
                                            End = End+1;
                                            stack(End,1)=CurrX+m;
                                            stack(End,2)=CurrY+n;
                                            mask(CurrX+m,CurrY+n)=rn;
                                        end
                                    elseif ((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((CurrX+m)>=topLine) && ((CurrY+n)<leftLine) && ((CurrX+m)<bottomLine)
                                        %�ж�Ϊ��4������ĵ�
                                        if ((leftLine-(CurrY+n)) <= delta )
                                            %��delta�ķ�Χ����
                                            if (subline(CurrX+m,CurrY+n)-ave_color)<depthDelta 
                                                %�������ֵ��ȥƽ��ֵ������������Ϊ�����������Ա����ɫ�ĵ�
                                                End = End+1;
                                                stack(End,1)=CurrX+m;
                                                stack(End,2)=CurrY+n;
                                                mask(CurrX+m,CurrY+n)=rn;
                                            %����Ϊdelta�ڵĵ㣬���ǲ��������ֵ-ƽ��ֵ����������ʱ�����
                                            end
                                        %��delta��Χ��ĵ㣬����ʱ�����ж�-ƽ�����ֵ������������ֱ�ӱ����ɫ    
                                        else
                                            End = End+1;
                                            stack(End,1)=CurrX+m;
                                            stack(End,2)=CurrY+n;
                                            mask(CurrX+m,CurrY+n)=rn;
                                        end
                                    elseif ((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((CurrX+m)>=topLine) && ((CurrY+n)>=leftLine) && ((CurrX+m)<bottomLine) && ((CurrY+n)<rightLine)
                                        %�ж�Ϊ��5������ĵ�
                                            End = End+1;
                                            stack(End,1)=CurrX+m;
                                            stack(End,2)=CurrY+n;
                                            mask(CurrX+m,CurrY+n)=rn;
                                    elseif ((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((CurrX+m)>=topLine) && ((CurrY+n)>=rightLine) && ((CurrX+m)<bottomLine)
                                        %�ж�Ϊ��6������ĵ�
                                        if (((CurrY+n)-rightLine) <= delta )
                                            %��delta�ķ�Χ����
                                            if (subline(CurrX+m,CurrY+n)-ave_color)<depthDelta 
                                                %�������ֵ��ȥƽ��ֵ������������Ϊ�����������Ա����ɫ�ĵ�
                                                End = End+1;
                                                stack(End,1)=CurrX+m;
                                                stack(End,2)=CurrY+n;
                                                mask(CurrX+m,CurrY+n)=rn;
                                            %����Ϊdelta�ڵĵ㣬���ǲ��������ֵ-ƽ��ֵ����������ʱ�����
                                            end
                                        %��delta��Χ��ĵ㣬����ʱ�����ж�-ƽ�����ֵ������������ֱ�ӱ����ɫ    
                                        else
                                            End = End+1;
                                            stack(End,1)=CurrX+m;
                                            stack(End,2)=CurrY+n;
                                            mask(CurrX+m,CurrY+n)=rn;
                                        end
                                    elseif ((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((CurrX+m)>=bottomLine) && ((CurrY+n)<leftLine)
                                        %�ж�Ϊ��7������ĵ�
                                        if ((sqrt(((CurrX+m)-bottomLine)^2+((CurrY+n)-leftLine)^2)) <= delta )
                                            %��delta�ķ�Χ����
                                            if (subline(CurrX+m,CurrY+n)-ave_color)<depthDelta 
                                                %�������ֵ��ȥƽ��ֵ������������Ϊ�����������Ա����ɫ�ĵ�
                                                End = End+1;
                                                stack(End,1)=CurrX+m;
                                                stack(End,2)=CurrY+n;
                                                mask(CurrX+m,CurrY+n)=rn;
                                            %����Ϊdelta�ڵĵ㣬���ǲ��������ֵ-ƽ��ֵ����������ʱ�����
                                            end
                                        %��delta��Χ��ĵ㣬����ʱ�����ж�-ƽ�����ֵ������������ֱ�ӱ����ɫ    
                                        else
                                            End = End+1;
                                            stack(End,1)=CurrX+m;
                                            stack(End,2)=CurrY+n;
                                            mask(CurrX+m,CurrY+n)=rn;
                                        end
                                    elseif ((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((CurrX+m)>=bottomLine) && ((CurrY+n)>=leftLine) &&  ((CurrY+n)<rightLine) 
                                        %�ж�Ϊ��8������ĵ�
                                        if (((CurrX+m)-bottomLine) <= delta )
                                            %��delta�ķ�Χ����
                                            if (subline(CurrX+m,CurrY+n)-ave_color)<depthDelta 
                                                %�������ֵ��ȥƽ��ֵ������������Ϊ�����������Ա����ɫ�ĵ�
                                                End = End+1;
                                                stack(End,1)=CurrX+m;
                                                stack(End,2)=CurrY+n;
                                                mask(CurrX+m,CurrY+n)=rn;
                                            %����Ϊdelta�ڵĵ㣬���ǲ��������ֵ-ƽ��ֵ����������ʱ�����
                                            end
                                        %��delta��Χ��ĵ㣬����ʱ�����ж�-ƽ�����ֵ������������ֱ�ӱ����ɫ    
                                        else
                                            End = End+1;
                                            stack(End,1)=CurrX+m;
                                            stack(End,2)=CurrY+n;
                                            mask(CurrX+m,CurrY+n)=rn;
                                        end
                                    elseif ((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((CurrX+m)>=bottomLine) && ((CurrY+n)>=rightLine) 
                                        %�ж�Ϊ��9������ĵ�
                                        if ((sqrt(((CurrX+m)-bottomLine)^2+((CurrY+n)-rightLine)^2)) <= delta )
                                            %��delta�ķ�Χ����
                                            if (subline(CurrX+m,CurrY+n)-ave_color)<depthDelta 
                                                %�������ֵ��ȥƽ��ֵ������������Ϊ�����������Ա����ɫ�ĵ�
                                                End = End+1;
                                                stack(End,1)=CurrX+m;
                                                stack(End,2)=CurrY+n;
                                                mask(CurrX+m,CurrY+n)=rn;
                                            %����Ϊdelta�ڵĵ㣬���ǲ��������ֵ-ƽ��ֵ����������ʱ�����
                                            end
                                        %��delta��Χ��ĵ㣬����ʱ�����ж�-ƽ�����ֵ������������ֱ�ӱ����ɫ    
                                        else
                                            End = End+1;
                                            stack(End,1)=CurrX+m;
                                            stack(End,2)=CurrY+n;
                                            mask(CurrX+m,CurrY+n)=rn;
                                        end
                                    else
                                        
                                    end%��Ӧif elseif
 
                                end
                            end
                            Start=Start+1;
                        end
                       temp_mask=mask;
                       temp_rn=rn;
                        
end

