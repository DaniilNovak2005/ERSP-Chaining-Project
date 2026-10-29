/**
 * @name Use after Free call.
 * @description Flags printLine calls where data is freed.
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
import Flow::PathGraph

class FreeCall extends FunctionCall {
  FreeCall() {
    (this.getTarget().hasName("free") or this.getTarget().hasName("delete") )and
    this.getNumberOfArguments() = 1
  }

  Expr getLen() { result = this.getArgument(0) }
}

module MemcpyConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(FunctionCall fc |
      fc.getTarget().hasName("free") and
      source.asExpr() = fc.getArgument(0) 
    )
    or
    exists(DeleteExpr de |
      source.asExpr() = de.getExpr()
    )
    or
    exists(DeleteArrayExpr dae |
      source.asExpr() = dae.getExpr()
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall fc |
      fc.getTarget().getName().matches("%print%") and
      sink.asExpr() = fc.getAnArgument()
    )
  }
}

module Flow = TaintTracking::Global<MemcpyConfig>;

from Flow::PathNode source, Flow::PathNode sink, FunctionCall c
where
  Flow::flowPath(source, sink) 
select
  sink.getNode(), 
  source,
  sink,
  "This variable is used after being freed here: $@", 
  source, "Free Call"