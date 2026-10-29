; ModuleID = 'harness_415_s01.bc'
source_filename = "driver_CWE415_s01_bad.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @CWE415_Double_Free__malloc_free_char_01_bad() #0 !dbg !14 {
  %1 = alloca i8*, align 8
  call void @llvm.dbg.declare(metadata i8** %1, metadata !19, metadata !DIExpression()), !dbg !20
  store i8* null, i8** %1, align 8, !dbg !21
  %2 = call noalias i8* @malloc(i64 noundef 100) #3, !dbg !22
  store i8* %2, i8** %1, align 8, !dbg !23
  %3 = load i8*, i8** %1, align 8, !dbg !24
  %4 = icmp eq i8* %3, null, !dbg !26
  br i1 %4, label %5, label %6, !dbg !27

5:                                                ; preds = %0
  br label %9, !dbg !28

6:                                                ; preds = %0
  %7 = load i8*, i8** %1, align 8, !dbg !30
  call void @free(i8* noundef %7) #3, !dbg !31
  %8 = load i8*, i8** %1, align 8, !dbg !32
  call void @free(i8* noundef %8) #3, !dbg !33
  br label %9, !dbg !34

9:                                                ; preds = %6, %5
  ret void, !dbg !34
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #2

; Function Attrs: nounwind
declare void @free(i8* noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !35 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @CWE415_Double_Free__malloc_free_char_01_bad(), !dbg !39
  ret i32 0, !dbg !40
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!6, !7, !8, !9, !10, !11, !12}
!llvm.ident = !{!13}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "driver_CWE415_s01_bad.c", directory: "/home/mahima/ersp-harness-generation/mahima/CWE415_Double_Free__malloc_free_char_01", checksumkind: CSK_MD5, checksum: "e6df4fe88d296fdb531c241812f0703b")
!2 = !{!3, !5}
!3 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!6 = !{i32 7, !"Dwarf Version", i32 5}
!7 = !{i32 2, !"Debug Info Version", i32 3}
!8 = !{i32 1, !"wchar_size", i32 4}
!9 = !{i32 7, !"PIC Level", i32 2}
!10 = !{i32 7, !"PIE Level", i32 2}
!11 = !{i32 7, !"uwtable", i32 1}
!12 = !{i32 7, !"frame-pointer", i32 2}
!13 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!14 = distinct !DISubprogram(name: "CWE415_Double_Free__malloc_free_char_01_bad", scope: !15, file: !15, line: 10, type: !16, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !18)
!15 = !DIFile(filename: "./instrumented_CWE415_s01_bad.c", directory: "/home/mahima/ersp-harness-generation/mahima/CWE415_Double_Free__malloc_free_char_01", checksumkind: CSK_MD5, checksum: "fd47862a3138f543e095cd6e43c4fd69")
!16 = !DISubroutineType(types: !17)
!17 = !{null}
!18 = !{}
!19 = !DILocalVariable(name: "data", scope: !14, file: !15, line: 11, type: !3)
!20 = !DILocation(line: 11, column: 11, scope: !14)
!21 = !DILocation(line: 14, column: 10, scope: !14)
!22 = !DILocation(line: 17, column: 20, scope: !14)
!23 = !DILocation(line: 17, column: 10, scope: !14)
!24 = !DILocation(line: 18, column: 9, scope: !25)
!25 = distinct !DILexicalBlock(scope: !14, file: !15, line: 18, column: 9)
!26 = !DILocation(line: 18, column: 14, scope: !25)
!27 = !DILocation(line: 18, column: 9, scope: !14)
!28 = !DILocation(line: 20, column: 9, scope: !29)
!29 = distinct !DILexicalBlock(scope: !25, file: !15, line: 18, column: 23)
!30 = !DILocation(line: 24, column: 10, scope: !14)
!31 = !DILocation(line: 24, column: 5, scope: !14)
!32 = !DILocation(line: 27, column: 10, scope: !14)
!33 = !DILocation(line: 27, column: 5, scope: !14)
!34 = !DILocation(line: 28, column: 1, scope: !14)
!35 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 7, type: !36, scopeLine: 7, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !18)
!36 = !DISubroutineType(types: !37)
!37 = !{!38}
!38 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!39 = !DILocation(line: 9, column: 5, scope: !35)
!40 = !DILocation(line: 10, column: 5, scope: !35)
