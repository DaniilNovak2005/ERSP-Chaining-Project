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

// 1. Define the Sink Helper (The dangerous function)
class FreeCall extends FunctionCall {
  FreeCall() {
    this.getTarget().hasName("free") and
    this.getNumberOfArguments() = 1
  }

  Expr getLen() { result = this.getArgument(0) }
}

module MemcpyConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(FunctionCall call |
      call.getTarget().getName().matches("malloc") and
      source.asExpr() = call
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(FreeCall call |
      call.getTarget().getName().matches("free") and
      sink.asExpr() = call.getLen()
    )
  }
}

module Flow = TaintTracking::Global<MemcpyConfig>;

from Flow::PathNode source, Flow::PathNode sink, FunctionCall c
where
  Flow::flowPath(source, sink)
select
  c,
  source,
  sink,
  "print statement may use freed data."