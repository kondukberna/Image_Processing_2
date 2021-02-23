clear all; clc; close all;

I=imread('C:\imge\before.jpg');
figure; imshow(I);

[m,n,z]=size(I);

Ir=I(:,:,1);
Ig=I(:,:,2);
Ib=I(:,:,3);

Ravg=mean2(Ir);
Gavg=mean2(Ig);
Bavg=mean2(Ib);

Aavg=(Ravg+Gavg+Bavg)/3;

Rstd=std2(Ir);
Gstd=std2(Ig);
Bstd=std2(Ib);



if Rstd>Bstd && Rstd>Gstd
    maxStd=Rstd;
elseif Gstd>Rstd && Gstd>Bstd
        maxStd=Gstd;
else  Bstd>Rstd && Bstd>Gstd
            maxStd=Bstd;
end

if Rstd<Bstd && Rstd<Gstd
    minStd=Rstd;
elseif Gstd<Rstd && Gstd<Bstd
        minStd=Gstd;
else  Bstd<Rstd && Bstd<Gstd
            minStd=Bstd;
end

IYCbCr=rgb2ycbcr(I);
IY = IYCbCr(:,:,1);
ICb = IYCbCr(:,:,2);
ICr = IYCbCr(:,:,3);

mCb=mean2(ICb);
mCr=mean2(ICr);


weight=(abs(mCb-mCr)+abs(maxStd-minStd))/200;

for x=1:1:m
    for y=1:1:n
        
Igw(x,y,1)=uint8(I(x,y,1)+(Aavg-Ravg));
Igw(x,y,2)=uint8(I(x,y,2)+(Aavg-Gavg));
Igw(x,y,3)=uint8(I(x,y,3)+(Aavg-Bavg));

    end
end

figure;imshow(Igw);

histogramR=imhist(Ir);
histogramG=imhist(Ig);
histogramB=imhist(Ib);

current_value=0;
Hr=0;
Lr=0;
for count=1:256
    current_value=current_value + histogramR(count);
    cumulative_hist(count)=current_value;
    deger=current_value/(m*n);
    if deger <= 0.01
        Lr=count;
    else if deger <=0.99
            Hr=count;
        else
            continue;
        end
    end          
end
   
current_value=0;
Hg=0;
Lg=0;
for count=1:256
    current_value=current_value + histogramG(count);
    cumulative_hist(count)=current_value;
    deger=current_value/(m*n);
    if deger <= 0.01
        Lg=count;
    else if deger <=0.99
            Hg=count;
        else
            continue;
        end
    end          
end
   
current_value=0;
Hb=0;
Lb=0;
for count=1:256
    current_value=current_value + histogramB(count);
    cumulative_hist(count)=current_value;
    deger=current_value/(m*n);
    if deger <= 0.01
        Lb=count;
    else if deger <=0.99
            Hb=count;
        else
            continue;
        end
    end          
end
 

if Hr>Hb && Hr>Hg
    Amax=Hr;
elseif Hg>Hr && Hg>Hb
        Amax=Hg;
else  Hb>Hr && Hb>Hg
            Amax=Hb;
end

if Lr<Lb && Lr<Lg
    Amin=Lr;
elseif Lg<Lr && Lg<Lb
        Amin=Lg;
else  Lb<Lr && Lb<Lg
            Amin=Lb;
end



I=double(imread('C:\imge\before.jpg'));

for x=1:1:m
    for y=1:1:n
  
Ichs(x,y,1)=uint8(((I(x,y,1)- Lr) / (Hr - Lr)) * Amax + Amin);
Ichs(x,y,2)=uint8(((I(x,y,2)- Lg) / (Hg - Lg)) * Amax + Amin);
Ichs(x,y,3)=uint8(((I(x,y,3)- Lb) / (Hb - Lb)) * Amax + Amin);

    end
end


for x=1:1:m
    for y=1:1:n
        for k=1:1:3
          Iout(x,y,k)=uint8((weight*Ichs(x,y,k))+((1-weight)*Igw(x,y,k)));
        end
    end
end
    
figure; imshow(Ichs);
figure; imshow(Iout);


