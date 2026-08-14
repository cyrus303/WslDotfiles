; Replaces nvim-treesitter's c_sharp folds query rather than extending it (no
; `;; extends` modeline), because the problem is *which* nodes it picks, not that
; it picks too few. Upstream folds the body nodes -- (declaration_list), (block),
; (accessor_list) -- and those all start on the `{` line. Two consequences:
;
;   1. A collapsed method leaves its signature and a dangling `{` on two
;      separate rows, instead of one `public void Bar()` row.
;   2. Fold depth shifts by one between a file-scoped `namespace X;` and a
;      braced `namespace X { }`, so no fixed 'foldlevel' means "methods folded"
;      in both -- level 1 folded method bodies in one and the whole class in the
;      other.
;
; Folding the declaration nodes instead starts each fold on its signature line,
; the way Visual Studio's Collapse to Definitions does, and keeps depth stable
; across both namespace styles because (namespace_declaration) is deliberately
; left out below. Every other language ships a declaration-based query already
; -- see ecma's (function_declaration)/(class_declaration) and lua's
; (function_declaration) -- c_sharp was the outlier.

; Type and member declarations: the fold header is the signature line.
[
  (class_declaration)
  (struct_declaration)
  (interface_declaration)
  (record_declaration)
  (enum_declaration)
  (delegate_declaration)
  (method_declaration)
  (constructor_declaration)
  (destructor_declaration)
  (operator_declaration)
  (conversion_operator_declaration)
  (property_declaration)
  (indexer_declaration)
  (event_declaration)
  (local_function_statement)
  ; A field whose initializer spans lines folds from `private ... _items = new()`
  ; rather than from the initializer's `{` on the next row.
  (field_declaration)
] @fold

; Accessors fold individually, but (accessor_list) is not folded -- it opens on
; the property's `{`, which would add a redundant level under the property fold.
(accessor_declaration) @fold

; Statements fold from their own keyword line, which is already where the
; construct starts reading.
[
  (if_statement)
  (for_statement)
  (foreach_statement)
  (while_statement)
  (do_statement)
  (switch_statement)
  (switch_expression)
  (try_statement)
  (lock_statement)
  (using_statement)
  (fixed_statement)
  (checked_statement)
  (unsafe_statement)
  (lambda_expression)
] @fold

; Collection/object initializers and enum bodies have no signature line of their
; own, so these stay on the body node.
[
  (initializer_expression)
  (anonymous_object_creation_expression)
  (enum_member_declaration_list)
] @fold

; A run of usings collapses as a single block, as upstream did.
(using_directive)+ @fold

; No (preproc_region) here, and #region folding is not possible from this query:
; the grammar does not nest a region's contents under the directive. The node
; covers only the `#region Helpers` line itself, with `#endregion` parsed as a
; separate sibling, so folding it would hide nothing. Region folding would need
; foldmethod=marker, which cannot coexist with the treesitter foldexpr.
[
  (preproc_if)
  (preproc_elif)
  (preproc_else)
] @fold
