; ModuleID = 'harness_416_s02.bc'
source_filename = "driver_CWE416_s02_bad.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [9 x i8] c"A String\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @CWE416_Use_After_Free__malloc_free_char_02_bad() #0 !dbg !14 {
  %1 = alloca i8*, align 8
  call void @llvm.dbg.declare(metadata i8** %1, metadata !19, metadata !DIExpression()), !dbg !20
  store i8* null, i8** %1, align 8, !dbg !21
  %2 = call noalias i8* @malloc(i64 noundef 100) #3, !dbg !22
  store i8* %2, i8** %1, align 8, !dbg !23
  %3 = load i8*, i8** %1, align 8, !dbg !24
  %4 = icmp eq i8* %3, null, !dbg !26
  br i1 %4, label %5, label %6, !dbg !27

5:                                                ; preds = %0
  br label %11, !dbg !28

6:                                                ; preds = %0
  %7 = load i8*, i8** %1, align 8, !dbg !30
  %8 = call i8* @strcpy(i8* noundef %7, i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str, i64 0, i64 0)) #3, !dbg !31
  %9 = load i8*, i8** %1, align 8, !dbg !32
  call void @free(i8* noundef %9) #3, !dbg !33
  %10 = load i8*, i8** %1, align 8, !dbg !34
  call void @printLine(i8* noundef %10), !dbg !35
  br label %11, !dbg !36

11:                                               ; preds = %6, %5
  ret void, !dbg !36
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #2

; Function Attrs: nounwind
declare i8* @strcpy(i8* noundef, i8* noundef) #2

; Function Attrs: nounwind
declare void @free(i8* noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define internal void @printLine(i8* noundef %0) #0 !dbg !37 {
  %2 = alloca i8*, align 8
  %3 = alloca i8, align 1
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !40, metadata !DIExpression()), !dbg !41
  %4 = load i8*, i8** %2, align 8, !dbg !42
  %5 = icmp ne i8* %4, null, !dbg !42
  br i1 %5, label %7, label %6, !dbg !44

6:                                                ; preds = %1
  br label %12, !dbg !45

7:                                                ; preds = %1
  call void @llvm.dbg.declare(metadata i8* %3, metadata !46, metadata !DIExpression()), !dbg !48
  %8 = load i8*, i8** %2, align 8, !dbg !49
  %9 = getelementptr inbounds i8, i8* %8, i64 0, !dbg !49
  %10 = load i8, i8* %9, align 1, !dbg !49
  store volatile i8 %10, i8* %3, align 1, !dbg !48
  %11 = load volatile i8, i8* %3, align 1, !dbg !50
  br label %12, !dbg !51

12:                                               ; preds = %7, %6
  ret void, !dbg !51
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !52 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @CWE416_Use_After_Free__malloc_free_char_02_bad(), !dbg !56
  ret i32 0, !dbg !57
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!6, !7, !8, !9, !10, !11, !12}
!llvm.ident = !{!13}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "driver_CWE416_s02_bad.c", directory: "/home/mahima/ersp-harness-generation/mahima/CWE416_Use_After_Free__malloc_free_char_02", checksumkind: CSK_MD5, checksum: "d6d0318dbeea55574e7ca881cb4b350d")
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
!14 = distinct !DISubprogram(name: "CWE416_Use_After_Free__malloc_free_char_02_bad", scope: !15, file: !15, line: 19, type: !16, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !18)
!15 = !DIFile(filename: "./instrumented_CWE416_s02_bad.c", directory: "/home/mahima/ersp-harness-generation/mahima/CWE416_Use_After_Free__malloc_free_char_02", checksumkind: CSK_MD5, checksum: "ebfe7b45baa039f6f6f03787d8de2e82")
!16 = !DISubroutineType(types: !17)
!17 = !{null}
!18 = !{}
!19 = !DILocalVariable(name: "data", scope: !14, file: !15, line: 20, type: !3)
!20 = !DILocation(line: 20, column: 11, scope: !14)
!21 = !DILocation(line: 22, column: 10, scope: !14)
!22 = !DILocation(line: 25, column: 20, scope: !14)
!23 = !DILocation(line: 25, column: 10, scope: !14)
!24 = !DILocation(line: 26, column: 9, scope: !25)
!25 = distinct !DILexicalBlock(scope: !14, file: !15, line: 26, column: 9)
!26 = !DILocation(line: 26, column: 14, scope: !25)
!27 = !DILocation(line: 26, column: 9, scope: !14)
!28 = !DILocation(line: 28, column: 9, scope: !29)
!29 = distinct !DILexicalBlock(scope: !25, file: !15, line: 26, column: 23)
!30 = !DILocation(line: 32, column: 12, scope: !14)
!31 = !DILocation(line: 32, column: 5, scope: !14)
!32 = !DILocation(line: 35, column: 10, scope: !14)
!33 = !DILocation(line: 35, column: 5, scope: !14)
!34 = !DILocation(line: 38, column: 15, scope: !14)
!35 = !DILocation(line: 38, column: 5, scope: !14)
!36 = !DILocation(line: 39, column: 1, scope: !14)
!37 = distinct !DISubprogram(name: "printLine", scope: !15, file: !15, line: 9, type: !38, scopeLine: 9, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !18)
!38 = !DISubroutineType(types: !39)
!39 = !{null, !3}
!40 = !DILocalVariable(name: "str", arg: 1, scope: !37, file: !15, line: 9, type: !3)
!41 = !DILocation(line: 9, column: 29, scope: !37)
!42 = !DILocation(line: 10, column: 10, scope: !43)
!43 = distinct !DILexicalBlock(scope: !37, file: !15, line: 10, column: 9)
!44 = !DILocation(line: 10, column: 9, scope: !37)
!45 = !DILocation(line: 10, column: 15, scope: !43)
!46 = !DILocalVariable(name: "c", scope: !37, file: !15, line: 14, type: !47)
!47 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !4)
!48 = !DILocation(line: 14, column: 19, scope: !37)
!49 = !DILocation(line: 14, column: 23, scope: !37)
!50 = !DILocation(line: 15, column: 11, scope: !37)
!51 = !DILocation(line: 16, column: 1, scope: !37)
!52 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 5, type: !53, scopeLine: 5, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !18)
!53 = !DISubroutineType(types: !54)
!54 = !{!55}
!55 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!56 = !DILocation(line: 6, column: 5, scope: !52)
!57 = !DILocation(line: 7, column: 5, scope: !52)
