clc;
clearvars -EXCEPT 'data_all';
close all;

format long;
%%
if (exist('data_all') == 0)
    load('data_all.mat');
end
%%
Width=120;  %行
Height=160; %列
delta=7;%矩形框的大小，圆的半径
bigCircleDelta = 23;%大圆的半径
depthDelta=-15;%靠近矩形框的点的深度值与平均深度值得差值-15
littleCircleDepthDelta=-5;%小圆深度差
bigCircleDepthDelta=-500;%大圆深度差
closeDelta=30;%相邻点的深度差值（种子点生长分割区域时）
% closeDeltaCircle1=35;
% closeDeltaCircle2=35;
% closeDeltaCircle3=35;
% closeDeltaCircle4=35;
% closeDeltaCircle5=35;
% closeDeltaCircle6=35;


%% 视频录制
% bSaveAVI = 1;
% if bSaveAVI
%     WriterObj=VideoWriter(strcat(datestr(now,'yyyy-mm-dd-HH-MM-SS'),'.avi'));
%     WriterObj.FrameRate=5;
%     open(WriterObj);
% end
%% 
for i = 1 : size(data_all, 1)
    %mask  = data_all{i, 1}.mask;
    %depth = data_all{i, 1}.depth;
%% 初始化
    subline=zeros(Width,Height);
    mask=zeros(Width,Height);
    c = mat2cell(data_all{i,1}.depth,2*ones(1,Width),2*ones(1,Height));%深度图划分为2*2
    d = mat2cell(data_all{i,1}.mask,2*ones(1,Width),2*ones(1,Height));%mask划分为2*2
%% 计算2*2窗口深度的有效平均值
   for a = 1:Width
       for b =1:Height
             if(numel(find(c{a,b}~=0))==0)
             subline(a,b) = 0;
             else
             subline(a,b) = sum(sum(c{a,b}))/numel(find(c{a,b}~=0));
             end
       end
   end
%% 计算2*2窗口mask的有效平均值,其实就是1
    for a = 1:Width
       for b =1:Height
             if(numel(find(d{a,b}~=0))==0)
             mask(a,b) = 0;
             else
             mask(a,b) = sum(sum(d{a,b}))/numel(find(d{a,b}~=0));
             end
       end
   end
%% 复制一个标定的mask    
    LabelImage=mask;
%% 计算人体的最上，最下，最左，最右的位置
%      subline=depth;
%      [fd7_x,fd7_y]=find(LabelImage==1);
%      fd_top=min(fd7_x);
%      fd_bottom=max(fd7_x);
%      fd_left=min(fd7_y);
%      fd_right=max(fd7_y);
%      delta1=floor((fd_bottom-fd_top)*0.2);%取上下边界的10%
%      delta2=floor((fd_right-fd_left)*0.1);%取左右边界的10%
%% 统计    
    sumcol=sum(LabelImage);
    sumrow=sum(LabelImage,2);
    sumall=sum(sumcol);
%% 左边界
    sumTemp=0;
    for f = 1:Height
          sumTemp=sumTemp+sumcol(1,f);
          if sumTemp>sumall*0.15
                leftLine=f;
                break;
          end    
    end 
%% 右边界
    sumTemp=0;
    for f = 1:Height
          sumTemp=sumTemp+sumcol(1,Height-f+1);
          if sumTemp>sumall*0.15
                rightLine=Height-f;
                break;
          end    
    end
%% 上边界
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
%% 下边界
    sumTemp=0;
    for f = 1:Width
          sumTemp=sumTemp+sumrow(Width-f+1,1);
          if sumTemp>sumall*0.10
                bottomLine=Width-f;
                break;
          end    
    end

%% 计算矩形框的深度平均值
%     sumDepth=0;         
%     for f = topLine:bottomLine 
%       for g = leftLine:rightLine 
%         %LabelImage1(f,g)=0;
%         sumDepth=double(sumDepth)+double(subline(f,g));%防止溢出
%       end
%     end
%     aveDepth=sumDepth/(bottomLine-topLine)/(rightLine-leftLine);%算出矩形区域的平均深度
 
    
%% 计算矩形框深度的中值
%     for f = 1:(bottomLine-topLine+1) 
%       for g = 1:(rightLine-leftLine+1) 
%         %LabelImage1(f,g)=0;
%         targetArea(f,g)=subline(f+topLine-1,g+leftLine-1);
%       end
%     end
%     middleDepth=median(targetArea(:));

%% 标出矩形框里的手
%     for f = topLine-10:bottomLine 
%       for g = leftLine-5:rightLine+5 
%         if subline(f,g)-middleDepth>-10
%           LabelImage(f,g)=0;
%         else 
%           LabelImage(f,g)=1;
%         end
%       end
%     end

%% 中间块的种子点生长
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

%% 算矩形框里最大块的平均深度值
    targetArea=zeros(bottomLine-topLine+1,rightLine-leftLine+1);
    for f = 1:(bottomLine-topLine+1) 
      for g = 1:(rightLine-leftLine+1) 
        %LabelImage1(f,g)=0;
        targetArea(f,g)=LabelImage(f+topLine-1,g+leftLine-1);
      end
    end
    mostNum=sortrows(tabulate(targetArea(:)),-2);%按第二列的降序排列
    mostColor=mostNum(1,1);
    [color_x,color_y]=find(LabelImage==mostColor);
    sum_color=0;
    for e=1:length(color_x) 
        sum_color=double(sum_color)+double(subline(color_x(e),color_y(e)));
       % LabelImage(color_x(e),color_y(e))=50;
    end
    ave_color=sum_color/length(color_x);%矩形框里最大块的深度平均值
    

%% 矩形框圈出手的位置    
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
    
%% 方法一身体区域生长
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
    


%% 方法2肩部圆的方法
    rn=1;
    for u = 1:Width
        for v = 1:Height 
            if mask(u,v)==1                
                
                if (u>=topLine && v>=leftLine && u<=bottomLine && v<=rightLine)
                    %区域5
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
                                circle2= ((sqrt(((CurrX+m)-topLine)^2+((CurrY+n)-rightLine)^2)) <= (delta-2));
                                circle3=((sqrt(((CurrX+m)-(topLine+bottomLine)/2)^2+((CurrY+n)-rightLine)^2)) <= (delta));
                                circle4=((sqrt(((CurrX+m)-(topLine+bottomLine)/2)^2+((CurrY+n)-leftLine)^2)) <= (delta-2));
                                circle5=((sqrt(((CurrX+m)-((topLine+bottomLine)/2-10))^2+((CurrY+n)-rightLine)^2)) <= delta);
                                circle6=((sqrt(((CurrX+m)-((topLine+bottomLine)/2-10))^2+((CurrY+n)-leftLine)^2)) <= delta);
                                circle7=((sqrt(((CurrX+m)-((topLine+bottomLine)/2-20))^2+((CurrY+n)-rightLine)^2)) <= delta);
                                circle8=((sqrt(((CurrX+m)-((topLine+bottomLine)/2-20))^2+((CurrY+n)-leftLine)^2)) <= delta);
                               circle11=((sqrt(((CurrX+m)-((topLine+bottomLine)/2+10))^2+((CurrY+n)-rightLine)^2)) <= (delta+3));%左边与10对应
                               circle10=((sqrt(((CurrX+m)-((topLine+bottomLine)/2+10))^2+((CurrY+n)-leftLine)^2)) <= (delta+3));
                               circle12=((sqrt(((CurrX+m)-((topLine+bottomLine)/2+20))^2+((CurrY+n)-rightLine)^2)) <= (delta+3));%左边与10对应
                               circle13=((sqrt(((CurrX+m)-((topLine+bottomLine)/2+20))^2+((CurrY+n)-leftLine)^2)) <= (delta+3));
                                circle14=((sqrt(((CurrX+m)-bottomLine)^2+((CurrY+n)-(rightLine+leftLine)/2)^2)) <= bigCircleDelta);
                                baserule=((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta;
                                %一直在区域5内生长情况
                                if  baserule && ((CurrX+m)>=topLine && (CurrY+n)>=leftLine && (CurrX+m)<=bottomLine && (CurrY+n)<=rightLine)
                                    End = End+1;
                                    stack(End,1)=CurrX+m;
                                    stack(End,2)=CurrY+n;
                                    mask(CurrX+m,CurrY+n)=rn;
                                %生长到区域5外的生长情况    
                                elseif baserule
                                    %如果是在区域5外的圆内
                                    %if (((sqrt(((CurrX+m)-topLine)^2+((CurrY+n)-leftLine)^2)) <= delta) || ((sqrt(((CurrX+m)-topLine)^2+((CurrY+n)-rightLine)^2)) <= delta) || ((sqrt(((CurrX+m)-(topLine+bottomLine)/2)^2+((CurrY+n)-rightLine)^2)) <= delta) || ((sqrt(((CurrX+m)-(topLine+bottomLine)/2)^2+((CurrY+n)-leftLine)^2)) <= delta))%处于圆内
                                    if circle1 || circle2 || circle3 || circle4 || circle5 || circle6|| circle7 || circle8 || circle10 || circle11 || circle12 || circle13 || circle14
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
                                    %在区域5外的圆外
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
                else %除5的其他区域
                    Circle1=((sqrt((u-topLine)^2+(v-leftLine)^2)) <= (delta-2)) ;
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
                    if Circle1 || Circle2 || Circle3 || Circle4 || Circle5 || Circle6|| Circle7 || Circle8|| Circle10 ||Circle11 || Circle12 || Circle13 || Circle14
                    %if (((sqrt((u-topLine)^2+(v-leftLine)^2)) <= delta) || ((sqrt((u-topLine)^2+(v-rightLine)^2)) <= delta) || ((sqrt((u-(topLine+bottomLine)/2)^2+(v-rightLine)^2)) <= delta) || ((sqrt((u-(topLine+bottomLine)/2)^2+(v-leftLine)^2)) <= delta))%处于圆内
                    %在区域5外的圆内
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
                                   %子种子点生长到区域5去
                                        End = End+1;
                                        stack(End,1)=CurrX+m;
                                        stack(End,2)=CurrY+n;
                                        mask(CurrX+m,CurrY+n)=rn;
                                   %修改到这
                                   

                                   elseif (baserule&&circle1)||(baserule&&circle2)||(baserule&&circle3)||(baserule&&circle4)||(baserule&&circle5)||(baserule&&circle6)||(baserule&&circle7)||(baserule&&circle8)||(baserule&&circle10)||(baserule&&circle11) ||(baserule&&circle12)||(baserule&&circle13) ||(baserule&&circle14)
                                   %elseif (((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((sqrt(((CurrX+m)-topLine)^2+((CurrY+n)-leftLine)^2)) <= delta)) || (((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((sqrt(((CurrX+m)-topLine)^2+((CurrY+n)-rightLine)^2)) <= delta)) || (((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((sqrt(((CurrX+m)-(topLine+bottomLine)/2)^2+((CurrY+n)-rightLine)^2)) <= delta))|| (((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((sqrt(((CurrX+m)-(topLine+bottomLine)/2)^2+((CurrY+n)-leftLine)^2)) <= delta))
                                   %子种子在区域5外的圆内生长
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
                                   %子种子点在区域5外的圆外生长
                                            End = End+1;
                                            stack(End,1)=CurrX+m;
                                            stack(End,2)=CurrY+n;
                                            mask(CurrX+m,CurrY+n)=rn;
                                    
                                   else
                                       
                                   end%对应if elseif
                        
                                   end
                                end
                                Start=Start+1;
                            end
                        else
                            mask(u,v) = 0;
                        end
                    else %5区域外的圆外
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
                                        %子种子点生长到区域5
                                        End = End+1;
                                        stack(End,1)=CurrX+m;
                                        stack(End,2)=CurrY+n;
                                        mask(CurrX+m,CurrY+n)=rn;

                                    elseif (baserule&&circle1)||(baserule&&circle2)||(baserule&&circle3)||(baserule&&circle4)||(baserule&&circle5)||(baserule&&circle6)||(baserule&&circle7)||(baserule&&circle8)||(baserule&&circle10)||(baserule&&circle11) ||(baserule&&circle12)||(baserule&&circle13) ||(baserule&&circle14)    
                                    %elseif (((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((sqrt(((CurrX+m)-topLine)^2+((CurrY+n)-leftLine)^2)) <= delta)) || (((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((sqrt(((CurrX+m)-topLine)^2+((CurrY+n)-rightLine)^2)) <= delta))|| (((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((sqrt(((CurrX+m)-(topLine+bottomLine)/2)^2+((CurrY+n)-rightLine)^2)) <= delta))|| (((CurrX+m)<=Width&&(CurrX+m)>=1&&(CurrY+n)<=Height&&(CurrY+n)>=1)&&(mask(CurrX+m,CurrY+n) == 1) && abs(subline(CurrX+m,CurrY+n)-subline(CurrX,CurrY))<closeDelta && ((sqrt(((CurrX+m)-(topLine+bottomLine)/2)^2+((CurrY+n)-leftLine)^2)) <= delta))
                                            %子种子点生长到圆内
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
                                       
                                   end%对应if elseif
                                end
                            end
                            Start=Start+1;
                        end
                    end
                end
            end
        end
    end
   

%% 方法3矩形框的方法
%     rn=1;
%     for u = 1:Width
%         for v = 1:Height 
%             if mask(u,v)==1                
%                 %区域1
%                 if (u<topLine && v<leftLine) 
%                     if ((sqrt((u-topLine)^2+(v-leftLine)^2)) <= delta )%小于边界阈值
%                         [mask,rn]=compare_inside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);                       
%                     else
%                         [mask,rn]=compare_outside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);
%                     end
%                 %区域2    
%                 elseif (u<topLine && leftLine<=v && v<rightLine)
%                     if ((topLine-u) <= delta )%小于边界阈值
%                         [mask,rn]=compare_inside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);
%                     else
%                         [mask,rn]=compare_outside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);
%                     end                    
%                 %区域3
%                 elseif (u<topLine && v>=rightLine)
%                     if ((sqrt((u-topLine)^2+(v-rightLine)^2)) <= delta )%小于边界阈值
%                         [mask,rn]=compare_inside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);                        
%                     else
%                         [mask,rn]=compare_outside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);
%                     end
%                 %区域4    
%                 elseif (u>=topLine && u<bottomLine && v<leftLine)
%                     if ((leftLine-v) <= delta )%小于边界阈值
%                         [mask,rn]=compare_inside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);                      
%                     else
%                         [mask,rn]=compare_outside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);
%                     end
%                     
%                 %区域5   
%                 elseif (u>=topLine && u<bottomLine && v>=leftLine && v<rightLine)
%                             [mask,rn]=compare_outside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);
%                                                 
%                 %区域6    
%                 elseif (u>=topLine && u<bottomLine && v>=rightLine)
%                     if ((v-rightLine) <= delta )%小于边界阈值
%                         [mask,rn]=compare_inside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);
%                     else
%                         [mask,rn]=compare_outside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);
%                     end
%                 %区域7    
%                 elseif (u>=bottomLine && u<leftLine)
%                     if ((sqrt((u-bottomLine)^2+(v-leftLine)^2)) <= delta )%小于边界阈值
%                         [mask,rn]=compare_inside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);
%                     else
%                         [mask,rn]=compare_outside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);
%                     end
%                 %区域8    
%                 elseif (u>=bottomLine && v>=leftLine && v<rightLine)
%                     if ((u-bottomLine) <= delta )%小于边界阈值
%                         [mask,rn]=compare_inside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);                       
%                     else
%                         [mask,rn]=compare_outside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);
%                     end
%                 %区域9    
%                 else 
%                     if ((sqrt((u-bottomLine)^2+(v-rightLine)^2)) <= delta )%小于边界阈值
%                         [mask,rn]=compare_inside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);
%                     else
%                         [mask,rn]=compare_outside(rn,u,v,subline,mask,ave_color,topLine,bottomLine,leftLine,rightLine);
%                     end
%                     
%                 end
%             end
%         end
%     end

%% 去除杂色    
    color_rank=sortrows(tabulate(mask(:)),-2);
    for o = 1:length(color_rank)%length(color_rank)=行数
        if color_rank(o,2)<15
            [tempX,tempY]=find(mask == (color_rank(o,1)));
            for e = 1:length(tempX)
                mask(tempX(e),tempY(e))=0;
            end
        end
    
    end
    
%% 计算质心
     aveCenterX=0;
     aveCenterY=0;
     aveCenterZ=0;
     forCalCenter=sortrows(tabulate(mask(:)),-2);%先求出总共这一帧里有多少种色块
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
            %法1：质心
            %dist1(o,e)=sqrt((aveCenterX(o)-aveCenterX(e))^2+(aveCenterY(o)-aveCenterY(e))^2+(aveCenterZ(o)-aveCenterZ(e))^2);
            %法2：先判断位置，在判断深度
            dist1(o,e)=sqrt((aveCenterX(o)-aveCenterX(e))^2+(aveCenterY(o)-aveCenterY(e))^2);
        end
     end
     
%%     左边(未做完)
%      compareMax=0;
%      leftMask=zeros(Width,leftLine);
%      for u = 1:Width
%         for v = 1:leftLine 
%             leftMask(u,v)=mask(u,v);
%         end
%      end
%      leftMaskSort=sortrows(tabulate(leftMask(:)),-2);%找到有多少种颜色
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
%左右边合并颜色（先找出小块）
     %左手处理
     leftAeraHand=find(aveCenterY<=leftLine & aveCenterY>0);%利用块的中心aveCenterY找出在leftLine左边的所有块
     if (length(leftAeraHand)>1)%利用中心找出来的块不止一块的时候
        minLeftAreaHand=min(leftAeraHand);%找到块最大的那一块
        [leftAeraHandX,leftAeraHandY]=find(leftAeraHand>minLeftAreaHand);%找出所有小于最大块的块
        for o = 1:length(leftAeraHandX)
            [tempLeftAeraHandX,tempLeftAeraHandY]=find(mask==forCalCenter(leftAeraHand(leftAeraHandX(o),leftAeraHandY(o)),1));
            for e = 1:length(tempLeftAeraHandX)%所有块都置成最大块的颜色
                mask(tempLeftAeraHandX(e),tempLeftAeraHandY(e))=forCalCenter(minLeftAreaHand,1);
                
            end
        end
     end
     
     %右手处理
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
%最大块的左手处理     
     compareMax=0;
     leftMask=zeros((Width-topLine+1),leftLine);%左肩的左下区域
     for u = topLine:Width
        for v = 1:leftLine 
            leftMask(u,v)=mask(u,v);%抠出此区域
        end
     end
     leftMaskSort=sortrows(tabulate(leftMask(:)),-2);%找到有多少种颜色
     [sizeLeftX,sizeLeftY]=size(leftMaskSort);%获得具体的颜色数（=sizeLeftX-1种）
     if (sizeLeftX>2)%如果出现3种颜色或者3种颜色的话
         for o=2:sizeLeftX
             [forCalCenterTempX,forCalCenterTempY]=find(forCalCenter(:,1)==leftMaskSort(o,1));
             compareMax(o-1)=forCalCenter(forCalCenterTempX,2);%统计出现的颜色里面每种颜色的大小
             
         end
         compareMaxResult=max(compareMax);%获得最大块
         
         for e = 1:length(compareMax)
             if (compareMax(1,e)<60)%如果出现的块小于阈值，即为小块
                [tempXX,tempYY]=find(forCalCenter(:,2)==compareMax(1,e));
                [tempXXX,tempYYY]=find(forCalCenter(:,2)==compareMaxResult);
                [forCalCenterTempX2,forCalCenterTempY2]=find(mask==forCalCenter(tempXX,1));
                for z=1:length(forCalCenterTempX2)
                    mask(forCalCenterTempX2(z),forCalCenterTempY2(z))=forCalCenter(tempXXX,1);%将小块置为大块的颜色
                end
                
             end
            
         end
         
     end
%最大块的右手处理
     compareMax=0;
     rightMask=zeros((Width-topLine+1),Height-rightLine+1);
     for u = topLine:Width
        for v = rightLine:Height 
            rightMask(u,v)=mask(u,v);
        end
     end
     rightMaskSort=sortrows(tabulate(rightMask(:)),-2);%找到有多少种颜色
     [sizeRightX,sizeRightY]=size(rightMaskSort);
     if (sizeRightX>2)
         for o=2:sizeRightX
             [forCalCenterTempX,forCalCenterTempY]=find(forCalCenter(:,1)==rightMaskSort(o,1));
             compareMax(o-1)=forCalCenter(forCalCenterTempX,2);
             
         end
         compareMaxResult=max(compareMax);
         
         for e = 1:length(compareMax)
             if (compareMax(1,e)<90)
                [tempXX,tempYY]=find(forCalCenter(:,2)==compareMax(1,e));%只查找第二列
                [tempXXX,tempYYY]=find(forCalCenter(:,2)==compareMaxResult);
                [forCalCenterTempX2,forCalCenterTempY2]=find(mask==forCalCenter(tempXX,1));
                for z=1:length(forCalCenterTempX2)
                    mask(forCalCenterTempX2(z),forCalCenterTempY2(z))=forCalCenter(tempXXX,1);
                end
                
             end
            
         end
         
     end
     
%% 合并块
    %首先获取包围和topLine底下的区域，统计这个区域的颜色，对这个区域内的小块进行合并
    bottomMask=zeros(Width,Height);
    for o = topLine:Width
        for e = 1:Height
            bottomMask(o,e)=mask(o,e);
            
        end
    end%获得了区域
    
    combineAera=sortrows(tabulate(bottomMask(:)),-2);%判断出现的色块数量
    totalAera=sortrows(tabulate(mask(:)),-2);%整个mask的所有颜色数量
    [sizeCombineAeraX,sizeCombineAeraY]=size(combineAera);%sizeCombineAeraX为色块的数量
    waitSortTable=0;%初始化
    for o = 2:sizeCombineAeraX%为了获得每个块在整幅mask出现的频率，从而知道哪个是小块
        [totalAeraX,totalAeraY]=find(totalAera(:,1)==combineAera(o,1));
        waitSortTable(o-1)=totalAera(totalAeraX,2);%获得出现的频率（次数）
    end
    waitSortTableResult=sort(waitSortTable,'descend');%降序排列，前两个最大的数分别对应两个手的色块
    
    if length(waitSortTableResult)>2%除了左手，右手还有其他颜色块出现的话
        for o = 3:length(waitSortTableResult)
            [waitSortTableX,waitSortTableY]=find(waitSortTable==waitSortTableResult(1,o));%主要看它在第几列
            %[waitSortTableX1,waitSortTableY1]=find(combineAera(waitSortTableY+1,1));
            [block_x,block_y]=find(mask==combineAera(waitSortTableY+1,1));%waitSortTable与combineAera相差1
            %[block_x,block_y]=find(mask==combineAera(o,1));%%%%%%%%%%%%%%测试下在mask找和bottomMask找有什么区别
            block_top=min(block_x);%找到小色块的最顶值
            block_bottom=max(block_x);%找到小色块的最底值
            block_left=min(block_y);%找到小色块的最左值
            block_right=max(block_y);%找到小色块的最右值
            combineTable=0;%初始化
            counterStack=0;
            for e = block_top:block_bottom
                for z = block_left:block_right
                    if ((mask(e,z)~=0) && (mask(e,z)==combineAera(waitSortTableY+1,1)))
                        if ((mask(e,z-1)~=combineAera(waitSortTableY+1,1)) && (mask(e,z-1)~=0))%色块的左边界
                            [combineTableX,combineTableY]=find(combineTable(:,1)==mask(e,z-1));
                            if combineTableX>0
                                combineTable(combineTableX,2)=combineTable(combineTableX,2)+1;
                            else
                                counterStack=counterStack+1;
                                combineTable(counterStack,1)=mask(e,z-1);
                                combineTable(counterStack,2)=1;
                            end
                        elseif ((mask(e,z+1)~=combineAera(waitSortTableY+1,1)) && (mask(e,z+1)~=0))%色块的右边界
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
            [combineTableMaxValue,combineTableMaxRows]=max(combineTable(:,2));%找出与之相邻接触点最多的块，将它们染成一个颜色
            for e = 1:length(block_x)
                mask(block_x(e),block_y(e))=combineTable(combineTableMaxRows,1);
            end
            
        end
    end
    
    
    
    
%%     
%      %法2
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
     %法1
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


%  % 利用前后帧相同的颜色块来进行染色
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
%         mask1_rank=sortrows(tabulate(mask1(:)),-2);%这一帧公共区域的色块
%         mask2_rank=sortrows(tabulate(mask2(:)),-2);%上一帧公共区域的色块
%         for o = 2:length(mask1_rank)
%             [sameX1,sameY1]=find(mask==mask1_rank(o,1));%找到所有这个颜色的区域
%             for e = 1:length(sameX1)
%                 %公共点处两点的颜色不一样
%                 if (mask2(sameX1(e),sameY1(e))~=0) && (mask2(sameX1(e),sameY1(e))~=mask1(sameX1(e),sameY1(e))) && (abs(subline(sameX1(e),sameY1(e))-subline_before(sameX1(e),sameY1(e)))<30)%深度值是为了区分手从头上离开时的情况
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

%% 验证最后一帧的时候手是否分开，看最左和最右的颜色值得比较
%      [fd7_x,fd7_y]=find(mask~=0);
%      fd_top=min(fd7_x);
%      fd_bottom=max(fd7_x);
%      fd_left=min(fd7_y);
%      fd_right=max(fd7_y);
%% 验证第6帧的时候头是否存在
%      [findHeadX,findHeadY]=find(mask == 1);
%      for z = 1:length(findHeadX) 
%         mask(findHeadX(z),findHeadY(z))=888;
%      end 


    %figure;
    subplot(111);imagesc(mask);
    %subplot(121);imagesc(depth);

    line([leftLine,rightLine],[topLine,topLine],'LineWidth',2,'Color',[.8 .8 .2]);
    line([leftLine,rightLine],[bottomLine,bottomLine],'LineWidth',2,'Color',[.8 .8 .2]);
    line([leftLine,leftLine],[topLine,bottomLine],'LineWidth',2,'Color',[.8 .8 .2]);
    line([rightLine,rightLine],[topLine,bottomLine],'LineWidth',2,'Color',[.8 .8 .2]);
    
%     if bSaveAVI 
%         frame=getframe(gcf);   %把图像存入视频文件中
%         writeVideo(WriterObj,frame);% 将frame放到变量WriterObj中
%     end

    pause(0.1);
    
    mask_before=mask;
    subline_before=subline;
end
%close(WriterObj);
