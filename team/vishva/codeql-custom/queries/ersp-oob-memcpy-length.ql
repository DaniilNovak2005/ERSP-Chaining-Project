/**
 * @name Potential OOB via tainted memcpy length
 * @description Flags memcpy calls where the length argument is tainted.
 * @kind path-problem
 * @problem.severity warning
 * @id ersp/cpp/oob-memcpy-tainted-length
 * @tags security
 * external/cwe/cwe-119
 * external/cwe/cwe-120
 */

import cpp
import semmle.code.cpp.dataflow.new.DataFlow
import semmle.code.cpp.dataflow.new.TaintTracking

class MemcpyCall extends FunctionCall {
  MemcpyCall() {
    this.getTarget().hasName("memcpy") and
    this.getNumberOfArguments() >= 3
  }
  Expr getLen()  { result = this.getArgument(2) }
}

module MemcpyLenConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) {
    // Treat all parameters as sources for V1
    exists(Parameter p | src.asParameter() = p)
  }

  predicate isSink(DataFlow::Node snk) {
    exists(MemcpyCall c |
      snk.asExpr() = c.getLen()
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
  "memcpy length argument may be influenced by untrusted input."
