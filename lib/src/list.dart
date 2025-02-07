// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:math' show Random;

import 'package:built_collection/src/iterable.dart' show BuiltIterable;
import 'package:built_collection/src/set.dart' show BuiltSet;

import 'internal/copy_on_write_list.dart';
import 'internal/hash.dart';
import 'internal/iterables.dart';
import 'internal/null_safety.dart';
import 'internal/type_helper.dart';

part 'list/built_list.dart';
part 'list/list_builder.dart';

// Internal only, for testing.
class OverriddenHashCodeBuiltList<T> extends _BuiltList<T> {
  final int _overriddenHashCode;

  OverriddenHashCodeBuiltList(super.iterable, this._overriddenHashCode)
      : super.from();

  @override
  // ignore: hash_and_equals
  int get hashCode => _overriddenHashCode;
}
