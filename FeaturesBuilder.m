function Features = FeaturesBuilder( detectorSize )
if nargin == 0
  detectorSize = 20;
end
%FeaturesBuilder Summary of this function goes here
%  Detailed explanation goes here
Features{1} = TwoHorizontalRectanglesFeaturesBuilder(detectorSize);
Features{2} = TwoVerticalRectanglesFeaturesBuilder(detectorSize);
Features{3} = ThreeRectanglesFeaturesBuilder( detectorSize );
Features{4} = FourRectanglesFeaturesBuilder( detectorSize );
% save(strcat( sprintf('%d',detectorSize) ,'WindowSizeFeatures' ));
save 'features.mat' Features


function  Features = TwoHorizontalRectanglesFeaturesBuilder( detectorSize )
% TwoHorizontalRectanglesFeaturesBuilder Summary of this function goes here
% A*******B
% C*******D
% E*******F
%  Detailed explanation goes here
Features =[];
% loop to determine all possible six-tuples - A,B,C,D,E,F
% ScaleXLoop
for i = 1:(floor((detectorSize - 1) / 2)) % -1 because of zero padding
  AscaleX = [1 1]; 
  BscaleX = [1 1];  
  CscaleX = [1 1];  
  DscaleX = [1 1];  
  EscaleX = [1 1];  
  FscaleX = [1 1];

  CscaleX(1) = CscaleX(1) + i;
  DscaleX(1) = DscaleX(1) + i;

  EscaleX(1) = EscaleX(1) + i*2;
  FscaleX(1) = FscaleX(1) + i*2;
  %ScaleYLoop
  for j = 1:(detectorSize - 1) % -1 because of zero padding
    AscaleY = AscaleX;
    BscaleY = BscaleX;
    CscaleY = CscaleX;
    DscaleY = DscaleX;
    EscaleY = EscaleX;
    FscaleY = FscaleX;

    BscaleY(2) = BscaleY(2) + j;
    DscaleY(2) = DscaleY(2) + j;
    FscaleY(2) = FscaleY(2) + j;

    %ShiftXLoop
    AshiftX = AscaleY;
    BshiftX = BscaleY;
    CshiftX = CscaleY;
    DshiftX = DscaleY;
    EshiftX = EscaleY;
    FshiftX = FscaleY;

    for k=0:(detectorSize - FscaleY(1) )
      AshiftX(1) = AscaleY(1) + k;
      BshiftX(1) = BscaleY(1) + k;
      CshiftX(1) = CscaleY(1) + k;
      DshiftX(1) = DscaleY(1) + k;
      EshiftX(1) = EscaleY(1) + k;
      FshiftX(1) = FscaleY(1) + k;

      %ShiftYLoop
      A=AshiftX; B=BshiftX; C=CshiftX; D=DshiftX;  E=EshiftX; F=FshiftX;

      for l=0:(detectorSize - FshiftX(2))
        A(2) = AshiftX(2) + l;
        B(2) = BshiftX(2) + l;
        C(2) = CshiftX(2) + l;
        D(2) = DshiftX(2) + l;
        E(2) = EshiftX(2) + l;
        F(2) = FshiftX(2) + l;

        %Feature = [A;B;C;D;E;F];
        Feature = [sub2ind([detectorSize detectorSize],A(1),A(2));
                   sub2ind([detectorSize detectorSize],B(1),B(2));
                   sub2ind([detectorSize detectorSize],C(1),C(2));
                   sub2ind([detectorSize detectorSize],D(1),D(2));
                   sub2ind([detectorSize detectorSize],E(1),E(2));
                   sub2ind([detectorSize detectorSize],F(1),F(2))];

        Features = [Features Feature];
      end
    end
  end
end


function  [ Features ] = TwoVerticalRectanglesFeaturesBuilder( detectorSize )
%TwoVerticalRectanglesFeaturesBuilder Summary of this function goes here
% A***B***C
% *   *   *
% *   *   *
% D***E***F

%  Detailed explanation goes here
Features =[];
%loop to determine all possible six-tuples - A,B,C,D,E,F
%ScaleYLoop
for i = 1:(floor((detectorSize - 1) / 2)) % -1 because of zero padding
  AscaleY = [1 1];
  BscaleY = [1 1];
  CscaleY = [1 1];
  DscaleY = [1 1];
  EscaleY = [1 1];
  FscaleY = [1 1]; 
  
  BscaleY(2) = BscaleY(2) + i;
  EscaleY(2) = EscaleY(2) + i;
  CscaleY(2) = CscaleY(2) + i*2;
  FscaleY(2) = FscaleY(2) + i*2;
  
  %ScaleXLoop
  for j = 1:(detectorSize - 1) % -1 because of zero padding
    AscaleX = AscaleY;
    BscaleX = BscaleY;
    CscaleX = CscaleY;
    DscaleX = DscaleY;
    EscaleX = EscaleY;
    FscaleX = FscaleY;
    
    DscaleX(1) = DscaleX(1) + j;
    EscaleX(1) = EscaleX(1) + j;
    FscaleX(1) = FscaleX(1) + j;
    
    %ShiftXLoop
      AshiftX = AscaleX;
      BshiftX = BscaleX;
      CshiftX = CscaleX;
      DshiftX = DscaleX;
      EshiftX = EscaleX;
      FshiftX = FscaleX;       
      
      for k=0:(detectorSize - FscaleX(1))
        AshiftX(1) = AscaleX(1) + k;
        BshiftX(1) = BscaleX(1) + k;
        CshiftX(1) = CscaleX(1) + k;
        DshiftX(1) = DscaleX(1) + k;
        EshiftX(1) = EscaleX(1) + k;
        FshiftX(1) = FscaleX(1) + k;
        
        %ShiftYLoop
        
        A=AshiftX;
        B=BshiftX;
        C=CshiftX;
        D=DshiftX;
        E=EshiftX;
        F=FshiftX;
        
        for l=0:(detectorSize - FshiftX(2))
          A(2) = AshiftX(2) + l;
          B(2) = BshiftX(2) + l;
          C(2) = CshiftX(2) + l;
          D(2) = DshiftX(2) + l;
          E(2) = EshiftX(2) + l;
          F(2) = FshiftX(2) + l;         
          
          %Feature = [A;B;C;D;E;F];        
          Feature = [sub2ind([detectorSize detectorSize],A(1),A(2));
                     sub2ind([detectorSize detectorSize],B(1),B(2));
                     sub2ind([detectorSize detectorSize],C(1),C(2));
                     sub2ind([detectorSize detectorSize],D(1),D(2));
                     sub2ind([detectorSize detectorSize],E(1),E(2));
                     sub2ind([detectorSize detectorSize],F(1),F(2))];
                     
          Features = [Features Feature]; 
        end
      end
  end
end


function [ Features ] = ThreeRectanglesFeaturesBuilder( detectorSize )
%ThreeRectangleFeatureBuilder Summary of this function goes here
% A***B***C***D
% *   *   *   *
% *   *   *   *
% E***F***G***H
%ABCD
%EFGH
%  Detailed explanation goes here
Features =[];
%loop to determine all possible eight-tuples - A,B,C,D,E,F,G,H
%ScaleYLoop
for i = 1:(floor((detectorSize - 1) / 3)) % -1 because of zero padding
  AscaleY = [1 1];
  BscaleY = [1 1];
  CscaleY = [1 1];
  DscaleY = [1 1];
  EscaleY = [1 1];
  FscaleY = [1 1];
  GscaleY = [1 1];
  HscaleY = [1 1];
  
  BscaleY(2) = BscaleY(2) + i;
  FscaleY(2) = FscaleY(2) + i;
  
  CscaleY(2) = CscaleY(2) + i*2;
  GscaleY(2) = GscaleY(2) + i*2;
  
  DscaleY(2) = DscaleY(2) + i*3;
  HscaleY(2) = HscaleY(2) + i*3;
  
  %ScaleXLoop
  for j = 1:(detectorSize - 1) % -1 because of zero padding
    AscaleX = AscaleY;
    BscaleX = BscaleY;
    CscaleX = CscaleY;
    DscaleX = DscaleY;
    EscaleX = EscaleY;
    FscaleX = FscaleY;
    GscaleX = GscaleY;
    HscaleX = HscaleY;
    
    EscaleX(1) = EscaleX(1) + j;
    FscaleX(1) = FscaleX(1) + j;
    GscaleX(1) = GscaleX(1) + j;
    HscaleX(1) = HscaleX(1) + j;
    
    %ShiftXLoop
    AshiftX = AscaleX;
    BshiftX = BscaleX;
    CshiftX = CscaleX;
    DshiftX = DscaleX;
    EshiftX = EscaleX;
    FshiftX = FscaleX;
    GshiftX = GscaleX;
    HshiftX = HscaleX;       
      
      for k=0:(detectorSize - HscaleX(1))
        AshiftX(1) = AscaleX(1) + k;
        BshiftX(1) = BscaleX(1) + k;
        CshiftX(1) = CscaleX(1) + k;
        DshiftX(1) = DscaleX(1) + k;
        EshiftX(1) = EscaleX(1) + k;
        FshiftX(1) = FscaleX(1) + k;
        GshiftX(1) = GscaleX(1) + k;
        HshiftX(1) = HscaleX(1) + k;   
        
        %ShiftYLoop        
        
        A=AshiftX;
        B=BshiftX;
        C=CshiftX;
        D=DshiftX;
        E=EshiftX;
        F=FshiftX;
        G=GshiftX;
        H=HshiftX;
        
        for l=0:(detectorSize - HshiftX(2))
          A(2) = AshiftX(2) + l;
          B(2) = BshiftX(2) + l;
          C(2) = CshiftX(2) + l;
          D(2) = DshiftX(2) + l;
          E(2) = EshiftX(2) + l;
          F(2) = FshiftX(2) + l;
          G(2) = GshiftX(2) + l;
          H(2) = HshiftX(2) + l;
          
          %Feature = [A;B;C;D;E;F,G,H];
          Feature = [sub2ind([detectorSize detectorSize],A(1),A(2));
                     sub2ind([detectorSize detectorSize],B(1),B(2));
                     sub2ind([detectorSize detectorSize],C(1),C(2));
                     sub2ind([detectorSize detectorSize],D(1),D(2));
                     sub2ind([detectorSize detectorSize],E(1),E(2));
                     sub2ind([detectorSize detectorSize],F(1),F(2));
                     sub2ind([detectorSize detectorSize],G(1),G(2));
                     sub2ind([detectorSize detectorSize],H(1),H(2))];
                     
          Features = [Features Feature];           
        end
      end
  end
end


function [ Features ] = FourRectanglesFeaturesBuilder( detectorSize )
%FourRectanglesFeaturesBuilder Summary of this function goes here
%  Detailed explanation goes here
Features =[];
%loop to determine all possible nine-tuples - A,B,C,D,E,F,G,H,I
%ScaleYLoop
for i = 1:(floor((detectorSize - 1) / 2)) % -1 because of zero padding
  AscaleY = [1 1];
  BscaleY = [1 1];
  CscaleY = [1 1];
  DscaleY = [1 1];
  EscaleY = [1 1];
  FscaleY = [1 1]; 
  GscaleY = [1 1];
  HscaleY = [1 1];
  IscaleY = [1 1]; 
  
  BscaleY(2) = BscaleY(2) + i;
  EscaleY(2) = EscaleY(2) + i;
  HscaleY(2) = HscaleY(2) + i;
  
  CscaleY(2) = CscaleY(2) + i*2;
  FscaleY(2) = FscaleY(2) + i*2;
  IscaleY(2) = IscaleY(2) + i*2;
  
  %ScaleXLoop
  for j = 1:(floor((detectorSize - 1) / 2)) % -1 because of zero padding
    AscaleX = AscaleY;
    BscaleX = BscaleY;
    CscaleX = CscaleY;
    DscaleX = DscaleY;
    EscaleX = EscaleY;
    FscaleX = FscaleY;
    GscaleX = GscaleY;
    HscaleX = HscaleY;
    IscaleX = IscaleY;
    
    DscaleX(1) = DscaleX(1) + j;
    EscaleX(1) = EscaleX(1) + j;
    FscaleX(1) = FscaleX(1) + j;
    
    GscaleX(1) = GscaleX(1) + j*2;
    HscaleX(1) = HscaleX(1) + j*2;
    IscaleX(1) = IscaleX(1) + j*2;
    
    %ShiftXLoop
      AshiftX = AscaleX;
      BshiftX = BscaleX;
      CshiftX = CscaleX;
      DshiftX = DscaleX;
      EshiftX = EscaleX;
      FshiftX = FscaleX;
      GshiftX = GscaleX;
      HshiftX = HscaleX;
      IshiftX = IscaleX;      
      
      for k=0:(detectorSize - IscaleX(1))
        AshiftX(1) = AscaleX(1) + k;
        BshiftX(1) = BscaleX(1) + k;
        CshiftX(1) = CscaleX(1) + k;
        DshiftX(1) = DscaleX(1) + k;
        EshiftX(1) = EscaleX(1) + k;
        FshiftX(1) = FscaleX(1) + k;
        GshiftX(1) = GscaleX(1) + k;
        HshiftX(1) = HscaleX(1) + k;
        IshiftX(1) = IscaleX(1) + k;    
        
        %ShiftYLoop
        
        A=AshiftX;
        B=BshiftX;
        C=CshiftX;
        D=DshiftX;
        E=EshiftX;
        F=FshiftX;
        G=GshiftX;
        H=HshiftX;
        I=IshiftX;
        
        for l=0:(detectorSize - IshiftX(2))
          A(2) = AshiftX(2) + l;
          B(2) = BshiftX(2) + l;
          C(2) = CshiftX(2) + l;
          D(2) = DshiftX(2) + l;
          E(2) = EshiftX(2) + l;
          F(2) = FshiftX(2) + l;
          G(2) = GshiftX(2) + l;
          H(2) = HshiftX(2) + l;
          I(2) = IshiftX(2) + l;
          
          %Feature = [A;B;C;D;E;F];
          Feature = [sub2ind([detectorSize detectorSize],A(1),A(2));
                     sub2ind([detectorSize detectorSize],B(1),B(2));
                     sub2ind([detectorSize detectorSize],C(1),C(2));
                     sub2ind([detectorSize detectorSize],D(1),D(2));
                     sub2ind([detectorSize detectorSize],E(1),E(2));
                     sub2ind([detectorSize detectorSize],F(1),F(2));
                     sub2ind([detectorSize detectorSize],G(1),G(2));
                     sub2ind([detectorSize detectorSize],H(1),H(2));
                     sub2ind([detectorSize detectorSize],I(1),I(2))];
                     
          Features = [Features Feature]; 
        end
      end
  end
end

