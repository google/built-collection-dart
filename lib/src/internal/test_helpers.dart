// Copyright (c) 2020, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import '../list.dart';
import '../list_multimap.dart';
import '../map.dart';
import '../set.dart';
import '../set_multimap.dart';

/// Internal only test helpers.
class BuiltCollectionTestHelpers {
  static BuiltList<int> overridenHashcodeBuiltList(
          Iterable iterable, int hashCode) =>
      OverriddenHashCodeBuiltList<int>(iterable, hashCode);

  static BuiltListMultimap<int, String> overridenHashcodeBuiltListMultimap(
          Object map, int hashCode) =>
      OverriddenHashCodeBuiltListMultimap<int, String>(map, hashCode);

  static BuiltListMultimap<String, String>
      overridenHashcodeBuiltListMultimapWithStringKeys(
              Object map, int hashCode) =>
          OverriddenHashCodeBuiltListMultimap<String, String>(map, hashCode);

  static BuiltMap<int, String> overridenHashcodeBuiltMap(
          Object map, int hashCode) =>
      OverriddenHashCodeBuiltMap<int, String>(map, hashCode);

  static BuiltMap<String, String> overridenHashcodeBuiltMapWithStringKeys(
          Object map, int hashCode) =>
      OverriddenHashCodeBuiltMap<String, String>(map, hashCode);

  static BuiltSet<int> overridenHashcodeBuiltSet(
          Iterable iterable, int hashCode) =>
      OverriddenHashCodeBuiltSet<int>(iterable, hashCode);

  static BuiltSetMultimap<int, String> overridenHashcodeBuiltSetMultimap(
          Object map, int hashCode) =>
      OverriddenHashCodeBuiltSetMultimap<int, String>(map, hashCode);

  static BuiltSetMultimap<String, String>
      overridenHashcodeBuiltSetMultimapWithStringKeys(
              Object map, int hashCode) =>
          OverriddenHashCodeBuiltSetMultimap<String, String>(map, hashCode);
}
