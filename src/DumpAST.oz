functor
export
   dumpAST:DumpAST
import
   System
define
   fun {IsCoord V}
      case V
      of pos(_ _ _) then true
      [] pos(_ _ _ _ _ _) then true
      [] unit then true
      else false
      end
   end

   fun {IsTrivial V}
      {IsInt V} orelse
      {IsLiteral V} orelse
      {IsFloat V} orelse
      {IsCoord V} orelse
      {IsObject V} orelse
      {IsProcedure V} orelse
      {IsChunk V}
   end

   fun {IsOneLiner AST}
      {IsTrivial AST} orelse
      ({IsChunk AST} andthen {HasFeature AST compiler_internal__})  orelse
      {Record.all AST IsTrivial}
   end

   fun {TrivialToVS V}
      case V
      of pos(A B C) then
         'pos("'#A#'" '#B#' '#C#')'
      [] pos(A B C D E F) then
         'pos("'#A#'" '#B#' '#C#' "'#D#'" '#E#' '#F#')'
      elseif {IsLiteral V} then
         {Value.toVirtualString V 1 1}
      elseif {IsObject V} then
         {V toVS($)}
      elseif {IsChunk V} then %andthen {HasFeature V compiler_internal__} then
         'chunk'
      elseif {IsProcedure V} then
         'procedure'
      else
         V
      end
   end

   fun {OneLinerToVS AST}
      if {IsTrivial AST} then
         {TrivialToVS AST}
      else
         {Record.foldL AST
          fun {$ Prev Field}
             Prev#{TrivialToVS Field}#' '
          end
          {Label AST}#'('}#')'
      end
   end

   proc {DumpASTEx AST Indent}
      if {IsOneLiner AST} then
         {System.showInfo Indent#{OneLinerToVS AST}}
      else
         NewIndent = Indent#'   '
      in
         if {Label AST}=='export' then
            {System.showInfo Indent#'#(...)'}
         else
            if {Label AST}=='#' then
               {System.showInfo Indent#'#('}
            else
               {System.showInfo Indent#{Label AST}#'('}
            end
            {Record.forAll AST proc {$ X} {DumpASTEx X NewIndent} end}
            {System.showInfo Indent#')'}
         end
      end
   end

   fun {DumpAST AST}
      {DumpASTEx AST ''}
      AST
   end
%% in
%   {DumpAST fAnd(fRecord(fVar('Hello' pos(1 2 3))
%                         fInt(5 pos(4 5 6))
%                         pos('Hello' 42 3))
%                 fAtom(unit))}
%%    skip
end
