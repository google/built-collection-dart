// Copyright (c) 2016, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:built_collection/src/internal/copy_on_write_set.dart';
import 'package:test/test.dart';

void main() {
  group('CopyOnWriteSet', () {
    test('has toString equal to Set.toString', () {
      var set = <int>{1, 2, 3};
      expect(CopyOnWriteSet(set).toString(), set.toString());
    });

    test('has safe lazy behavior', () {
      var cowSet = CopyOnWriteSet<int>(<int>{1, 2, 3});
      // Once while needing to copy, once while not.
      for (var i = 1; i <= 2; i++) {
        var lazyCast = cowSet.cast<num>();
        var lazyMap = cowSet.map((int x) => x);
        var lazyExpand = cowSet.expand((int x) => <int>[x]);
        var lazyWhere = cowSet.where((int x) => true);
        var lazyWhereType = cowSet.whereType<num>();
        var lazySkip = cowSet.skip(0);
        var lazyTake = cowSet.take(10);
        var lazySkipWhile = cowSet.skipWhile((int x) => false);
        var lazyTakeWhile = cowSet.takeWhile((int x) => true);
        var lazyFollowedBy = cowSet.followedBy(<int>[]);

        // Write to list.
        cowSet.add(cowSet.length + 1);

        // Iterables agree with list.
        expect(lazyCast.toList(), cowSet.cast<num>().toList());
        expect(lazyMap.toList(), cowSet.map((int x) => x).toList(),
            reason: "map");
        expect(
            lazyExpand.toList(), cowSet.expand((int x) => <int>[x]).toList(),
            reason: "expand");
        expect(lazyWhere.toList(), cowSet.where((int x) => true).toList(),
            reason: "where");
        expect(lazyWhereType.toList(), cowSet.whereType<num>().toList(),
            reason: "whereType");
        expect(lazySkip.toList(), cowSet.skip(0).toList(), reason: "skip");
        expect(lazyTake.toList(), cowSet.take(10).toList(), reason: "take");
        expect(lazySkipWhile.toList(),
            cowSet.skipWhile((int x) => false).toList(),
            reason: "skipWhile");
        expect(
            lazyTakeWhile.toList(), cowSet.takeWhile((int x) => true).toList(),
            reason: "takeWhile");
        expect(lazyFollowedBy.toList(), cowSet.followedBy(<int>[]).toList(),
            reason: "followedBy");
      }
    });
  });
}
