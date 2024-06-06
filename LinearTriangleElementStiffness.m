function k = LinearTriangleElementStiffness(E, mu, t, r1, r2, r3, p)
    % p=1: 平面应力问题
    % p=2: 平面应变问题
    
    %arear square
    %A = (r1(1)*(r2(2)-r3(2))+r2(1)*(r3(2)-r1(1))+r3(1)*(r1(2)-r3(2)))/2;
    
    v1 = [r2-r1,0];
    v2=[r3-r1,0];
    v3 =cross(v1,v2);
    A = dot(v3,v3)^0.5/2;
    
    if A <= 0
        wrong = "square <= 0"
    end
    
    b1 = r2(2)-r3(2);
    b2 = r3(2)-r1(2);
    b3 = r1(2)-r2(2);
    
    c1 = r3(1)-r2(1);
    c2 = r1(1)-r3(1);
    c3 = r2(1)-r1(1);
    B =[b1,0,b2,0,b3,0;
        0,c1,0,c2,0,c3;
        c1,b1,c2,b2,c3,b3]/(2*A);
    
    if p == 1
        D = E/(1-mu*mu)*[1 mu 0;mu 1 0;0 0 (1-mu)/2];
    elseif p == 2
        D =E/(1+mu)/(1-2*mu)*[1-mu mu 0;mu 1-mu 0;0 0 (1-2*mu)/2]; 
    end
    
    k = t*A*B'*D*B;
    
end



