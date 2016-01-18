clc;
clearvars -EXCEPT 'data_all';
close all;

format long;
%%
if (exist('data_all') == 0)
    load('data_all.mat');
end
%%
Width=120;  %��
Height=160; %��
delta=7;%���ο�Ĵ�С��Բ�İ뾶
bigCircleDelta = 23;%��Բ�İ뾶
depthDelta=-15;%�������ο�ĵ�����ֵ��ƽ�����ֵ�ò�ֵ-15
littleCircleDepthDelta=-5;%СԲ��Ȳ�
bigCircleDepthDelta=-500;%��Բ��Ȳ�
closeDelta=30;%���ڵ����Ȳ�ֵ�����ӵ������ָ�����ʱ��
% closeDeltaCircle1=35;
% closeDeltaCircle2=35;
% closeDeltaCircle3=35;
% closeDeltaCircle4=35;
% closeDeltaCircle5=35;
% closeDeltaCircle6=35;


%% ��Ƶ¼��
% bSaveAVI = 1;
% if bSaveAVI
%     WriterObj=VideoWriter(strcat(datestr(now,'yyyy-mm-dd-HH-MM-SS'),'.avi'));
%     WriterObj.FrameRate=5;
%     open(WriterObj);
% end
%% 
for i =  115: 116%size(data_all, 1)
    %mask  = data_all{i, 1}.mask;
    %depth = data_all{i, 1}.depth;
%% ��ʼ��
    subline=zeros(Width,Height);
    mask=zeros(Width,Height);
    c = mat2cell(data_all{i,1}.depth,2*ones(1,Width),2*ones(1,Height));%���ͼ����Ϊ2*2
    d = mat2cell(data_all{i,1}.mask,2*ones(1,Width),2*ones(1,Height));%mask����Ϊ2*2
%% ����2*2������ȵ���Чƽ��ֵ
   for a = 1:Width
       for b =1:Height
             if(numel(find(c{a,b}~=0))==0)
             subline(a,b) = 0;
             else
             subline(a,b) = sum(sum(c{a,b}))/numel(find(c{a,b}~=0));
             end
       end
   end
%% ����2*2����mask����Чƽ��ֵ,��ʵ����1
    for a = 1:Width
       for b =1:Height
             if(numel(find(d{a,b}~=0))==0)
             mask(a,b) = 0;
             else
             mask(a,b) = sum(sum(d{a,b}))/numel(find(d{a,b}~=0));
             end
       end
   end
%% ����һ���궨��mask    
    LabelImage=mask;
%% ������������ϣ����£��������ҵ�λ��
%      subline=depth;
%      [fd7_x,fd7_y]=find(LabelImage==1);
%      fd_top=min(fd7_x);
%      fd_bottom=max(fd7_x);
%      fd_left=min(fd7_y);
%      fd_right=max(fd7_y);
%      delta1=floor((fd_bottom-fd_top)*0.2);%ȡ���±߽��10%
%      delta2=floor((fd_right-fd_left)*0.1);%ȡ���ұ߽��10%
%% ͳ��    
    sumcol=sum(LabelImage);
    sumrow=sum(LabelImage,2);
    sumall=sum(sumcol);
%% ��߽�
    sumTemp=0;
    for f = 1:Height
          sumTemp=sumTemp+sumcol(1,f);
          if sumTemp>sumall*0.15
                leftLine=f;
                break;
          end    
    end 
%% �ұ߽�
    sumTemp=0;
    for f = 1:Height
          sumTemp=sumTemp+sumcol(1,Height-f+1);
          if sumTemp>sumall*0.15
                rightLine=Height-f;
                break;
          end    
    end
%% �ϱ߽�
    sumTemp=0;
    for f = 1:Width
          sumTemp=sumTemp+sumrow(f,1);
          if sumTemp>sumall*0.15
              if LabelImage(f,leftLine)~=0 && LabelImage(f,rightLine)~=0
                topLine=f;
                break;
              end
          end    
    end
%% �±߽�
    sumTemp=0;
    for f = 1:Width
          sumTemp=sumTemp+sumrow(Width-f+1,1);
          if sumTemp>sumall*0.10
                bottomLine=Width-f;
                break;
          end    
    end

%% ������ο�����ƽ��ֵ
%     sumDepth=0;         
%     for f = topLine:bottomLine 
%       for g = leftLine:rightLine 
%         %LabelImage1(f,g)=0;
%         sumDepth=double(sumDepth)+double(subline(f,g));%��ֹ���
%       end
%     end
%     aveDepth=sumDepth/(bottomLine-topLine)/(rightLine-leftLine);%������������ƽ�����
 
    
%% ������ο���ȵ���ֵ
%     for f = 1:(bottomLine-topLine+1) 
%       for g = 1:(rightLine-leftLine+1) 
%         %LabelImage1(f,g)=0;
%         targetArea(f,g)=subline(f+topLine-1,g+leftLine-1);
%       end
%     end
%     middleDepth=median(targetArea(:));

%% ������ο������
%     for f = topLine-10:bottomLine 
%       for g = leftLine-5:rightLine+5 
%         if subline(f,g)-middleDepth>-10
%           LabelImage(f,g)=0;
%         else 
%           LabelImage(f,g)=1;
%         end
%       end
%     end

%% �м������ӵ�����
    LabelImage=zeros(Width,Height);
    rn=0;
    for u = topLine:bottomLine 
     for v = leftLine:rightLine 
        if LabelImage(u,v)==0 %&& abs(subline(u,v)-aveDepth)>250%225
            rn=rn+1;
            LabelImage(u,v) = rn;
            stack(1,1)=u;
            stack(1,2)=v;
            Start = 1;
            End = 1;
            while(Start<=End)
                    CurrX=stack(Start,1);
                    CurrY=stack(Start,2);
                    for m = -1:1
                        for n = -1:1
                            if ((CurrX+m)<=bottomLine&&(CurrX+m)>=(topLine)&&(CurrY+n)<=(rightLine)&&(CurrY+n)>=(leftLine)&&(LabelImage(CurrX+m,CurrY+n) == 0) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<10)
                                End = End+1;
                                stack(End,1)=CurrX+m;
                                stack(End,2)=CurrY+n;
                                LabelImage(CurrX+m,CurrY+n)=rn;
                            end
                        
                        end
                    end
                    Start=Start+1;
            end
        end
     end
    end

%% ����ο��������ƽ�����ֵ
    targetArea=zeros(bottomLine-topLine+1,rightLine-leftLine+1);
    for f = 1:(bottomLine-topLine+1) 
      for g = 1:(rightLine-leftLine+1) 
        %LabelImage1(f,g)=0;
        targetArea(f,g)=LabelImage(f+topLine-1,g+leftLine-1);
      end
    end
    mostNum=sortrows(tabulate(targetArea(:)),-2);%���ڶ��еĽ�������
    mostColor=mostNum(1,1);
    [color_x,color_y]=find(LabelImage==mostColor);
    sum_color=0;
    for e=1:length(color_x) 
        sum_color=double(sum_color)+double(subline(color_x(e),color_y(e)));
       % LabelImage(color_x(e),color_y(e))=50;
    end
    ave_color=sum_color/length(color_x);%���ο�����������ƽ��ֵ
    

%% ���ο�Ȧ���ֵ�λ��    
    for p =1:rn
        [tempX,tempY]=find(LabelImage==p);
        tempSum=0;
        for o = 1:length(tempX)
        tempSum=double(tempSum)+double(subline(tempX(o),tempY(o)));
        end
        tempAve=tempSum/length(tempX);
        if (tempAve-ave_color)<-10%%%%%-40
            for o = 1:length(tempX)
                mask(tempX(o),tempY(o))=1;
            end
        else
            for o = 1:length(tempX)
                mask(tempX(o),tempY(o))=0;
            end
        end
    end
    
%% ����һ������������
%     rn=1;
%     for u = 1:Width 
%      for v = 1:Height 
%         if mask(u,v)==1 %&& abs(subline(u,v)-aveDepth)>250%225
%             rn=rn+5;
%             mask(u,v) = rn;
%             stack(1,1)=u;
%             stack(1,2)=v;
%             Start = 1;
%             End = 1;
%             while(Start<=End)
%                     CurrX=stack(Start,1);
%                     CurrY=stack(Start,2);
%                     for m = -1:1
%                         for n = -1:1
%                             if ((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta
%                                 End = End+1;
%                                 stack(End,1)=CurrX+m;
%                                 stack(End,2)=CurrY+n;
%                                 mask(CurrX+m,CurrY+n)=rn;
%                             end
%                         
%                         end
%                     end
%                     Start=Start+1;
%             end
%         end
%      end
%     end
    


%% ����2�粿Բ�ķ���
    rn=1;
    for u = 1:Width
        for v = 1:Height 
            if mask(u,v)==1                
                
                if (u>=topLine && v>=leftLine && u<=bottomLine && v<=rightLine)
                    %����5
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
                                circle1=((sqrt(((CurrX+m)-topLine)^2+((CurrY+n)-leftLine)^2)) <= (delta-2));
                                circle15=((sqrt(((CurrX+m)-topLine)^2+((CurrY+n)-leftLine-7)^2)) <= (delta));
                                circle2= ((sqrt(((CurrX+m)-topLine)^2+((CurrY+n)-rightLine)^2)) <= (delta-2));
                                circle3=((sqrt(((CurrX+m)-(topLine+bottomLine)/2)^2+((CurrY+n)-rightLine)^2)) <= (delta));
                                circle4=((sqrt(((CurrX+m)-(topLine+bottomLine)/2)^2+((CurrY+n)-leftLine)^2)) <= (delta-2));
                                circle5=((sqrt(((CurrX+m)-((topLine+bottomLine)/2-10))^2+((CurrY+n)-rightLine)^2)) <= delta);
                                circle6=((sqrt(((CurrX+m)-((topLine+bottomLine)/2-10))^2+((CurrY+n)-leftLine)^2)) <= delta);
                                circle7=((sqrt(((CurrX+m)-((topLine+bottomLine)/2-20))^2+((CurrY+n)-rightLine)^2)) <= delta);
                                circle8=((sqrt(((CurrX+m)-((topLine+bottomLine)/2-20))^2+((CurrY+n)-leftLine)^2)) <= delta);
                               circle11=((sqrt(((CurrX+m)-((topLine+bottomLine)/2+10))^2+((CurrY+n)-rightLine)^2)) <= (delta+3));%�����10��Ӧ
                               circle10=((sqrt(((CurrX+m)-((topLine+bottomLine)/2+10))^2+((CurrY+n)-leftLine)^2)) <= (delta+3));
                               circle12=((sqrt(((CurrX+m)-((topLine+bottomLine)/2+20))^2+((CurrY+n)-rightLine)^2)) <= (delta+3));%�����10��Ӧ
                               circle13=((sqrt(((CurrX+m)-((topLine+bottomLine)/2+20))^2+((CurrY+n)-leftLine)^2)) <= (delta+3));
                                circle14=((sqrt(((CurrX+m)-bottomLine)^2+((CurrY+n)-(rightLine+leftLine)/2)^2)) <= bigCircleDelta);
                                baserule=((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta;
                                %һֱ������5���������
                                if  baserule && ((CurrX+m)>=topLine && (CurrY+n)>=leftLine && (CurrX+m)<=bottomLine && (CurrY+n)<=rightLine)
                                    End = End+1;
                                    stack(End,1)=CurrX+m;
                                    stack(End,2)=CurrY+n;
                                    mask(CurrX+m,CurrY+n)=rn;
                                %����������5����������    
                                elseif baserule
                                    %�����������5���Բ��
                                    %if (((sqrt(((CurrX+m)-topLine)^2+((CurrY+n)-leftLine)^2)) <= delta) || ((sqrt(((CurrX+m)-topLine)^2+((CurrY+n)-rightLine)^2)) <= delta) || ((sqrt(((CurrX+m)-(topLine+bottomLine)/2)^2+((CurrY+n)-rightLine)^2)) <= delta) || ((sqrt(((CurrX+m)-(topLine+bottomLine)/2)^2+((CurrY+n)-leftLine)^2)) <= delta))%����Բ��
                                    if circle1 || circle2 || circle3 || circle4 || circle5 || circle6|| circle7 || circle8 || circle10 || circle11 || circle12 || circle13 || circle14 || circle15
                                        if circle14
                                            depthDelta=bigCircleDepthDelta;
                                        else
                                            depthDelta=littleCircleDepthDelta;
                                        end
                                        
                                        if (subline(CurrX+m,CurrY+n)-ave_color)<depthDelta 
                                            End = End+1;
                                            stack(End,1)=CurrX+m;
                                            stack(End,2)=CurrY+n;
                                            mask(CurrX+m,CurrY+n)=rn;
                                        end
                                    %������5���Բ��
                                    else
                                            End = End+1;
                                            stack(End,1)=CurrX+m;
                                            stack(End,2)=CurrY+n;
                                            mask(CurrX+m,CurrY+n)=rn;
                                    end
                                end   
                            end
                        end
                        Start=Start+1;
                    end
                else %��5����������
                    Circle1=((sqrt((u-topLine)^2+(v-leftLine)^2)) <= (delta-2)) ;
                    Circle15=((sqrt((u-topLine)^2+(v-leftLine-7)^2)) <= (delta)) ;
                    Circle2=((sqrt((u-topLine)^2+(v-rightLine)^2)) <= (delta-2));
                    Circle3=((sqrt((u-(topLine+bottomLine)/2)^2+(v-rightLine)^2)) <= (delta));
                    Circle4=((sqrt((u-(topLine+bottomLine)/2)^2+(v-leftLine)^2)) <= (delta-2));
                    Circle5=((sqrt((u-((topLine+bottomLine)/2-10))^2+(v-rightLine)^2)) <= delta);
                    Circle6=((sqrt((u-((topLine+bottomLine)/2-10))^2+(v-leftLine)^2)) <= delta);
                    Circle7=((sqrt((u-((topLine+bottomLine)/2-20))^2+(v-rightLine)^2)) <= delta);
                    Circle8=((sqrt((u-((topLine+bottomLine)/2-20))^2+(v-leftLine)^2)) <= delta);
                    
                     Circle11=((sqrt((u-((topLine+bottomLine)/2+10))^2+(v-rightLine)^2)) <= (delta+3));
                     Circle10=((sqrt((u-((topLine+bottomLine)/2+10))^2+(v-leftLine)^2)) <= (delta+3));
                     Circle12=((sqrt((u-((topLine+bottomLine)/2+20))^2+(v-rightLine)^2)) <= (delta+3));
                     Circle13=((sqrt((u-((topLine+bottomLine)/2+20))^2+(v-leftLine)^2)) <= (delta+3));
                     Circle14=((sqrt((u-bottomLine)^2+(v-(rightLine+leftLine)/2)^2)) <= bigCircleDelta);
                    if Circle1 || Circle2 || Circle3 || Circle4 || Circle5 || Circle6|| Circle7 || Circle8|| Circle10 ||Circle11 || Circle12 || Circle13 || Circle14 || Circle15
                    %if (((sqrt((u-topLine)^2+(v-leftLine)^2)) <= delta) || ((sqrt((u-topLine)^2+(v-rightLine)^2)) <= delta) || ((sqrt((u-(topLine+bottomLine)/2)^2+(v-rightLine)^2)) <= delta) || ((sqrt((u-(topLine+bottomLine)/2)^2+(v-leftLine)^2)) <= delta))%����Բ��
                    %������5���Բ��
                        if Circle14
                            depthDelta=bigCircleDepthDelta;
                        else
                            depthDelta=littleCircleDepthDelta;
                        end
                        if (subline(u,v)-ave_color)<depthDelta 
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
                                   
                                   circle1=((sqrt(((CurrX+m)-topLine)^2+((CurrY+n)-leftLine)^2)) <= (delta-2));
                                   circle15=((sqrt(((CurrX+m)-topLine)^2+((CurrY+n)-leftLine-7)^2)) <= (delta));
                                   circle2=((sqrt(((CurrX+m)-topLine)^2+((CurrY+n)-rightLine)^2)) <= (delta-2));
                                   circle3=((sqrt(((CurrX+m)-(topLine+bottomLine)/2)^2+((CurrY+n)-leftLine)^2)) <= (delta));
                                   circle4=((sqrt(((CurrX+m)-(topLine+bottomLine)/2)^2+((CurrY+n)-rightLine)^2)) <= (delta-2));
                                   circle5=((sqrt(((CurrX+m)-((topLine+bottomLine)/2-10))^2+((CurrY+n)-leftLine)^2)) <= delta);
                                   circle6=((sqrt(((CurrX+m)-((topLine+bottomLine)/2-10))^2+((CurrY+n)-rightLine)^2)) <= delta);
                                   circle7=((sqrt(((CurrX+m)-((topLine+bottomLine)/2-20))^2+((CurrY+n)-leftLine)^2)) <= delta);
                                   circle8=((sqrt(((CurrX+m)-((topLine+bottomLine)/2-20))^2+((CurrY+n)-rightLine)^2)) <= delta);
%                                    circle9=((sqrt(((CurrX+m)-bottomLine)^2+((CurrY+n)-(leftLine+rightLine)/2)^2)) <= bigCircleDelta);
                                    circle10=((sqrt(((CurrX+m)-((topLine+bottomLine)/2+10))^2+((CurrY+n)-rightLine)^2)) <= (delta+3));
                                    circle11=((sqrt(((CurrX+m)-((topLine+bottomLine)/2+10))^2+((CurrY+n)-leftLine)^2)) <= (delta+3));
                                    circle12=((sqrt(((CurrX+m)-((topLine+bottomLine)/2+20))^2+((CurrY+n)-rightLine)^2)) <= (delta+3));
                                    circle13=((sqrt(((CurrX+m)-((topLine+bottomLine)/2+20))^2+((CurrY+n)-leftLine)^2)) <= (delta+3));
                                    circle14=((sqrt(((CurrX+m)-bottomLine)^2+((CurrY+n)-(leftLine+rightLine)/2)^2)) <= bigCircleDelta);
                                   baserule=(((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta); 
                                   if baserule &&  ((CurrX+m)>=topLine && (CurrY+n)>=leftLine && (CurrX+m)<=bottomLine && (CurrY+n)<=rightLine)
                                   %�����ӵ�����������5ȥ
                                        End = End+1;
                                        stack(End,1)=CurrX+m;
                                        stack(End,2)=CurrY+n;
                                        mask(CurrX+m,CurrY+n)=rn;
                                   %�޸ĵ���
                                   

                                   elseif (baserule&&circle1)||(baserule&&circle2)||(baserule&&circle3)||(baserule&&circle4)||(baserule&&circle5)||(baserule&&circle6)||(baserule&&circle7)||(baserule&&circle8)||(baserule&&circle10)||(baserule&&circle11) ||(baserule&&circle12)||(baserule&&circle13) ||(baserule&&circle14)||(baserule&&circle15)
                                   %elseif (((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((sqrt(((CurrX+m)-topLine)^2+((CurrY+n)-leftLine)^2)) <= delta)) || (((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((sqrt(((CurrX+m)-topLine)^2+((CurrY+n)-rightLine)^2)) <= delta)) || (((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((sqrt(((CurrX+m)-(topLine+bottomLine)/2)^2+((CurrY+n)-rightLine)^2)) <= delta))|| (((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((sqrt(((CurrX+m)-(topLine+bottomLine)/2)^2+((CurrY+n)-leftLine)^2)) <= delta))
                                   %������������5���Բ������
                                           if circle14
                                                depthDelta=bigCircleDepthDelta;
                                           else
                                                depthDelta=littleCircleDepthDelta;
                                           end
                                           if (subline(CurrX+m,CurrY+n)-ave_color)<depthDelta 
                                                End = End+1;
                                                stack(End,1)=CurrX+m;
                                                stack(End,2)=CurrY+n;
                                                mask(CurrX+m,CurrY+n)=rn;
                                           end
                                   elseif baserule        
                                   %elseif ((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta
                                   %�����ӵ�������5���Բ������
                                            End = End+1;
                                            stack(End,1)=CurrX+m;
                                            stack(End,2)=CurrY+n;
                                            mask(CurrX+m,CurrY+n)=rn;
                                    
                                   else
                                       
                                   end%��Ӧif elseif
                        
                                   end
                                end
                                Start=Start+1;
                            end
                        else
                            mask(u,v) = 0;
                        end
                    else %5�������Բ��
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
                                                                        
                                    circle1=((sqrt(((CurrX+m)-topLine)^2+((CurrY+n)-leftLine)^2)) <= (delta-2));
                                    circle15=((sqrt(((CurrX+m)-topLine)^2+((CurrY+n)-leftLine-7)^2)) <= (delta));
                                    circle2=((sqrt(((CurrX+m)-topLine)^2+((CurrY+n)-rightLine)^2)) <= (delta-2));
                                    circle3=((sqrt(((CurrX+m)-(topLine+bottomLine)/2)^2+((CurrY+n)-leftLine)^2)) <= (delta));
                                    circle4=((sqrt(((CurrX+m)-(topLine+bottomLine)/2)^2+((CurrY+n)-rightLine)^2)) <= (delta-2));
                                    circle5=((sqrt(((CurrX+m)-((topLine+bottomLine)/2-10))^2+((CurrY+n)-leftLine)^2)) <= delta);
                                    circle6=((sqrt(((CurrX+m)-((topLine+bottomLine)/2-10))^2+((CurrY+n)-rightLine)^2)) <= delta);
                                    circle7=((sqrt(((CurrX+m)-((topLine+bottomLine)/2-20))^2+((CurrY+n)-leftLine)^2)) <= delta);
                                    circle8=((sqrt(((CurrX+m)-((topLine+bottomLine)/2-20))^2+((CurrY+n)-rightLine)^2)) <= delta);
%                                     circle9=((sqrt(((CurrX+m)-bottomLine)^2+((CurrY+n)-(leftLine+rightLine)/2)^2)) <= bigCircleDelta);
                                     circle11=((sqrt(((CurrX+m)-((topLine+bottomLine)/2+10))^2+((CurrY+n)-leftLine)^2)) <= (delta+3));
                                     circle10=((sqrt(((CurrX+m)-((topLine+bottomLine)/2+10))^2+((CurrY+n)-rightLine)^2)) <= (delta+3));
                                     circle12=((sqrt(((CurrX+m)-((topLine+bottomLine)/2+20))^2+((CurrY+n)-leftLine)^2)) <= (delta+3));
                                     circle13=((sqrt(((CurrX+m)-((topLine+bottomLine)/2+20))^2+((CurrY+n)-rightLine)^2)) <= (delta+3));
                                     circle14=((sqrt(((CurrX+m)-bottomLine)^2+((CurrY+n)-(leftLine+rightLine)/2)^2)) <= bigCircleDelta);
                                    baserule=(((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta); 
                                    if baserule &&  ((CurrX+m)>=topLine && (CurrY+n)>=leftLine && (CurrX+m)<=bottomLine && (CurrY+n)<=rightLine)
                                        %�����ӵ�����������5
                                        End = End+1;
                                        stack(End,1)=CurrX+m;
                                        stack(End,2)=CurrY+n;
                                        mask(CurrX+m,CurrY+n)=rn;

                                    elseif (baserule&&circle1)||(baserule&&circle2)||(baserule&&circle3)||(baserule&&circle4)||(baserule&&circle5)||(baserule&&circle6)||(baserule&&circle7)||(baserule&&circle8)||(baserule&&circle10)||(baserule&&circle11) ||(baserule&&circle12)||(baserule&&circle13) ||(baserule&&circle14)||(baserule&&circle15)    
                                    %elseif (((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((sqrt(((CurrX+m)-topLine)^2+((CurrY+n)-leftLine)^2)) <= delta)) || (((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((sqrt(((CurrX+m)-topLine)^2+((CurrY+n)-rightLine)^2)) <= delta))|| (((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((sqrt(((CurrX+m)-(topLine+bottomLine)/2)^2+((CurrY+n)-rightLine)^2)) <= delta))|| (((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((sqrt(((CurrX+m)-(topLine+bottomLine)/2)^2+((CurrY+n)-leftLine)^2)) <= delta))
                                            %�����ӵ�������Բ��
                                            if circle14
                                                depthDelta=bigCircleDepthDelta;
                                            else
                                                depthDelta=littleCircleDepthDelta;
                                            end
                                            if (subline(CurrX+m,CurrY+n)-ave_color)<depthDelta 
                                                End = End+1;
                                                stack(End,1)=CurrX+m;
                                                stack(End,2)=CurrY+n;
                                                mask(CurrX+m,CurrY+n)=rn;
                                            end
                                   elseif baserule
                                            End = End+1;
                                            stack(End,1)=CurrX+m;
                                            stack(End,2)=CurrY+n;
                                            mask(CurrX+m,CurrY+n)=rn;
                                   else
                                       
                                   end%��Ӧif elseif
                                end
                            end
                            Start=Start+1;
                        end
                    end
                end
            end
        end
    end
   

%% ����3���ο�ķ���
%     rn=1;
%     for u = 1:Width
%         for v = 1:Height 
%             if mask(u,v)==1                
%                 %����1
%                 if (u<topLine && v<leftLine) 
%                     if ((sqrt((u-topLine)^2+(v-leftLine)^2)) <= delta )%С�ڱ߽���ֵ
%                         [mask,rn]=compare_inside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);                       
%                     else
%                         [mask,rn]=compare_outside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);
%                     end
%                 %����2    
%                 elseif (u<topLine && leftLine<=v && v<rightLine)
%                     if ((topLine-u) <= delta )%С�ڱ߽���ֵ
%                         [mask,rn]=compare_inside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);
%                     else
%                         [mask,rn]=compare_outside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);
%                     end                    
%                 %����3
%                 elseif (u<topLine && v>=rightLine)
%                     if ((sqrt((u-topLine)^2+(v-rightLine)^2)) <= delta )%С�ڱ߽���ֵ
%                         [mask,rn]=compare_inside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);                        
%                     else
%                         [mask,rn]=compare_outside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);
%                     end
%                 %����4    
%                 elseif (u>=topLine && u<bottomLine && v<leftLine)
%                     if ((leftLine-v) <= delta )%С�ڱ߽���ֵ
%                         [mask,rn]=compare_inside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);                      
%                     else
%                         [mask,rn]=compare_outside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);
%                     end
%                     
%                 %����5   
%                 elseif (u>=topLine && u<bottomLine && v>=leftLine && v<rightLine)
%                             [mask,rn]=compare_outside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);
%                                                 
%                 %����6    
%                 elseif (u>=topLine && u<bottomLine && v>=rightLine)
%                     if ((v-rightLine) <= delta )%С�ڱ߽���ֵ
%                         [mask,rn]=compare_inside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);
%                     else
%                         [mask,rn]=compare_outside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);
%                     end
%                 %����7    
%                 elseif (u>=bottomLine && u<leftLine)
%                     if ((sqrt((u-bottomLine)^2+(v-leftLine)^2)) <= delta )%С�ڱ߽���ֵ
%                         [mask,rn]=compare_inside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);
%                     else
%                         [mask,rn]=compare_outside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);
%                     end
%                 %����8    
%                 elseif (u>=bottomLine && v>=leftLine && v<rightLine)
%                     if ((u-bottomLine) <= delta )%С�ڱ߽���ֵ
%                         [mask,rn]=compare_inside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);                       
%                     else
%                         [mask,rn]=compare_outside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);
%                     end
%                 %����9    
%                 else 
%                     if ((sqrt((u-bottomLine)^2+(v-rightLine)^2)) <= delta )%С�ڱ߽���ֵ
%                         [mask,rn]=compare_inside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);
%                     else
%                         [mask,rn]=compare_outside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);
%                     end
%                     
%                 end
%             end
%         end
%     end
% 
%% ȥ����ɫ    
    color_rank=sortrows(tabulate(mask(:)),-2);
    for o = 1:length(color_rank)%length(color_rank)=����
        if color_rank(o,2)<15
            [tempX,tempY]=find(mask == (color_rank(o,1)));
            for e = 1:length(tempX)
                mask(tempX(e),tempY(e))=0;
            end
        end
    
    end
    
%% ��������
     aveCenterX=0;
     aveCenterY=0;
     aveCenterZ=0;
     forCalCenter=sortrows(tabulate(mask(:)),-2);%������ܹ���һ֡���ж�����ɫ��
     for  o = 2:length(forCalCenter)
        [forCalCenterX,forCalCenterY]=find(mask==forCalCenter(o,1));
        forCalCenterSumX=0;
        forCalCenterSumY=0;
        forCalCenterSumZ=0;
        
        for e = 1:length(forCalCenterX)
            forCalCenterSumX=double(forCalCenterSumX)+double(forCalCenterX(e));
            forCalCenterSumY=double(forCalCenterSumY)+double(forCalCenterY(e));
            forCalCenterSumZ=double(forCalCenterSumZ)+double(subline(forCalCenterX(e),forCalCenterY(e)));
            
        end
        aveCenterX(o)=forCalCenterSumX/length(forCalCenterX);
        aveCenterY(o)=forCalCenterSumY/length(forCalCenterX);
        aveCenterZ(o)=forCalCenterSumZ/length(forCalCenterX);
     end
     
     dist1=zeros(length(forCalCenter),length(forCalCenter));
     
     for o = 2:length(forCalCenter)
        for e= (o+1):length(forCalCenter)
            %��1������
            %dist1(o,e)=sqrt((aveCenterX(o)-aveCenterX(e))^2+(aveCenterY(o)-aveCenterY(e))^2+(aveCenterZ(o)-aveCenterZ(e))^2);
            %��2�����ж�λ�ã����ж����
            dist1(o,e)=sqrt((aveCenterX(o)-aveCenterX(e))^2+(aveCenterY(o)-aveCenterY(e))^2);
        end
     end
     
%%     ���(δ����)
%      compareMax=0;
%      leftMask=zeros(Width,leftLine);
%      for u = 1:Width
%         for v = 1:leftLine 
%             leftMask(u,v)=mask(u,v);
%         end
%      end
%      leftMaskSort=sortrows(tabulate(leftMask(:)),-2);%�ҵ��ж�������ɫ
%      [sizeLeftX,sizeLeftY]=size(leftMaskSort);
%      if (sizeLeftX>2)
%          for o=2:sizeLeftX
%              [forCalCenterTempX,forCalCenterTempY]=find(forCalCenter(:,1)==leftMaskSort(o,1));
%              compareMax(o)=forCalCenter(forCalCenterTempX,2);
%              
%          end
%          
%      end
     
%%     
%���ұߺϲ���ɫ�����ҳ�С�飩
     %���ִ���
     leftAeraHand=find(aveCenterY<=leftLine & aveCenterY>0);%���ÿ������aveCenterY�ҳ���leftLine��ߵ����п�
     if (length(leftAeraHand)>1)%���������ҳ����Ŀ鲻ֹһ���ʱ��
        minLeftAreaHand=min(leftAeraHand);%�ҵ���������һ��
        [leftAeraHandX,leftAeraHandY]=find(leftAeraHand>minLeftAreaHand);%�ҳ�����С������Ŀ�
        for o = 1:length(leftAeraHandX)
            [tempLeftAeraHandX,tempLeftAeraHandY]=find(mask==forCalCenter(leftAeraHand(leftAeraHandX(o),leftAeraHandY(o)),1));
            for e = 1:length(tempLeftAeraHandX)%���п鶼�ó��������ɫ
                mask(tempLeftAeraHandX(e),tempLeftAeraHandY(e))=forCalCenter(minLeftAreaHand,1);
                
            end
        end
     end
     
     %���ִ���
     rightAeraHand=find(aveCenterY>=rightLine);
     if (length(rightAeraHand)>1)
        minRightAreaHand=min(rightAeraHand);
        [rightAeraHandX,rightAeraHandY]=find(rightAeraHand>minRightAreaHand);
        for o = 1:length(rightAeraHandX)
            [tempRightAeraHandX,tempRightAeraHandY]=find(mask==forCalCenter(rightAeraHand(rightAeraHandX(o),rightAeraHandY(o)),1));
            for e = 1:length(tempRightAeraHandX)
                mask(tempRightAeraHandX(e),tempRightAeraHandY(e))=forCalCenter(minRightAreaHand,1);
                
            end
        end
     end
%��������ִ���     
     compareMax=0;
     leftMask=zeros((Width-topLine+1),leftLine);%������������
     for u = topLine:Width
        for v = 1:leftLine 
            leftMask(u,v)=mask(u,v);%�ٳ�������
        end
     end
     leftMaskSort=sortrows(tabulate(leftMask(:)),-2);%�ҵ��ж�������ɫ
     [sizeLeftX,sizeLeftY]=size(leftMaskSort);%��þ������ɫ����=sizeLeftX-1�֣�
     if (sizeLeftX>2)%�������3����ɫ����3����ɫ�Ļ�
         for o=2:sizeLeftX
             [forCalCenterTempX,forCalCenterTempY]=find(forCalCenter(:,1)==leftMaskSort(o,1));
             compareMax(o-1)=forCalCenter(forCalCenterTempX,2);%ͳ�Ƴ��ֵ���ɫ����ÿ����ɫ�Ĵ�С
             
         end
         compareMaxResult=max(compareMax);%�������
         
         for e = 1:length(compareMax)
             if (compareMax(1,e)<60)%������ֵĿ�С����ֵ����ΪС��
                [tempXX,tempYY]=find(forCalCenter(:,2)==compareMax(1,e));
                [tempXXX,tempYYY]=find(forCalCenter(:,2)==compareMaxResult);
                if length(tempXX)>1%��ֹtempXX��Ƶ����ͬ�ĵ���֣�����2������ĵ�����ͬʱ��Ҫ�����ų�
                    for z=1:length(tempXX)
                        if length(find(leftMaskSort(:,1)==forCalCenter(tempXX(z),1)))>0
                            tempXX=tempXX(z);
                        end
                    end
                end%�ų����                
                [forCalCenterTempX2,forCalCenterTempY2]=find(mask==forCalCenter(tempXX,1));
                if length(tempXXX)>1%��ֹtempXXX��Ƶ����ͬ�ĵ���֣�����2������ĵ�����ͬʱ��Ҫ�����ų�
                    for z=1:length(tempXXX)
                        if length(find(rightMaskSort(:,1)==forCalCenter(tempXXX(z),1)))>0
                            tempXXX=tempXXX(z);
                        end
                    end
                end%�ų����                
                for z=1:length(forCalCenterTempX2)
                    mask(forCalCenterTempX2(z),forCalCenterTempY2(z))=forCalCenter(tempXXX,1);%��С����Ϊ������ɫ
                end
                
             end
            
         end
         
     end
%��������ִ���
     compareMax=0;
     rightMask=zeros((Width-topLine+1),Height-rightLine+1);
     for u = topLine:Width
        for v = rightLine:Height 
            rightMask(u,v)=mask(u,v);
        end
     end
     rightMaskSort=sortrows(tabulate(rightMask(:)),-2);%�ҵ��ж�������ɫ
     [sizeRightX,sizeRightY]=size(rightMaskSort);
     if (sizeRightX>2)
         for o=2:sizeRightX
             [forCalCenterTempX,forCalCenterTempY]=find(forCalCenter(:,1)==rightMaskSort(o,1));
             compareMax(o-1)=forCalCenter(forCalCenterTempX,2);
             
         end
         compareMaxResult=max(compareMax);
         
         for e = 1:length(compareMax)
             if (compareMax(1,e)<90)
                [tempXX,tempYY]=find(forCalCenter(:,2)==compareMax(1,e));%ֻ���ҵڶ���
                [tempXXX,tempYYY]=find(forCalCenter(:,2)==compareMaxResult); 
                %�����Ų�tempXX�Ƿ����2����
                if length(tempXX)>1%��ֹtempXX��Ƶ����ͬ�ĵ���֣�����2������ĵ�����ͬʱ��Ҫ�����ų�
                    for z=1:length(tempXX)
                        if length(find(rightMaskSort(:,1)==forCalCenter(tempXX(z),1)))>0
                            tempXX=tempXX(z);
                        end
                    end
                end%�ų����            
                [forCalCenterTempX2,forCalCenterTempY2]=find(mask==forCalCenter(tempXX,1));
                if length(tempXXX)>1%��ֹtempXXX��Ƶ����ͬ�ĵ���֣�����2������ĵ�����ͬʱ��Ҫ�����ų�
                    for z=1:length(tempXXX)
                        if length(find(rightMaskSort(:,1)==forCalCenter(tempXXX(z),1)))>0
                            tempXXX=tempXXX(z);
                        end
                    end
                end%�ų����
                %ͬ��tempXXҲ��Ҫ����������Ų�
                
                for z=1:length(forCalCenterTempX2)
                    mask(forCalCenterTempX2(z),forCalCenterTempY2(z))=forCalCenter(tempXXX,1);
                end
                
             end
            
         end
         
     end
     
%% �ϲ���
    %���Ȼ�ȡ��Χ��topLine���µ�����ͳ������������ɫ������������ڵ�С����кϲ�
    bottomMask=zeros(Width,Height);
    for o = topLine:Width
        for e = 1:Height
            bottomMask(o,e)=mask(o,e);
            
        end
    end%���������
    
    combineAera=sortrows(tabulate(bottomMask(:)),-2);%�жϳ��ֵ�ɫ������
    totalAera=sortrows(tabulate(mask(:)),-2);%����mask��������ɫ����
    [sizeCombineAeraX,sizeCombineAeraY]=size(combineAera);%sizeCombineAeraXΪɫ�������
    waitSortTable=0;%��ʼ��
    for o = 2:sizeCombineAeraX%Ϊ�˻��ÿ����������mask���ֵ�Ƶ�ʣ��Ӷ�֪���ĸ���С��
        [totalAeraX,totalAeraY]=find(totalAera(:,1)==combineAera(o,1));
        waitSortTable(o-1)=totalAera(totalAeraX,2);%��ó��ֵ�Ƶ�ʣ�������
    end
    waitSortTableResult=sort(waitSortTable,'descend');%�������У�ǰ�����������ֱ��Ӧ�����ֵ�ɫ��
    
    if length(waitSortTableResult)>2%�������֣����ֻ���������ɫ����ֵĻ�
        for o = 3:length(waitSortTableResult)
            [waitSortTableX,waitSortTableY]=find(waitSortTable==waitSortTableResult(1,o));%��Ҫ�����ڵڼ���
            %[waitSortTableX1,waitSortTableY1]=find(combineAera(waitSortTableY+1,1));
            [block_x,block_y]=find(mask==combineAera(waitSortTableY+1,1));%waitSortTable��combineAera���1
            %[block_x,block_y]=find(mask==combineAera(o,1));%%%%%%%%%%%%%%��������mask�Һ�bottomMask����ʲô����
            block_top=min(block_x);%�ҵ�Сɫ����ֵ
            block_bottom=max(block_x);%�ҵ�Сɫ������ֵ
            block_left=min(block_y);%�ҵ�Сɫ�������ֵ
            block_right=max(block_y);%�ҵ�Сɫ�������ֵ
            combineTable=0;%��ʼ��
            counterStack=0;
            for e = block_top:block_bottom
                for z = block_left:block_right
                    if ((mask(e,z)~=0) && (mask(e,z)==combineAera(waitSortTableY+1,1)))
                        if ((mask(e,z-1)~=combineAera(waitSortTableY+1,1)) && (mask(e,z-1)~=0))%ɫ�����߽�
                            [combineTableX,combineTableY]=find(combineTable(:,1)==mask(e,z-1));
                            if combineTableX>0
                                combineTable(combineTableX,2)=combineTable(combineTableX,2)+1;
                            else
                                counterStack=counterStack+1;
                                combineTable(counterStack,1)=mask(e,z-1);
                                combineTable(counterStack,2)=1;
                            end
                        elseif ((mask(e,z+1)~=combineAera(waitSortTableY+1,1)) && (mask(e,z+1)~=0))%ɫ����ұ߽�
                            [combineTableX1,combineTableY1]=find(combineTable(:,1)==mask(e,z+1));
                            if combineTableX1>0
                                combineTable(combineTableX1,2)=combineTable(combineTableX1,2)+1;
                            else
                                counterStack=counterStack+1;
                                combineTable(counterStack,1)=mask(e,z+1);
                                combineTable(counterStack,2)=1;
                            end
                        else
                            
                        end
                    end
                end
            end
            [combineTableMaxValue,combineTableMaxRows]=max(combineTable(:,2));%�ҳ���֮���ڽӴ������Ŀ飬������Ⱦ��һ����ɫ
            for e = 1:length(block_x)
                mask(block_x(e),block_y(e))=combineTable(combineTableMaxRows,1);
            end
            
        end
    end
    
%% ȥ���ײ����ŵ�С��
%��һ�����ҵ����ſ��Ӧ��֡���ֶ�����ȥ��
    if (i == 29) || (i==108) || (i==109) || (i==110) || (i==111) || (i==112) || (i==116)
        if(i==29)%��29֡
            for o =72:Width
                for e =1:Height
                    mask(o,e)=0;
                end
            end
        else%����֡
            for o =77:Width
                for e =1:60
                    mask(o,e)=0;
                end
            end
        end
    
    end
%������Ѱ�Ұ�Χ�͵�����ֵС��ĳ��ֵ�Ŀ죬����Щ��ȥ����ǰ������ЩС�鲻�������ֻ���ͷһ����ɫ����һ��ɫ��д���ж����Ƿ���С��ĺ���
      
%% ��ͷ�ҳ���
    findHeadSortTable=sortrows(tabulate(mask(:)),-2);
    [findHeadSortTableRows,findHeadSortTableCols]=size(findHeadSortTable);%�õ�����
    findHeadPartAveDepth=0;
    for o =2:findHeadSortTableRows%�ҵ�ÿһС�鲢��������ƽ�����
        [findHeadPartX,findHeadPartY]=find(mask==findHeadSortTable(o,1));
        findHeadPartSum=0;
        for e =1:length(findHeadPartX)
            findHeadPartSum=findHeadPartSum+subline(findHeadPartX(e),findHeadPartY(e));
        end
        findHeadPartAveDepth(o-1)=findHeadPartSum/length(findHeadPartX);
        
    end
    findHeadPartAveSortResult=sort(findHeadPartAveDepth,'descend');%�������У���һ�����ͷ
    if length(findHeadPartAveSortResult)>3 %����4��ɫ���ʱ��Ĭ������ʱ����ֻ��3��ɫ�飬����110֡�쳣��ֻ������ɫ��
        if i==5%i=5��ʱ��Ƚ����⣬��򴦻�����һС�飬������ʱ��ͷû����Ⱦ��һ����ɫ,����i=5��ʱ�򵥶�����
                for o=1:2
                    [headTempX,headTempY]=find(findHeadPartAveDepth==findHeadPartAveSortResult(1,o));
                    [headX,headY]=find(mask==(findHeadSortTable(headTempY+1,1)));
                    for e=1:length(headX)
                        mask(headX(e),headY(e))=888;%���ҳ�����ͷ���������½���Ⱦɫ
                    end
                end
        else
            if (abs(findHeadPartAveSortResult(1,1)-findHeadPartAveSortResult(1,2))<66)%��Ϊ��ʱ����ͷ���ֿ�����Ϊ������֮�����ֵ����
                for o=1:2%��ʱҪ������ͷ������Ⱦɫ
                    [headTempX,headTempY]=find(findHeadPartAveDepth==findHeadPartAveSortResult(1,o));
                    [headX,headY]=find(mask==(findHeadSortTable(headTempY+1,1)));
                    for e=1:length(headX)
                        mask(headX(e),headY(e))=888;
                    end
                end
                
            else%�������ֱ��ָ�������֣����Գ�����4��ɫ�飬��ʱ��ֻ��Ҫ�����ֵ���Ŀ飨��ͷ������Ⱦɫ
                for o=1:1
                    [headTempX,headTempY]=find(findHeadPartAveDepth==findHeadPartAveSortResult(1,o));
                    [headX,headY]=find(mask==(findHeadSortTable(headTempY+1,1)));
                    for e=1:length(headX)
                        mask(headX(e),headY(e))=888;
                    end
                end
            end
        end
%    elseif length(findHeadPartAveSortResult)==2
        %110֡�쳣��ֻ������ɫ�飬���Ե����Ȳ�����������ĳ��֡������һ��ɫ�飬ͷ�Լ�һ��ɫ���ʱ��Ҳ��length==2
    else%����С�ڵ���3��ɫ������
        [headTempX,headTempY]=find(findHeadPartAveDepth==findHeadPartAveSortResult(1,1));
        [headX,headY]=find(mask==(findHeadSortTable(headTempY+1,1)));
        headXsum=0;
        for o=1:length(headX)%Ϊ�˼���ƽ���߶�
            headXsum=headXsum+headX(o);
        end
        headXave=headXsum/length(headX);
        if headXave > topLine%Ҫ�����ֵ���Ŀ��������������topLine���£�֤����ʱ����������֣�����������������һ�飨�ڶ��飩
            [headTempX,headTempY]=find(findHeadPartAveDepth==findHeadPartAveSortResult(1,2));
            [headX,headY]=find(mask==(findHeadSortTable(headTempY+1,1)));
            headXsum=0;
            for o=1:length(headX)
                headXsum=headXsum+headX(o);
            end
            headXave=headXsum/length(headX);
            if headXave > topLine%Ҫ�����ֵ���Ŀ��������������topLine���£�֤����ʱ����������֣�����������������һ�飨�����飩
                [headTempX,headTempY]=find(findHeadPartAveDepth==findHeadPartAveSortResult(1,3));
                [headX,headY]=find(mask==(findHeadSortTable(headTempY+1,1)));
                for e=1:length(headX)
                    mask(headX(e),headY(e))=888;
                end
            else
                for e=1:length(headX)
                    mask(headX(e),headY(e))=888;
                end
            end
        else
            for e=1:length(headX)
                mask(headX(e),headY(e))=888;
            end
        end
    end
    
%% ���ұ����궨��
    middleColLine=(leftLine+rightLine)/2;%��Χ�����ĵ��������
    middleRowLine=(topLine+bottomLine)/2;%��Χ�����ĵ�ĺ�����
    headRowLine=topLine-(bottomLine-topLine)*0.18;%ͷ�����ĵ�ĺ�����
    maskLeft=0;%��ʼ���������
    maskRight=0;
    %����������mask
    for o=1:Width
        for e=1:ceil(middleColLine)
            
                maskLeft(o,e)=mask(o,e);
            
        end
    end
    %����������mask
    for o=1:Width
        for e=ceil(middleColLine)+1:Height
            
                maskRight(o,e)=mask(o,e);
            
        end
    end
%     maskLeft(maskLeft==0)=NaN;
%     maskRight(maskRight==0)=NaN;
%     %���������
%     maskLeftDepth=0;%��ʼ���������
%     maskRightDepth=0;
%     %����������mask
%     for o=1:Width
%         for e=1:ceil(middleColLine)
%             if mask(o,e)~=888
%                 maskLeftDepth(o,e)=mask(o,e);
%             end
%         end
%     end
%     %����������mask
%     for o=1:Width
%         for e=ceil(middleColLine)+1:Height
%             if mask(o,e)~=888
%               
%                 maskRightDepth(o,e)=mask(o,e);
%             end
%         end
%     end
%     maskLeftDepthTable=sortrows(tabulate(maskLeftDepth(:)),-2);
%     maskRightDepthTable=sortrows(tabulate(maskRightDepth(:)),-2);
    


%%%%%�������ֺ����ֵ���ɫ
    maskLeftForCal=0;
    maskRightForCal=0;
    [maskLeftNotZerosX,maskLeftNotZerosY]=find(maskLeft~=0 & maskLeft~=888);%ȡ�����з�0�ͷ�888��Ԫ�أ������˱�����ͷ������ɫ��
    
    for o=1:length(maskLeftNotZerosX)
        maskLeftForCal(1,o)=maskLeft(maskLeftNotZerosX(o),maskLeftNotZerosY(o));%ȡ��,�ų�һ��
        %maskLeftForCal(maskLeftNotZerosX(o),maskLeftNotZerosY(o))=maskLeft(maskLeftNotZerosX(o),maskLeftNotZerosY(o));
    end
    
    [maskRightNotZerosX,maskRightNotZerosY]=find(maskRight~=0 & maskRight~=888);%888Ϊͷ��
    for o=1:length(maskRightNotZerosX)
        maskRightForCal(1,o)=maskRight(maskRightNotZerosX(o),maskRightNotZerosY(o));
    end
    %ֱ�Ӷ�maskLeftForCal����tabulateʱ����ֺܶ�û���ֵ�Ԫ�أ��������ǵ�Ƶ��Ϊ0������Ҫ��Щ������Ƚ���ת��Ϊ�ַ��ٽ���ͳ��
    maskLeftForCal2=tabulate(num2str(maskLeftForCal(:)));
    maskLeftForCal2(:,1)=cellfun(@str2num,maskLeftForCal2(:,1),'UniformOutput',false);
    maskLeftForCal3=cell2mat(maskLeftForCal2);
    
    
    maskRightForCal2=tabulate(num2str(maskRightForCal(:)));
    maskRightForCal2(:,1)=cellfun(@str2num,maskRightForCal2(:,1),'UniformOutput',false);
    maskRightForCal3=cell2mat(maskRightForCal2);
    
    maskLeftTable=sortrows(maskLeftForCal3,-2);%����������
    maskRightTable=sortrows(maskRightForCal3,-2);
    [maskLeftTableRows,maskLeftTableCols]=size(maskLeftTable);
    [maskRightTableRows,maskRightTableCols]=size(maskRightTable);
    
    searchHandTable=sortrows(tabulate(mask(:)),-2);
    [searchHandTableRows,searchHandTableCols]=size(searchHandTable);
    if maskLeftTableRows==1%����������ֻ��һ��ɫ�飬��Ϊ����
       [leftHandX,leftHandY]=find(mask==maskLeftTable(maskLeftTableRows,1));%�ҵ����ֵ�����
       for o=1:length(leftHandX)
           mask(leftHandX(o),leftHandY(o))=200;%����ȾɫΪ200
       end
       %����Ⱦɫ������ֽ��д���
       for o=1:searchHandTableRows
           if searchHandTable(o,1)~=0 && searchHandTable(o,1)~=888 && searchHandTable(o,1)~=maskLeftTable(maskLeftTableRows,1)
               rightHandValue=searchHandTable(o,1);%�ҵ�����ɫ���ֵ
           end
       end
       [rightHandX,rightHandY]=find(mask==rightHandValue);
       for o=1:length(rightHandX)
           mask(rightHandX(o),rightHandY(o))=500;%������Ϊ500
       end
    
    elseif maskRightTableRows==1%����ұ�����ֻ��һ��ɫ�飬��Ϊ����
       [rightHandX,rightHandY]=find(mask==maskRightTable(maskRightTableRows,1));%�ҵ����ֵ�����
       for o=1:length(rightHandX)
           mask(rightHandX(o),rightHandY(o))=500;%����ȾɫΪ200
       end
       %����Ⱦɫ������ֽ��д���
       for o=1:searchHandTableRows
           if searchHandTable(o,1)~=0 && searchHandTable(o,1)~=888 && searchHandTable(o,1)~=maskRightTable(maskRightTableRows,1)
               leftHandValue=searchHandTable(o,1);%�ҵ�����ɫ���ֵ
           end
       end
       [leftHandX,leftHandY]=find(mask==leftHandValue);
       for o=1:length(leftHandX)
           mask(leftHandX(o),leftHandY(o))=200;%������Ϊ500
       end
    else%�������߶���2��ɫ������
        leftBlockDepthAve=0;
        for w =1:maskLeftTableRows%����ÿ�����ƽ�����
            [tempX,tempY]=find(maskLeft==maskLeftTable(w,1));%�ҵ���һ����ɫ��
            leftBlockDepthSum=0;
            for o=1:length(tempX)
                leftBlockDepthSum=leftBlockDepthSum+subline(tempX(o),tempY(o));
            end
            leftBlockDepthAve(w,1)=leftBlockDepthSum/length(tempX);
        end
        rightBlockDepthAve=0;
        for w =1:maskRightTableRows%����ÿ�����ƽ�����
            [tempX,tempY]=find(maskRight==maskRightTable(w,1));%�ҵ���һ����ɫ��
            rightBlockDepthSum=0;
            for o=1:length(tempX)
                rightBlockDepthSum=rightBlockDepthSum+subline(tempX(o),tempY(o));
            end
            rightBlockDepthAve(w,1)=rightBlockDepthSum/length(tempX);
        end        
        if (maskLeftTable(1,1)==maskRightTable(1,1))%��ߺ��ұߵ����ֵ��һ������ȽϿ�����һ��ռ�ñ����Ƚϴ�

            %�ĳ�����������ж�������
            %if leftBlockDepthAve(1,1)>leftBlockDepthAve(2,1)
            if (maskLeftTable(1,3)>=maskRightTable(1,3))%leftBlockDepthAve(1,1)>leftBlockDepthAve(2,1)%���ռ�ı����Ƚϴ�
                [leftHandX,leftHandY]=find(mask==maskLeftTable(1,1));%�ҵ����ֵ�����
                for o=1:length(leftHandX)
                    mask(leftHandX(o),leftHandY(o))=200;%����ȾɫΪ200
                end
                %����Ⱦɫ������ֽ��д���
                for o=1:searchHandTableRows
                    if searchHandTable(o,1)~=0 && searchHandTable(o,1)~=888 && searchHandTable(o,1)~=maskLeftTable(1,1)
                        rightHandValue=searchHandTable(o,1);%�ҵ�����ɫ���ֵ
                    end
                end
                [rightHandX,rightHandY]=find(mask==rightHandValue);
                for o=1:length(rightHandX)
                    mask(rightHandX(o),rightHandY(o))=500;%������Ϊ500
                end
            else%�ұ�ռ�ı����Ƚϴ�
%                 [leftHandX,leftHandY]=find(mask==maskLeftTable(2,1));%�ҵ����ֵ�����
%                 for o=1:length(leftHandX)
%                     mask(leftHandX(o),leftHandY(o))=200;%����ȾɫΪ200
%                 end
%                 %����Ⱦɫ������ֽ��д���
%                 for o=1:searchHandTableRows
%                     if searchHandTable(o,1)~=0 && searchHandTable(o,1)~=888 && searchHandTable(o,1)~=maskLeftTable(2,1)
%                         rightHandValue=searchHandTable(o,1);%�ҵ�����ɫ���ֵ
%                     end
%                 end
%                 [rightHandX,rightHandY]=find(mask==rightHandValue);
%                 for o=1:length(rightHandX)
%                     mask(rightHandX(o),rightHandY(o))=500;%������Ϊ500
%                 end

                
                [rightHandX,rightHandY]=find(mask==maskRightTable(1,1));%�ҵ����ֵ�����
                for o=1:length(rightHandX)
                    mask(rightHandX(o),rightHandY(o))=500;%����ȾɫΪ200
                end
                %����Ⱦɫ������ֽ��д���
                for o=1:searchHandTableRows
                    if searchHandTable(o,1)~=0 && searchHandTable(o,1)~=888 && searchHandTable(o,1)~=maskRightTable(1,1)
                        leftHandValue=searchHandTable(o,1);%�ҵ�����ɫ���ֵ
                    end
                end
                [leftHandX,leftHandY]=find(mask==leftHandValue);
                for o=1:length(leftHandX)
                    mask(leftHandX(o),leftHandY(o))=200;%������Ϊ500
                end
                
            end
        
        else%��ߺ��ұߵ����鲻��ͬһ�飬�����ȷ�������ֺ�����

            [leftHandX,leftHandY]=find(mask==maskLeftTable(1,1));%�ҵ����ֵ�����
            for o=1:length(leftHandX)
                mask(leftHandX(o),leftHandY(o))=200;%����ȾɫΪ200
            end
            %����Ⱦɫ������ֽ��д���
            for o=1:searchHandTableRows
                if searchHandTable(o,1)~=0 && searchHandTable(o,1)~=888 && searchHandTable(o,1)~=maskLeftTable(1,1)
                    rightHandValue=searchHandTable(o,1);%�ҵ�����ɫ���ֵ
                end
            end
            [rightHandX,rightHandY]=find(mask==rightHandValue);
            for o=1:length(rightHandX)
                mask(rightHandX(o),rightHandY(o))=500;%������Ϊ500
            end
        end
            
        
    end
        

    
    
    exceptHeadTable=sortrows(tabulate(mask(:)),-2);
    [exceptHeadTableX,exceptHeadTableY]=size(exceptHeadTable);
    for o =1:exceptHeadTableX
        if (exceptHeadTable(o,1)==200)%�������ֵ����ĺ�ê��
            [exceptHeadTableTempX,exceptHeadTableTempY]=find(mask==exceptHeadTable(o,1));
            handOfLeftSumX=0;
            handOfLeftSumY=0;
            
            for e =1:length(exceptHeadTableTempX)
                handOfLeftSumX=handOfLeftSumX+exceptHeadTableTempX(e);
                handOfLeftSumY=handOfLeftSumY+exceptHeadTableTempY(e);
                
            end
            handOfLeftAveX=handOfLeftSumX/length(exceptHeadTableTempX);
            handOfLeftAveY=handOfLeftSumY/length(exceptHeadTableTempX);
%             distanceOfLeftHeadAndHand=handOfLeftAveX-headRowLine;
%             maoRowsOfLeftHand=middleRowLine-distanceOfLeftHeadAndHand;
            %���ֵ�ê����������
            maoRowsOfLeftHand=107-handOfLeftAveX;
        elseif (exceptHeadTable(o,1)==500)%�������ֵ����ĺ�ê��

            [exceptHeadTableTempX,exceptHeadTableTempY]=find(mask==exceptHeadTable(o,1));
            handOfRightSumX=0;
            handOfRightSumY=0;
            
            for e =1:length(exceptHeadTableTempX)
                handOfRightSumX=handOfRightSumX+exceptHeadTableTempX(e);
                handOfRightSumY=handOfRightSumY+exceptHeadTableTempY(e);
                
            end
            handOfRightAveX=handOfRightSumX/length(exceptHeadTableTempX);
            handOfRightAveY=handOfRightSumY/length(exceptHeadTableTempX);
%             distanceOfRightHeadAndHand=handOfRightAveX-headRowLine;
%             maoRowsOfRightHand=middleRowLine-distanceOfRightHeadAndHand;
            maoRowsOfRightHand=115-handOfRightAveX;%����ê����������
        else
            
        end
    end
%% �ⷽ�̻�ֱ�ߣ�Ѱ�Ҷ˵㣨���ֻ��ߣ�
    A=[maoRowsOfLeftHand,leftLine];
    B=[handOfLeftAveX,handOfLeftAveY];
    kk=(maoRowsOfLeftHand-handOfLeftAveX)/(leftLine-handOfLeftAveY);
    recordLeft=0;%��ʼ��
    recordLeft(1,1)=handOfLeftAveX;
    recordLeft(1,2)=handOfLeftAveY;
    recordStart=1;
    xxLeft=handOfLeftAveX;%������ֵ������ĳʱ���ʱ���Ҳ�����Ӧ��ɫ�������޷�����ֱ����������
    yyLeft=handOfLeftAveY;
    
    if handOfLeftAveY<leftLine%����ֵ�����λ���ܵ�ê������ȥ������ʱ���ֵı߽���yֵ��С�ĵ�
        for o=1:floor(handOfLeftAveY)
            yyLeft=(handOfLeftAveY)-o;%�ݼ�Ѱ��
            xxLeft=(kk*yyLeft-kk*handOfLeftAveY+handOfLeftAveX);
            if (round(xxLeft)<Width) && (round(xxLeft)>1) && (round(yyLeft)>1) && (round(yyLeft)<Height)
                if mask(round(xxLeft),round(yyLeft))==200
                    recordLeft(recordStart,1)=round(xxLeft);%�����ջ
                    recordLeft(recordStart,2)=round(yyLeft);
                    recordStart=recordStart+1;%������1
                end
            end
        end
        [recordLeftRows,recordLeftCols]=size(recordLeft);
        xxLeft=recordLeft(recordLeftRows,1);%�ҵ��߽��
        yyLeft=recordLeft(recordLeftRows,2);
    elseif handOfLeftAveY>leftLine%�ֵ�����λ���ܵ�ê����Ҳ�ȥ
        for o=1:floor(Height-handOfLeftAveY)
            yyLeft=(handOfLeftAveY)+o;%�ݼ�Ѱ��
            xxLeft=(kk*yyLeft-kk*handOfLeftAveY+handOfLeftAveX);
            
            if (round(xxLeft)<Width) && (round(xxLeft)>1) && (round(yyLeft)>1) && (round(yyLeft)<Height) && (mask(round(xxLeft),round(yyLeft))==200)
                recordLeft(recordStart,1)=round(xxLeft);%�����ջ
                recordLeft(recordStart,2)=round(yyLeft);
                recordStart=recordStart+1;%������1
            end
            
        end
        [recordLeftRows,recordLeftCols]=size(recordLeft);
        xxLeft=recordLeft(recordLeftRows,1);%�ҵ��߽��
        yyLeft=recordLeft(recordLeftRows,2);
    else%�ֵ����ĸ�ê����ͬһ��y��
        if handOfLeftAveX<=maoRowsOfLeftHand%�ֵ�������ê�������
            for o=1:floor(handOfLeftAveX)
                yyLeft=(handOfLeftAveY);%�ݼ�Ѱ��
                xxLeft=handOfLeftAveX-o;
                
                if (round(xxLeft)<Width) && (round(xxLeft)>1) && (round(yyLeft)>1) && (round(yyLeft)<Height) && (mask(round(xxLeft),round(yyLeft))==200)
                    recordLeft(recordStart,1)=round(xxLeft);%�����ջ
                    recordLeft(recordStart,2)=round(yyLeft);
                    recordStart=recordStart+1;%������1
                end
                
            end
            [recordLeftRows,recordLeftCols]=size(recordLeft);
            xxLeft=recordLeft(recordLeftRows,1);%�ҵ��߽��
            yyLeft=recordLeft(recordLeftRows,2);
        else%�ֵ�������ê�������
            for o=1:floor(Width-handOfLeftAveX)
                yyLeft=(handOfLeftAveY);%�ݼ�Ѱ��
                xxLeft=handOfLeftAveX+o;
                
                if (round(xxLeft)<Width) && (round(xxLeft)>1) && (round(yyLeft)>1) && (round(yyLeft)<Height) && (mask(round(xxLeft),round(yyLeft))==200)
                    recordLeft(recordStart,1)=round(xxLeft);%�����ջ
                    recordLeft(recordStart,2)=round(yyLeft);
                    recordStart=recordStart+1;%������1
                end
                
            end
            [recordLeftRows,recordLeftCols]=size(recordLeft);
            xxLeft=recordLeft(recordLeftRows,1);%�ҵ��߽��
            yyLeft=recordLeft(recordLeftRows,2);            
        end
        
    end
%% ���ֻ���

     
%%     %
%     [maoRowsNotZeroX,maoRowsNotZeroY]=find(maoRows~=0);%׼��ȡ��ê��ĺ�����
%     maoValue=0;
%     for o=1:length(maoRowsNotZeroY)
%         maoValue(o)=maoRows(1,maoRowsNotZeroY(o));
%     end
%     %
%     [handXRowsNotZeroX,handXRowsNotZeroY]=find(handAveX~=0);
%     handXValue=0;
%     for o=1:length(handXRowsNotZeroY)
%         handXValue(o)=handAveX(1,handXRowsNotZeroY(o));
%         handYValue(o)=handAveY(1,handXRowsNotZeroY(o));
%     end
    
    
    
    
    
    
    
%%     
%      %��2
%      [findZeroX,findZeroY]=find(dist1==0);
%      for o = 1:length(findZeroX)
%         dist1(findZeroX(o),findZeroY(o))=200;
%      end
%      minCol=min(dist1);
%      maskInitial=mask;
%      for o=3:length(minCol)
%         if (minCol(1,o)<13)
%             [minColX,minColY]=find(dist1==minCol(1,o));
%             if abs(aveCenterZ(1,minColX)-aveCenterZ(1,minColY))<350
%                 [waitChangeX,waitChangeY]=find(mask==forCalCenter(minColY,1));
%                 [waitChangeX2,waitChangeY2]=find(maskInitial==forCalCenter(minColX,1));
%                 
%                 for e = 1:length(waitChangeX)
%                     mask(waitChangeX(e),waitChangeY(e))=mask(waitChangeX2(1),waitChangeY2(1));
%                 end
%             end
%         end
%      end

%%     
     %��1
%      [forChangeColorX,forChangeColorY]=find((dist1<50) & (dist1>0));
%      if (~isempty(forChangeColorX))
%          for o = 1:length(forChangeColorX)
%             [waitChangeX,waitChangeY]=find(mask==forCalCenter(forChangeColorY(o)));
%             for e = 1:length(waitChangeX)
%                 mask(waitChangeX(e),waitChangeY(e))=forCalCenter(forChangeColorX(o));
%             end
%          end
%      end
    
%    color_rank=sortrows(tabulate(mask(:)),-2);


%  % ����ǰ��֡��ͬ����ɫ��������Ⱦɫ
%     mask1=zeros(Width,Height);
%     mask2=zeros(Width,Height);
%     
%     if i~=1
%         
%         [sameX,sameY]=find(mask_before ~= 0);
%         for e = 1:length(sameX)
%             if (mask(sameX(e),sameY(e))~=0)
%                   %[sameX1,sameY1]=find(mask == mask(sameX(e),sameY(e)));
%                     mask1(sameX(e),sameY(e))=mask(sameX(e),sameY(e));
%                     mask2(sameX(e),sameY(e))=mask_before(sameX(e),sameY(e));
%             end
%         end
%         mask1_rank=sortrows(tabulate(mask1(:)),-2);%��һ֡���������ɫ��
%         mask2_rank=sortrows(tabulate(mask2(:)),-2);%��һ֡���������ɫ��
%         for o = 2:length(mask1_rank)
%             [sameX1,sameY1]=find(mask==mask1_rank(o,1));%�ҵ����������ɫ������
%             for e = 1:length(sameX1)
%                 %�����㴦�������ɫ��һ��
%                 if (mask2(sameX1(e),sameY1(e))~=0) && (mask2(sameX1(e),sameY1(e))~=mask1(sameX1(e),sameY1(e))) && (abs(subline(sameX1(e),sameY1(e))-subline_before(sameX1(e),sameY1(e)))<30)%���ֵ��Ϊ�������ִ�ͷ���뿪ʱ�����
%                     getColor=mask2(sameX1(e),sameY1(e));
%                     for z = 1:length(sameX1)
%                         mask(sameX1(z),sameY1(z))=getColor;
%                     end
%                     
%                 end
%             end
%             
%         end
%     end

%% ��֤���һ֡��ʱ�����Ƿ�ֿ�������������ҵ���ɫֵ�ñȽ�
%      [fd7_x,fd7_y]=find(mask~=0);
%      fd_top=min(fd7_x);
%      fd_bottom=max(fd7_x);
%      fd_left=min(fd7_y);
%      fd_right=max(fd7_y);
%% ��֤��6֡��ʱ��ͷ�Ƿ����
%      [findHeadX,findHeadY]=find(mask == 1);
%      for z = 1:length(findHeadX) 
%         mask(findHeadX(z),findHeadY(z))=888;
%      end 
    
    %figure;
    subplot(111);imagesc(mask);
    %subplot(121);imagesc(depth);

%     for o=1:length(maoValue)
%         line([rightLine,handYValue(o)],[maoValue(o),handXValue(o)],'LineWidth',2,'Color',[.8 .8 .2]);
%     end
     
     %line([rightLine,handOfRightAveY],[topLine,handOfRightAveX],'LineWidth',2,'Color',[.8 .8 .2]);
     line([leftLine,handOfLeftAveY],[topLine,handOfLeftAveX],'LineWidth',2,'Color',[.8 .8 .2]);
     %line([leftLine,handOfLeftAveY],[maoRowsOfLeftHand,handOfLeftAveX],'LineWidth',2,'Color',[.8 .8 .2]);
     line([yyLeft,handOfLeftAveY],[xxLeft,handOfLeftAveX],'LineWidth',2,'Color',[.8 .8 .2]);%���ֵ���
     %line([rightLine,handOfRightAveY],[maoRowsOfRightHand,handOfRightAveX],'LineWidth',2,'Color',[.8 .8 .2]);
     
%      line([middleColLine,middleColLine],[headRowLine,middleRowLine],'LineWidth',2,'Color',[.8 .8 .2]);%��������
%      line([leftLine,rightLine],[topLine,topLine],'LineWidth',2,'Color',[.8 .8 .2]);%������

%     line([leftLine,rightLine],[bottomLine,bottomLine],'LineWidth',2,'Color',[.8 .8 .2]);
%     line([leftLine,leftLine],[topLine,bottomLine],'LineWidth',2,'Color',[.8 .8 .2]);
%     line([rightLine,rightLine],[topLine,bottomLine],'LineWidth',2,'Color',[.8 .8 .2]);
    
%     if bSaveAVI 
%         frame=getframe(gcf);   %��ͼ�������Ƶ�ļ���
%         writeVideo(WriterObj,frame);% ��frame�ŵ�����WriterObj��
%     end

    pause(0.1);
    
    mask_before=mask;
    subline_before=subline;
end
%close(WriterObj);
