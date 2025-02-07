// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:collection' show ListBase;
import 'dart:math';

class CopyOnWriteList<E> extends ListBase<E> {
  bool _copyBeforeWrite;
  final bool _growable;
  List<E> _list;

  CopyOnWriteList(this._list, this._growable) : _copyBeforeWrite = true;

  // Read-only methods returning values: just forward.
  // Methods returning a lazy view use default list implementation
  // until first write, to avoid capturing a `_list` which may be replaced
  // on a write.

  @override
  int get length => _list.length;

  @override
  E operator [](int index) => _list[index];

  @override
  List<E> operator +(List<E> other) => _list + other;

  @override
  bool any(bool Function(E) test) => _list.any(test);

  @override
  Map<int, E> asMap() => _copyBeforeWrite ? super.asMap() : _list.asMap();

  @override
  List<T> cast<T>() => _copyBeforeWrite ? super.cast<T>() : _list.cast<T>();

  @override
  bool contains(Object? element) => _list.contains(element);

  @override
  E elementAt(int index) => _list.elementAt(index);

  @override
  bool every(bool Function(E) test) => _list.every(test);

  @override
  Iterable<T> expand<T>(Iterable<T> Function(E) f) =>
      _copyBeforeWrite ? super.expand<T>(f) : _list.expand(f);

  @override
  E get first => _list.first;

  @override
  E firstWhere(bool Function(E) test, {E Function()? orElse}) =>
      _list.firstWhere(test, orElse: orElse);

  @override
  T fold<T>(T initialValue, T Function(T, E) combine) =>
      _list.fold(initialValue, combine);

  @override
  Iterable<E> followedBy(Iterable<E> other) =>
      _copyBeforeWrite ? super.followedBy(other) : _list.followedBy(other);

  @override
  void forEach(void Function(E) action) => _list.forEach(action);

  @override
  Iterable<E> getRange(int start, int end) => _copyBeforeWrite
      ? super.getRange(start, end)
      : _list.getRange(start, end);

  @override
  int indexOf(covariant E element, [int start = 0]) =>
      _list.indexOf(element, start);

  @override
  int indexWhere(bool Function(E) test, [int start = 0]) =>
      _list.indexWhere(test, start);

  @override
  bool get isEmpty => _list.isEmpty;

  @override
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  Iterator<E> get iterator =>
      _copyBeforeWrite ? super.iterator : _list.iterator;

  @override
  String join([String separator = '']) => _list.join(separator);

  @override
  E get last => _list.last;

  @override
  int lastIndexOf(covariant E element, [int? start]) =>
      _list.lastIndexOf(element, start);

  @override
  int lastIndexWhere(bool Function(E) test, [int? start]) =>
      _list.lastIndexWhere(test, start);

  @override
  E lastWhere(bool Function(E) test, {E Function()? orElse}) =>
      _list.lastWhere(test, orElse: orElse);

  @override
  Iterable<T> map<T>(T Function(E) f) =>
      _copyBeforeWrite ? super.map(f) : _list.map(f);

  @override
  E reduce(E Function(E, E) combine) => _list.reduce(combine);

  @override
  Iterable<E> get reversed =>
      _copyBeforeWrite ? super.reversed : _list.reversed;

  @override
  E get single => _list.single;

  @override
  E singleWhere(bool Function(E) test, {E Function()? orElse}) =>
      _list.singleWhere(test, orElse: orElse);

  @override
  Iterable<E> skip(int count) =>
      _copyBeforeWrite ? super.skip(count) : _list.skip(count);

  @override
  Iterable<E> skipWhile(bool Function(E) test) =>
      _copyBeforeWrite ? super.skipWhile(test) : _list.skipWhile(test);

  @override
  List<E> sublist(int start, [int? end]) => _list.sublist(start, end);

  @override
  Iterable<E> take(int count) =>
      _copyBeforeWrite ? super.take(count) : _list.take(count);

  @override
  Iterable<E> takeWhile(bool Function(E) test) =>
      _copyBeforeWrite ? super.takeWhile(test) : _list.takeWhile(test);

  @override
  List<E> toList({bool growable = true}) => _list.toList(growable: growable);

  @override
  Set<E> toSet() => _list.toSet();

  @override
  Iterable<E> where(bool Function(E) test) =>
      _copyBeforeWrite ? super.where(test) : _list.where(test);

  @override
  Iterable<T> whereType<T>() =>
      _copyBeforeWrite ? super.whereType<T>() : _list.whereType<T>();

  // Mutating methods: copy first if needed.

  @override
  set length(int length) {
    _maybeCopyBeforeWrite();
    _list.length = length;
  }

  @override
  void operator []=(int index, E element) {
    _maybeCopyBeforeWrite();
    _list[index] = element;
  }

  @override
  set first(E element) {
    _maybeCopyBeforeWrite();
    _list.first = element;
  }

  @override
  set last(E element) {
    _maybeCopyBeforeWrite();
    _list.last = element;
  }

  @override
  void add(E element) {
    _maybeCopyBeforeWrite();
    _list.add(element);
  }

  @override
  void addAll(Iterable<E> iterable) {
    _maybeCopyBeforeWrite();
    _list.addAll(iterable);
  }

  @override
  void sort([int Function(E, E)? compare]) {
    _maybeCopyBeforeWrite();
    _list.sort(compare);
  }

  @override
  void shuffle([Random? random]) {
    _maybeCopyBeforeWrite();
    _list.shuffle(random);
  }

  @override
  void clear() {
    _maybeCopyBeforeWrite();
    _list.clear();
  }

  @override
  void insert(int index, E element) {
    _maybeCopyBeforeWrite();
    _list.insert(index, element);
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    _maybeCopyBeforeWrite();
    _list.insertAll(index, iterable);
  }

  @override
  void setAll(int index, Iterable<E> iterable) {
    _maybeCopyBeforeWrite();
    _list.setAll(index, iterable);
  }

  @override
  bool remove(Object? element) {
    _maybeCopyBeforeWrite();
    return _list.remove(element);
  }

  @override
  E removeAt(int index) {
    _maybeCopyBeforeWrite();
    return _list.removeAt(index);
  }

  @override
  E removeLast() {
    _maybeCopyBeforeWrite();
    return _list.removeLast();
  }

  @override
  void removeWhere(bool Function(E) test) {
    _maybeCopyBeforeWrite();
    _list.removeWhere(test);
  }

  @override
  void retainWhere(bool Function(E) test) {
    _maybeCopyBeforeWrite();
    _list.retainWhere(test);
  }

  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    _maybeCopyBeforeWrite();
    _list.setRange(start, end, iterable, skipCount);
  }

  @override
  void removeRange(int start, int end) {
    _maybeCopyBeforeWrite();
    _list.removeRange(start, end);
  }

  @override
  void fillRange(int start, int end, [E? fill]) {
    _maybeCopyBeforeWrite();
    _list.fillRange(start, end, fill);
  }

  @override
  void replaceRange(int start, int end, Iterable<E> newContents) {
    _maybeCopyBeforeWrite();
    _list.replaceRange(start, end, newContents);
  }

  @override
  String toString() => _list.toString();

  // Internal.

  void _maybeCopyBeforeWrite() {
    if (!_copyBeforeWrite) return;
    _copyBeforeWrite = false;
    _list = List<E>.of(_list, growable: _growable);
  }
}
