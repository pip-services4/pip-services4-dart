///
//  Generated code. Do not modify.
//  source: dummies.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class ErrorDescription extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ErrorDescription',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'dummies'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'category')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'code')
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'traceId')
    ..aOS(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'status')
    ..aOS(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'message')
    ..aOS(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'cause')
    ..aOS(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'stackTrace')
    ..m<$core.String, $core.String>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'details',
        entryClassName: 'ErrorDescription.DetailsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('dummies'))
    ..hasRequiredFields = false;

  ErrorDescription._() : super();
  factory ErrorDescription({
    $core.String? category,
    $core.String? code,
    $core.String? traceId,
    $core.String? status,
    $core.String? message,
    $core.String? cause,
    $core.String? stackTrace,
    $core.Map<$core.String, $core.String>? details,
  }) {
    final _result = create();
    if (category != null) {
      _result.category = category;
    }
    if (code != null) {
      _result.code = code;
    }
    if (traceId != null) {
      _result.traceId = traceId;
    }
    if (status != null) {
      _result.status = status;
    }
    if (message != null) {
      _result.message = message;
    }
    if (cause != null) {
      _result.cause = cause;
    }
    if (stackTrace != null) {
      _result.stackTrace = stackTrace;
    }
    if (details != null) {
      _result.details.addAll(details);
    }
    return _result;
  }
  factory ErrorDescription.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ErrorDescription.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ErrorDescription clone() => ErrorDescription()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ErrorDescription copyWith(void Function(ErrorDescription) updates) =>
      super.copyWith((message) => updates(message as ErrorDescription))
          as ErrorDescription; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ErrorDescription create() => ErrorDescription._();
  ErrorDescription createEmptyInstance() => create();
  static $pb.PbList<ErrorDescription> createRepeated() =>
      $pb.PbList<ErrorDescription>();
  @$core.pragma('dart2js:noInline')
  static ErrorDescription getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ErrorDescription>(create);
  static ErrorDescription? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get category => $_getSZ(0);
  @$pb.TagNumber(1)
  set category($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCategory() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategory() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get traceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set traceId($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hastraceId() => $_has(2);
  @$pb.TagNumber(3)
  void cleartraceId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get status => $_getSZ(3);
  @$pb.TagNumber(4)
  set status($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get message => $_getSZ(4);
  @$pb.TagNumber(5)
  set message($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasMessage() => $_has(4);
  @$pb.TagNumber(5)
  void clearMessage() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get cause => $_getSZ(5);
  @$pb.TagNumber(6)
  set cause($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasCause() => $_has(5);
  @$pb.TagNumber(6)
  void clearCause() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get stackTrace => $_getSZ(6);
  @$pb.TagNumber(7)
  set stackTrace($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasStackTrace() => $_has(6);
  @$pb.TagNumber(7)
  void clearStackTrace() => clearField(7);

  @$pb.TagNumber(8)
  $core.Map<$core.String, $core.String> get details => $_getMap(7);
}

class PagingParams extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PagingParams',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'dummies'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'skip')
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'take',
        $pb.PbFieldType.O3)
    ..aOB(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'total')
    ..hasRequiredFields = false;

  PagingParams._() : super();
  factory PagingParams({
    $fixnum.Int64? skip,
    $core.int? take,
    $core.bool? total,
  }) {
    final _result = create();
    if (skip != null) {
      _result.skip = skip;
    }
    if (take != null) {
      _result.take = take;
    }
    if (total != null) {
      _result.total = total;
    }
    return _result;
  }
  factory PagingParams.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PagingParams.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  PagingParams clone() => PagingParams()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  PagingParams copyWith(void Function(PagingParams) updates) =>
      super.copyWith((message) => updates(message as PagingParams))
          as PagingParams; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PagingParams create() => PagingParams._();
  PagingParams createEmptyInstance() => create();
  static $pb.PbList<PagingParams> createRepeated() =>
      $pb.PbList<PagingParams>();
  @$core.pragma('dart2js:noInline')
  static PagingParams getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PagingParams>(create);
  static PagingParams? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get skip => $_getI64(0);
  @$pb.TagNumber(1)
  set skip($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasSkip() => $_has(0);
  @$pb.TagNumber(1)
  void clearSkip() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get take => $_getIZ(1);
  @$pb.TagNumber(2)
  set take($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTake() => $_has(1);
  @$pb.TagNumber(2)
  void clearTake() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get total => $_getBF(2);
  @$pb.TagNumber(3)
  set total($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasTotal() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotal() => clearField(3);
}

class Dummy extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Dummy',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'dummies'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'id')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'key')
    ..aOS(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'content')
    ..hasRequiredFields = false;

  Dummy._() : super();
  factory Dummy({
    $core.String? id,
    $core.String? key,
    $core.String? content,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (key != null) {
      _result.key = key;
    }
    if (content != null) {
      _result.content = content;
    }
    return _result;
  }
  factory Dummy.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Dummy.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Dummy clone() => Dummy()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Dummy copyWith(void Function(Dummy) updates) =>
      super.copyWith((message) => updates(message as Dummy))
          as Dummy; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Dummy create() => Dummy._();
  Dummy createEmptyInstance() => create();
  static $pb.PbList<Dummy> createRepeated() => $pb.PbList<Dummy>();
  @$core.pragma('dart2js:noInline')
  static Dummy getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Dummy>(create);
  static Dummy? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get key => $_getSZ(1);
  @$pb.TagNumber(2)
  set key($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearKey() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get content => $_getSZ(2);
  @$pb.TagNumber(3)
  set content($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasContent() => $_has(2);
  @$pb.TagNumber(3)
  void clearContent() => clearField(3);
}

class DummiesPage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DummiesPage',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'dummies'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'total')
    ..pc<Dummy>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'data',
        $pb.PbFieldType.PM,
        subBuilder: Dummy.create)
    ..hasRequiredFields = false;

  DummiesPage._() : super();
  factory DummiesPage({
    $fixnum.Int64? total,
    $core.Iterable<Dummy>? data,
  }) {
    final _result = create();
    if (total != null) {
      _result.total = total;
    }
    if (data != null) {
      _result.data.addAll(data);
    }
    return _result;
  }
  factory DummiesPage.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DummiesPage.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DummiesPage clone() => DummiesPage()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DummiesPage copyWith(void Function(DummiesPage) updates) =>
      super.copyWith((message) => updates(message as DummiesPage))
          as DummiesPage; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DummiesPage create() => DummiesPage._();
  DummiesPage createEmptyInstance() => create();
  static $pb.PbList<DummiesPage> createRepeated() => $pb.PbList<DummiesPage>();
  @$core.pragma('dart2js:noInline')
  static DummiesPage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DummiesPage>(create);
  static DummiesPage? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get total => $_getI64(0);
  @$pb.TagNumber(1)
  set total($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTotal() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotal() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<Dummy> get data => $_getList(1);
}

class DummiesPageRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DummiesPageRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'dummies'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'traceId')
    ..m<$core.String, $core.String>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'filter',
        entryClassName: 'DummiesPageRequest.FilterEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('dummies'))
    ..aOM<PagingParams>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'paging',
        subBuilder: PagingParams.create)
    ..hasRequiredFields = false;

  DummiesPageRequest._() : super();
  factory DummiesPageRequest({
    $core.String? traceId,
    $core.Map<$core.String, $core.String>? filter,
    PagingParams? paging,
  }) {
    final _result = create();
    if (traceId != null) {
      _result.traceId = traceId;
    }
    if (filter != null) {
      _result.filter.addAll(filter);
    }
    if (paging != null) {
      _result.paging = paging;
    }
    return _result;
  }
  factory DummiesPageRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DummiesPageRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DummiesPageRequest clone() => DummiesPageRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DummiesPageRequest copyWith(void Function(DummiesPageRequest) updates) =>
      super.copyWith((message) => updates(message as DummiesPageRequest))
          as DummiesPageRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DummiesPageRequest create() => DummiesPageRequest._();
  DummiesPageRequest createEmptyInstance() => create();
  static $pb.PbList<DummiesPageRequest> createRepeated() =>
      $pb.PbList<DummiesPageRequest>();
  @$core.pragma('dart2js:noInline')
  static DummiesPageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DummiesPageRequest>(create);
  static DummiesPageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get traceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set traceId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hastraceId() => $_has(0);
  @$pb.TagNumber(1)
  void cleartraceId() => clearField(1);

  @$pb.TagNumber(2)
  $core.Map<$core.String, $core.String> get filter => $_getMap(1);

  @$pb.TagNumber(3)
  PagingParams get paging => $_getN(2);
  @$pb.TagNumber(3)
  set paging(PagingParams v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPaging() => $_has(2);
  @$pb.TagNumber(3)
  void clearPaging() => clearField(3);
  @$pb.TagNumber(3)
  PagingParams ensurePaging() => $_ensure(2);
}

class DummyIdRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DummyIdRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'dummies'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'traceId')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'dummyId')
    ..hasRequiredFields = false;

  DummyIdRequest._() : super();
  factory DummyIdRequest({
    $core.String? traceId,
    $core.String? dummyId,
  }) {
    final _result = create();
    if (traceId != null) {
      _result.traceId = traceId;
    }
    if (dummyId != null) {
      _result.dummyId = dummyId;
    }
    return _result;
  }
  factory DummyIdRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DummyIdRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DummyIdRequest clone() => DummyIdRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DummyIdRequest copyWith(void Function(DummyIdRequest) updates) =>
      super.copyWith((message) => updates(message as DummyIdRequest))
          as DummyIdRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DummyIdRequest create() => DummyIdRequest._();
  DummyIdRequest createEmptyInstance() => create();
  static $pb.PbList<DummyIdRequest> createRepeated() =>
      $pb.PbList<DummyIdRequest>();
  @$core.pragma('dart2js:noInline')
  static DummyIdRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DummyIdRequest>(create);
  static DummyIdRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get traceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set traceId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hastraceId() => $_has(0);
  @$pb.TagNumber(1)
  void cleartraceId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get dummyId => $_getSZ(1);
  @$pb.TagNumber(2)
  set dummyId($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasDummyId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDummyId() => clearField(2);
}

class DummyObjectRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DummyObjectRequest',
      package: const $pb.PackageName(
          const $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'dummies'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'traceId')
    ..aOM<Dummy>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'dummy',
        subBuilder: Dummy.create)
    ..hasRequiredFields = false;

  DummyObjectRequest._() : super();
  factory DummyObjectRequest({
    $core.String? traceId,
    Dummy? dummy,
  }) {
    final _result = create();
    if (traceId != null) {
      _result.traceId = traceId;
    }
    if (dummy != null) {
      _result.dummy = dummy;
    }
    return _result;
  }
  factory DummyObjectRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DummyObjectRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DummyObjectRequest clone() => DummyObjectRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DummyObjectRequest copyWith(void Function(DummyObjectRequest) updates) =>
      super.copyWith((message) => updates(message as DummyObjectRequest))
          as DummyObjectRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DummyObjectRequest create() => DummyObjectRequest._();
  DummyObjectRequest createEmptyInstance() => create();
  static $pb.PbList<DummyObjectRequest> createRepeated() =>
      $pb.PbList<DummyObjectRequest>();
  @$core.pragma('dart2js:noInline')
  static DummyObjectRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DummyObjectRequest>(create);
  static DummyObjectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get traceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set traceId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hastraceId() => $_has(0);
  @$pb.TagNumber(1)
  void cleartraceId() => clearField(1);

  @$pb.TagNumber(2)
  Dummy get dummy => $_getN(1);
  @$pb.TagNumber(2)
  set dummy(Dummy v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasDummy() => $_has(1);
  @$pb.TagNumber(2)
  void clearDummy() => clearField(2);
  @$pb.TagNumber(2)
  Dummy ensureDummy() => $_ensure(1);
}
