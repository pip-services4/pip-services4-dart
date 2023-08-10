///
//  Generated code. Do not modify.
//  source: dummies.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use errorDescriptionDescriptor instead')
const ErrorDescription$json = const {
  '1': 'ErrorDescription',
  '2': const [
    const {'1': 'category', '3': 1, '4': 1, '5': 9, '10': 'category'},
    const {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    const {'1': 'trace_id', '3': 3, '4': 1, '5': 9, '10': 'traceId'},
    const {'1': 'status', '3': 4, '4': 1, '5': 9, '10': 'status'},
    const {'1': 'message', '3': 5, '4': 1, '5': 9, '10': 'message'},
    const {'1': 'cause', '3': 6, '4': 1, '5': 9, '10': 'cause'},
    const {'1': 'stack_trace', '3': 7, '4': 1, '5': 9, '10': 'stackTrace'},
    const {
      '1': 'details',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.dummies.ErrorDescription.DetailsEntry',
      '10': 'details'
    },
  ],
  '3': const [ErrorDescription_DetailsEntry$json],
};

@$core.Deprecated('Use errorDescriptionDescriptor instead')
const ErrorDescription_DetailsEntry$json = const {
  '1': 'DetailsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `ErrorDescription`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List errorDescriptionDescriptor = $convert.base64Decode(
    'ChBFcnJvckRlc2NyaXB0aW9uEhoKCGNhdGVnb3J5GAEgASgJUghjYXRlZ29yeRISCgRjb2RlGAIgASgJUgRjb2RlEiUKDmNvcnJlbGF0aW9uX2lkGAMgASgJUg1jb3JyZWxhdGlvbklkEhYKBnN0YXR1cxgEIAEoCVIGc3RhdHVzEhgKB21lc3NhZ2UYBSABKAlSB21lc3NhZ2USFAoFY2F1c2UYBiABKAlSBWNhdXNlEh8KC3N0YWNrX3RyYWNlGAcgASgJUgpzdGFja1RyYWNlEkAKB2RldGFpbHMYCCADKAsyJi5kdW1taWVzLkVycm9yRGVzY3JpcHRpb24uRGV0YWlsc0VudHJ5UgdkZXRhaWxzGjoKDERldGFpbHNFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgB');
@$core.Deprecated('Use pagingParamsDescriptor instead')
const PagingParams$json = const {
  '1': 'PagingParams',
  '2': const [
    const {'1': 'skip', '3': 1, '4': 1, '5': 3, '10': 'skip'},
    const {'1': 'take', '3': 2, '4': 1, '5': 5, '10': 'take'},
    const {'1': 'total', '3': 3, '4': 1, '5': 8, '10': 'total'},
  ],
};

/// Descriptor for `PagingParams`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pagingParamsDescriptor = $convert.base64Decode(
    'CgxQYWdpbmdQYXJhbXMSEgoEc2tpcBgBIAEoA1IEc2tpcBISCgR0YWtlGAIgASgFUgR0YWtlEhQKBXRvdGFsGAMgASgIUgV0b3RhbA==');
@$core.Deprecated('Use dummyDescriptor instead')
const Dummy$json = const {
  '1': 'Dummy',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'key', '3': 2, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'content', '3': 3, '4': 1, '5': 9, '10': 'content'},
  ],
};

/// Descriptor for `Dummy`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dummyDescriptor = $convert.base64Decode(
    'CgVEdW1teRIOCgJpZBgBIAEoCVICaWQSEAoDa2V5GAIgASgJUgNrZXkSGAoHY29udGVudBgDIAEoCVIHY29udGVudA==');
@$core.Deprecated('Use dummiesPageDescriptor instead')
const DummiesPage$json = const {
  '1': 'DummiesPage',
  '2': const [
    const {'1': 'total', '3': 1, '4': 1, '5': 3, '10': 'total'},
    const {
      '1': 'data',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.dummies.Dummy',
      '10': 'data'
    },
  ],
};

/// Descriptor for `DummiesPage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dummiesPageDescriptor = $convert.base64Decode(
    'CgtEdW1taWVzUGFnZRIUCgV0b3RhbBgBIAEoA1IFdG90YWwSIgoEZGF0YRgCIAMoCzIOLmR1bW1pZXMuRHVtbXlSBGRhdGE=');
@$core.Deprecated('Use dummiesPageRequestDescriptor instead')
const DummiesPageRequest$json = const {
  '1': 'DummiesPageRequest',
  '2': const [
    const {'1': 'trace_id', '3': 1, '4': 1, '5': 9, '10': 'traceId'},
    const {
      '1': 'filter',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.dummies.DummiesPageRequest.FilterEntry',
      '10': 'filter'
    },
    const {
      '1': 'paging',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.dummies.PagingParams',
      '10': 'paging'
    },
  ],
  '3': const [DummiesPageRequest_FilterEntry$json],
};

@$core.Deprecated('Use dummiesPageRequestDescriptor instead')
const DummiesPageRequest_FilterEntry$json = const {
  '1': 'FilterEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': const {'7': true},
};

/// Descriptor for `DummiesPageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dummiesPageRequestDescriptor = $convert.base64Decode(
    'ChJEdW1taWVzUGFnZVJlcXVlc3QSJQoOY29ycmVsYXRpb25faWQYASABKAlSDWNvcnJlbGF0aW9uSWQSPwoGZmlsdGVyGAIgAygLMicuZHVtbWllcy5EdW1taWVzUGFnZVJlcXVlc3QuRmlsdGVyRW50cnlSBmZpbHRlchItCgZwYWdpbmcYAyABKAsyFS5kdW1taWVzLlBhZ2luZ1BhcmFtc1IGcGFnaW5nGjkKC0ZpbHRlckVudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAE=');
@$core.Deprecated('Use dummyIdRequestDescriptor instead')
const DummyIdRequest$json = const {
  '1': 'DummyIdRequest',
  '2': const [
    const {'1': 'trace_id', '3': 1, '4': 1, '5': 9, '10': 'traceId'},
    const {'1': 'dummy_id', '3': 2, '4': 1, '5': 9, '10': 'dummyId'},
  ],
};

/// Descriptor for `DummyIdRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dummyIdRequestDescriptor = $convert.base64Decode(
    'Cg5EdW1teUlkUmVxdWVzdBIlCg5jb3JyZWxhdGlvbl9pZBgBIAEoCVINY29ycmVsYXRpb25JZBIZCghkdW1teV9pZBgCIAEoCVIHZHVtbXlJZA==');
@$core.Deprecated('Use dummyObjectRequestDescriptor instead')
const DummyObjectRequest$json = const {
  '1': 'DummyObjectRequest',
  '2': const [
    const {'1': 'trace_id', '3': 1, '4': 1, '5': 9, '10': 'traceId'},
    const {
      '1': 'dummy',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.dummies.Dummy',
      '10': 'dummy'
    },
  ],
};

/// Descriptor for `DummyObjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dummyObjectRequestDescriptor = $convert.base64Decode(
    'ChJEdW1teU9iamVjdFJlcXVlc3QSJQoOY29ycmVsYXRpb25faWQYASABKAlSDWNvcnJlbGF0aW9uSWQSJAoFZHVtbXkYAiABKAsyDi5kdW1taWVzLkR1bW15UgVkdW1teQ==');
