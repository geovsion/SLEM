function inliers=project_points_verification(p,pp,w,thres_verification)
p1=cat(1, p(1:2,:), (p(1:2,:)- p(3:4,:)));
pp1=cat(1, pp(1:2,:), (pp(1:2,:)- pp(3:4,:)));

[G]=G_compute_fast(p1, p1, 1);
GG=G_compute_fast(pp1, p1, 1);

G_ori=G;
pp=pp';
%imshow(G, [])

M1=zeros(size(pp,1), 8*size(p,2)+8);
M2=zeros(size(pp,1), 8*size(p,2)+8);
M3=zeros(size(pp,1), 8*size(p,2)+8);
num=size(G,1);
for i=1:size(pp,1)
    M1(i,3*num+1:4*num)=-pp(i,1)*GG(i,:);
    M1(i,4*num+1:5*num)=-pp(i,2)*GG(i,:);
    M1(i,5*num+1:6*num)=-GG(i,:);
    M1(i,6*num+1:7*num)=pp(i,1)*pp(i,4)*GG(i,:);
    M1(i,7*num+1:8*num)=pp(i,2)*pp(i,4)*GG(i,:);
    M1(i,8*num+4)=-pp(i,1);
    M1(i,8*num+5)=-pp(i,2);   
    M1(i,8*num+6)=-1;
    M1(i,8*num+7)=pp(i,1)*pp(i,4);  
    M1(i,8*num+8)=pp(i,2)*pp(i,4); 
    N1(i)=-pp(i,4);
    
    M2(i,1:num)=pp(i,1)*GG(i,:);
    M2(i,num+1:2*num)=pp(i,2)*GG(i,:);
    M2(i,2*num+1:3*num)=GG(i,:);
    M2(i,6*num+1:7*num)=-pp(i,1)*pp(i,3)*GG(i,:);
    M2(i,7*num+1:8*num)=-pp(i,2)*pp(i,3)*GG(i,:);
    M2(i,8*num+1)=pp(i,1);
    M2(i,8*num+2)=pp(i,2);   
    M2(i,8*num+3)=1;
    M2(i,8*num+7)=-pp(i,1)*pp(i,3);  
    M2(i,8*num+8)=-pp(i,2)*pp(i,3); 
    N2(i)=pp(i,3);    
    
    M3(i,1:num)=-pp(i,1)*pp(i,4)*GG(i,:);
    M3(i,num+1:2*num)=-pp(i,2)*pp(i,4)*GG(i,:);
    M3(i,2*num+1:3*num)=-pp(i,4)*GG(i,:);
    M3(i,3*num+1:4*num)=pp(i,1)*pp(i,3)*GG(i,:);
    M3(i,4*num+1:5*num)=pp(i,2)*pp(i,3)*GG(i,:);
    M3(i,5*num+1:6*num)=pp(i,3)*GG(i,:);
    M3(i,8*num+1)=-pp(i,1)*pp(i,4);
    M3(i,8*num+2)=-pp(i,2)*pp(i,4);   
    M3(i,8*num+3)=-pp(i,4);
    M3(i,8*num+4)=pp(i,1)*pp(i,3);
    M3(i,8*num+5)=pp(i,2)*pp(i,3);   
    M3(i,8*num+6)=1*pp(i,3);
    N3(i)=0;
    
end
error=sqrt((M1*w-N1').^2+(M2*w-N2').^2+(M3*w-N3').^2);

mask=error< thres_verification;
inliers=find(mask);
% if length(inliers1)>300
%     [B,I]=sort(error);
%     inliers=I(1:300);
% else
%     inliers=inliers1;
% end
end

