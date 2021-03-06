% Two nested proc definitions (T and W)  at the same level use the same
% variable (A), but T redeclares it and W uses the global. The outer proc uses
% A before its children proc definitions.
local
    A P B
 in
    proc {P V}
       T W
    in
       {Show A}
       proc {T U}
         A=100
       in
         {Show A}
         {Show A}
         {Show U}
       end
       proc {W}
          {Show A}
       end
       {W}
       {T B}
    end
    A = 5
    B = 7
    {P A}
 end
