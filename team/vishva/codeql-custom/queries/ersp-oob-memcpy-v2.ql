/**
 * @name Potential OOB via tainted memcpy length (V2 Refined)
 * @description Flags memcpy calls where the length argument is tainted by argv.
 * Refinements:
 * 1. Sources restricted to 'argv' (Command Line Arguments).
 * 2. Added sanitizer for 'min' calls.
 * 3. Explicitly modeling memcpy length.
 * @kind path-problem
 * @problem.severity error
 * @id ersp/cpp/oob-memcpy-tainted-length-v2
 * @tags security
 * external/cwe/cwe-119
 */

import cpp
import semmle.code.cpp.dataflow.new.DataFlow
import semmle.code.cpp.dataflow.new.TaintTracking

// Helper class to identify memcpy calls
class MemcpyCall extends FunctionCall {
  MemcpyCall() {
    this.getTarget().hasName("memcpy") and
    this.getNumberOfArguments() >= 3
  }
  Expr getLen()  { result = this.getArgument(2) }
}

module MemcpyLenConfig implements DataFlow::ConfigSig {
  
  // REFINEMENT 1: Improve Sources
  // We manually target 'argv' (Command Line Arguments) to avoid library conflicts.
  predicate isSource(DataFlow::Node src) {
    exists(Parameter p |
      src.asParameter() = p and
      p.hasName("argv") 
    )
  }

  // REFINEMENT 2: Constrain Sinks
  // We strictly target the 'length' argument of memcpy.
  predicate isSink(DataFlow::Node snk) {
    exists(MemcpyCall c |
      snk.asExpr() = c.getLen()
    )
  }

  // REFINEMENT 3: Add Sanitizers
  // If the data passes through a 'min' function, we assume it is safe.
  predicate isBarrier(DataFlow::Node node) {
    exists(FunctionCall fc |
      fc.getTarget().hasName("min") and
      node.asExpr() = fc
    )
  }
}

module MemcpyFlow = TaintTracking::Global<MemcpyLenConfig>;
import MemcpyFlow::PathGraph

from MemcpyFlow::PathNode src, MemcpyFlow::PathNode snk, MemcpyCall c
where
  MemcpyFlow::flowPath(src, snk) and
  snk.getNode().asExpr() = c.getLen()
select
  c,
  src,
  snk,
  "memcpy length argument flows from command line arg $@",
  src, "argv"
