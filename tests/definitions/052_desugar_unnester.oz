% Desugar of functions returning functions.
% All called functions return a function without argument that itself has to be
% called, hence the double {{ }}
local
      Add Sub
in
   fun {Add First Second}
      AddInt
   in
      fun {AddInt}
         First+Second
      end
   end

   fun {Sub First Second}
      SubInt
   in
      fun {SubInt}
         First-Second
      end
   end

   {Show {{Add {{Sub 3 2}} {{Add 1 {{Sub 3 2}}}}}}}
end
