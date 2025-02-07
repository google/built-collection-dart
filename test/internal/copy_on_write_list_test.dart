// Copyright (c) 2016, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:built_collection/src/internal/copy_on_write_list.dart';
import 'package:test/test.dart';

void main() {
  group('CopyOnWriteList', () {
    test('has toString equal to List.toString', () {
      var list = <int>[1, 2, 3];
      expect(CopyOnWriteList(list, false).toString(), list.toString());
    });

    test('has safe lazy behavior', () {
      var list = <int>[1, 2, 3];
      var cowList = CopyOnWriteList(list, false);
      // Once while needing to copy, once while not.
      for (var i = 1; i <= 2; i++) {
        var lazyCast = cowList.cast<num>();        
        var lazyMap = cowList.map((int x) => x);
        var lazyExpand = cowList.expand((int x) => <int>[x]);
        var lazyWhere = cowList.where((int x) => true);
        var lazyWhereType = cowList.whereType<num>();
        var lazySkip = cowList.skip(0);
        var lazyTake = cowList.take(10);
        var lazyGetRange = cowList.getRange(0, cowList.length);
        var lazySkipWhile = cowList.skipWhile((int x) => false);
        var lazyTakeWhile = cowList.takeWhile((int x) => true);
        var lazyFollowedBy = cowList.followedBy(<int>[]);
        var lazyReversed = cowList.reversed;

        // Write to list.
        cowList[0] += 1;

        // Iterables agree with list.
        expect(lazyCast.toList(), cowList.cast<num>().toList());
        expect(lazyMap.toList(), cowList.map((int x) => x).toList(),
            reason: "map");
        expect(
            lazyExpand.toList(), cowList.expand((int x) => <int>[x]).toList(),
            reason: "expand");
        expect(lazyWhere.toList(), cowList.where((int x) => true).toList(),
            reason: "where");
        expect(lazyWhereType.toList(), cowList.whereType<num>().toList(),
            reason: "whereType");
        expect(lazySkip.toList(), cowList.skip(0).toList(), reason: "skip");
        expect(lazyTake.toList(), cowList.take(10).toList(), reason: "take");
        expect(
            lazyGetRange.toList(), cowList.getRange(0, cowList.length).toList(),
            reason: "getRange");
        expect(lazySkipWhile.toList(),
            cowList.skipWhile((int x) => false).toList(),
            reason: "skipWhile");
        expect(
            lazyTakeWhile.toList(), cowList.takeWhile((int x) => true).toList(),
            reason: "takeWhile");
        expect(lazyFollowedBy.toList(), cowList.followedBy(<int>[]).toList(),
            reason: "followedBy");
        expect(lazyReversed.toList(), cowList.reversed.toList(),
            reason: "reversed");
      }
    });
  });
}
