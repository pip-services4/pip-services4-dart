///
//  Generated code. Do not modify.
//  source: commandable.proto
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
    const {'1': 'status', '3': 4, '4': 1, '5': 5, '10': 'status'},
    const {'1': 'message', '3': 5, '4': 1, '5': 9, '10': 'message'},
    const {'1': 'cause', '3': 6, '4': 1, '5': 9, '10': 'cause'},
    const {'1': 'stack_trace', '3': 7, '4': 1, '5': 9, '10': 'stackTrace'},
    const {
      '1': 'details',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.commandable.ErrorDescription.DetailsEntry',
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
    'ChBFcnJvckRlc2NyaXB0aW9uEhoKCGNhdGVnb3J5GAEgASgJUghjYXRlZ29yeRISCgRjb2RlGAIgASgJUgRjb2RlEiUKDmNvcnJlbGF0aW9uX2lkGAMgASgJUg1jb3JyZWxhdGlvbklkEhYKBnN0YXR1cxgEIAEoBVIGc3RhdHVzEhgKB21lc3NhZ2UYBSABKAlSB21lc3NhZ2USFAoFY2F1c2UYBiABKAlSBWNhdXNlEh8KC3N0YWNrX3RyYWNlGAcgASgJUgpzdGFja1RyYWNlEkQKB2RldGFpbHMYCCADKAsyKi5jb21tYW5kYWJsZS5FcnJvckRlc2NyaXB0aW9uLkRldGFpbHNFbnRyeVIHZGV0YWlscxo6CgxEZXRhaWxzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4AQ==');
@$core.Deprecated('Use invokeRequestDescriptor instead')
const InvokeRequest$json = const {
  '1': 'InvokeRequest',
  '2': const [
    const {'1': 'method', '3': 1, '4': 1, '5': 9, '10': 'method'},
    const {'1': 'trace_id', '3': 2, '4': 1, '5': 9, '10': 'traceId'},
    const {'1': 'args_empty', '3': 3, '4': 1, '5': 8, '10': 'argsEmpty'},
    const {'1': 'args_json', '3': 4, '4': 1, '5': 9, '10': 'argsJson'},
  ],
};

/// Descriptor for `InvokeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List invokeRequestDescriptor = $convert.base64Decode(
    'Cg1JbnZva2VSZXF1ZXN0EhYKBm1ldGhvZBgBIAEoCVIGbWV0aG9kEiUKDmNvcnJlbGF0aW9uX2lkGAIgASgJUg1jb3JyZWxhdGlvbklkEh0KCmFyZ3NfZW1wdHkYAyABKAhSCWFyZ3NFbXB0eRIbCglhcmdzX2pzb24YBCABKAlSCGFyZ3NKc29u');
@$core.Deprecated('Use invokeReplyDescriptor instead')
const InvokeReply$json = const {
  '1': 'InvokeReply',
  '2': const [
    const {
      '1': 'error',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.commandable.ErrorDescription',
      '10': 'error'
    },
    const {'1': 'result_empty', '3': 2, '4': 1, '5': 8, '10': 'resultEmpty'},
    const {'1': 'result_json', '3': 3, '4': 1, '5': 9, '10': 'resultJson'},
  ],
};

/// Descriptor for `InvokeReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List invokeReplyDescriptor = $convert.base64Decode(
    'CgtJbnZva2VSZXBseRIzCgVlcnJvchgBIAEoCzIdLmNvbW1hbmRhYmxlLkVycm9yRGVzY3JpcHRpb25SBWVycm9yEiEKDHJlc3VsdF9lbXB0eRgCIAEoCFILcmVzdWx0RW1wdHkSHwoLcmVzdWx0X2pzb24YAyABKAlSCnJlc3VsdEpzb24=');
