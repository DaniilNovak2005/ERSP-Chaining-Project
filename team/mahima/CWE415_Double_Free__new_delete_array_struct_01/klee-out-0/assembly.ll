; ModuleID = 'harness_415_s02.bc'
source_filename = "driver_CWE415_s02_bad.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.twoIntsStruct = type { i32, i32 }

; Function Attrs: mustprogress noinline optnone uwtable
define dso_local void @_Z50CWE415_Double_Free__new_delete_array_struct_01_badv() #0 !dbg !17 {
  %1 = alloca %struct.twoIntsStruct*, align 8
  call void @llvm.dbg.declare(metadata %struct.twoIntsStruct** %1, metadata !22, metadata !DIExpression()), !dbg !29
  store %struct.twoIntsStruct* null, %struct.twoIntsStruct** %1, align 8, !dbg !30
  %2 = call noalias noundef nonnull i8* @_Znam(i64 noundef 800) #5, !dbg !31, !heapallocsite !24
  %3 = bitcast i8* %2 to %struct.twoIntsStruct*, !dbg !31
  store %struct.twoIntsStruct* %3, %struct.twoIntsStruct** %1, align 8, !dbg !32
  %4 = load %struct.twoIntsStruct*, %struct.twoIntsStruct** %1, align 8, !dbg !33
  %5 = icmp eq %struct.twoIntsStruct* %4, null, !dbg !34
  br i1 %5, label %8, label %6, !dbg !34

6:                                                ; preds = %0
  %7 = bitcast %struct.twoIntsStruct* %4 to i8*, !dbg !34
  call void @_ZdaPv(i8* noundef %7) #6, !dbg !34
  br label %8, !dbg !34

8:                                                ; preds = %6, %0
  %9 = load %struct.twoIntsStruct*, %struct.twoIntsStruct** %1, align 8, !dbg !35
  %10 = icmp eq %struct.twoIntsStruct* %9, null, !dbg !36
  br i1 %10, label %13, label %11, !dbg !36

11:                                               ; preds = %8
  %12 = bitcast %struct.twoIntsStruct* %9 to i8*, !dbg !36
  call void @_ZdaPv(i8* noundef %12) #6, !dbg !36
  br label %13, !dbg !36

13:                                               ; preds = %11, %8
  ret void, !dbg !37
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nobuiltin allocsize(0)
declare noundef nonnull i8* @_Znam(i64 noundef) #2

; Function Attrs: nobuiltin nounwind
declare void @_ZdaPv(i8* noundef) #3

; Function Attrs: mustprogress noinline norecurse optnone uwtable
define dso_local noundef i32 @main() #4 !dbg !38 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @_Z50CWE415_Double_Free__new_delete_array_struct_01_badv(), !dbg !41
  ret i32 0, !dbg !42
}

attributes #0 = { mustprogress noinline optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nobuiltin allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nobuiltin nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { mustprogress noinline norecurse optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { builtin allocsize(0) }
attributes #6 = { builtin nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!9, !10, !11, !12, !13, !14, !15}
!llvm.ident = !{!16}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, imports: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "driver_CWE415_s02_bad.cpp", directory: "/home/mahima/ersp-harness-generation/mahima/CWE415_Double_Free__new_delete_array_struct_01", checksumkind: CSK_MD5, checksum: "b19eaa8b42c65bdc0a7785c5a9375ed6")
!2 = !{!3}
!3 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !4, entity: !5, file: !8, line: 58)
!4 = !DINamespace(name: "std", scope: null)
!5 = !DIDerivedType(tag: DW_TAG_typedef, name: "max_align_t", file: !6, line: 24, baseType: !7)
!6 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.0/include/__stddef_max_align_t.h", directory: "", checksumkind: CSK_MD5, checksum: "48e8e2456f77e6cda35d245130fa7259")
!7 = !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 19, size: 256, flags: DIFlagFwdDecl, identifier: "_ZTS11max_align_t")
!8 = !DIFile(filename: "/usr/bin/../lib/gcc/x86_64-linux-gnu/11/../../../../include/c++/11/cstddef", directory: "")
!9 = !{i32 7, !"Dwarf Version", i32 5}
!10 = !{i32 2, !"Debug Info Version", i32 3}
!11 = !{i32 1, !"wchar_size", i32 4}
!12 = !{i32 7, !"PIC Level", i32 2}
!13 = !{i32 7, !"PIE Level", i32 2}
!14 = !{i32 7, !"uwtable", i32 1}
!15 = !{i32 7, !"frame-pointer", i32 2}
!16 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!17 = distinct !DISubprogram(name: "CWE415_Double_Free__new_delete_array_struct_01_bad", linkageName: "_Z50CWE415_Double_Free__new_delete_array_struct_01_badv", scope: !18, file: !18, line: 13, type: !19, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !21)
!18 = !DIFile(filename: "./instrumented_CWE415_s02_bad.cpp", directory: "/home/mahima/ersp-harness-generation/mahima/CWE415_Double_Free__new_delete_array_struct_01", checksumkind: CSK_MD5, checksum: "72c3cd77daae73d3dbd5e661af7c5804")
!19 = !DISubroutineType(types: !20)
!20 = !{null}
!21 = !{}
!22 = !DILocalVariable(name: "data", scope: !17, file: !18, line: 14, type: !23)
!23 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !24, size: 64)
!24 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "twoIntsStruct", file: !18, line: 7, size: 64, flags: DIFlagTypePassByValue, elements: !25, identifier: "_ZTS13twoIntsStruct")
!25 = !{!26, !28}
!26 = !DIDerivedType(tag: DW_TAG_member, name: "intOne", scope: !24, file: !18, line: 8, baseType: !27, size: 32)
!27 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "intTwo", scope: !24, file: !18, line: 9, baseType: !27, size: 32, offset: 32)
!29 = !DILocation(line: 14, column: 21, scope: !17)
!30 = !DILocation(line: 17, column: 10, scope: !17)
!31 = !DILocation(line: 20, column: 12, scope: !17)
!32 = !DILocation(line: 20, column: 10, scope: !17)
!33 = !DILocation(line: 23, column: 15, scope: !17)
!34 = !DILocation(line: 23, column: 5, scope: !17)
!35 = !DILocation(line: 26, column: 15, scope: !17)
!36 = !DILocation(line: 26, column: 5, scope: !17)
!37 = !DILocation(line: 27, column: 1, scope: !17)
!38 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 8, type: !39, scopeLine: 8, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !21)
!39 = !DISubroutineType(types: !40)
!40 = !{!27}
!41 = !DILocation(line: 9, column: 5, scope: !38)
!42 = !DILocation(line: 10, column: 5, scope: !38)
