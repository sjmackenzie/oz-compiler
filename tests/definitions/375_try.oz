% naming variables in catch clauses
local
   F R
in
   fun {F}
      raise halt end
      ok
   end
  try Res={F}
         in R=commit(Res)
         catch E then
            if E\=halt then R=abort(E) else R=unknown end
  end
  {Show R}
end
