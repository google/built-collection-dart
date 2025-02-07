// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

typedef _SetFactory<E> = Set<E> Function();

class CopyOnWriteSet<E> extends Iterable<E> implements Set<E> {
  final _SetFactory<E>? _setFactory;
  bool _copyBeforeWrite;
  Set<E> _set;

  CopyOnWriteSet(this._set, [this._setFactory]) : _copyBeforeWrite = true;

  // Read-only methods: just forward.

  @override
  int get length => _set.length;

  @override
  E? lookup(Object? object) => _set.lookup(object);

  @override
  Set<E> intersection(Set<Object?> other) => _set.intersection(other);

  @override
  Set<E> union(Set<E> other) => _set.union(other);

  @override
  Set<E> difference(Set<Object?> other) => _set.difference(other);

  @override
  bool containsAll(Iterable<Object?> other) => _set.containsAll(other);

  @override
  bool any(bool Function(E) test) => _set.any(test);

  @override
  Set<T> cast<T>() => Set.castFrom<E, T>(this);

  @override
  bool contains(Object? element) => _set.contains(element);

  @override
  E elementAt(int index) => _set.elementAt(index);

  @override
  bool every(bool Function(E) test) => _set.every(test);

  @override
  Iterable<T> expand<T>(Iterable<T> Function(E) toElements) =>
      super.expand(toElements);

  @override
  E get first => _set.first;

  @override
  E firstWhere(bool Function(E) test, {E Function()? orElse}) =>
      _set.firstWhere(test, orElse: orElse);

  @override
  T fold<T>(T initialValue, T Function(T, E) combine) =>
      _set.fold(initialValue, combine);

  @override
  void forEach(void Function(E) action) => _set.forEach(action);

  @override
  bool get isEmpty => _set.isEmpty;

  @override
  bool get isNotEmpty => _set.isNotEmpty;

  @override
  Iterator<E> get iterator => _copyBeforeWrite
      ? _CopyOnWriteSetIterator<E>(this, _set.iterator)
      : _set.iterator;

  @override
  String join([String separator = '']) => _set.join(separator);

  @override
  E get last => _set.last;

  @override
  E lastWhere(bool Function(E) test, {E Function()? orElse}) =>
      _set.lastWhere(test, orElse: orElse);

  @override
  Iterable<T> map<T>(T Function(E) toElement) => super.map(toElement);

  @override
  E reduce(E Function(E, E) combine) => _set.reduce(combine);

  @override
  E get single => _set.single;

  @override
  E singleWhere(bool Function(E) test, {E Function()? orElse}) =>
      _set.singleWhere(test, orElse: orElse);

  @override
  List<E> toList({bool growable = true}) => _set.toList(growable: growable);

  @override
  Set<E> toSet() => _set.toSet();

  @override
  Iterable<T> whereType<T>() => super.whereType<T>();

  // Mutating methods: copy first if needed.

  @override
  bool add(E value) {
    _maybeCopyBeforeWrite();
    return _set.add(value);
  }

  @override
  void addAll(Iterable<E> iterable) {
    _maybeCopyBeforeWrite();
    _set.addAll(iterable);
  }

  @override
  void clear() {
    _maybeCopyBeforeWrite();
    _set.clear();
  }

  @override
  bool remove(Object? value) {
    _maybeCopyBeforeWrite();
    return _set.remove(value);
  }

  @override
  void removeWhere(bool Function(E) test) {
    _maybeCopyBeforeWrite();
    _set.removeWhere(test);
  }

  @override
  void retainWhere(bool Function(E) test) {
    _maybeCopyBeforeWrite();
    _set.retainWhere(test);
  }

  @override
  void removeAll(Iterable<Object?> elements) {
    _maybeCopyBeforeWrite();
    _set.removeAll(elements);
  }

  @override
  void retainAll(Iterable<Object?> elements) {
    _maybeCopyBeforeWrite();
    _set.retainAll(elements);
  }

  @override
  String toString() => _set.toString();

  // Internal.

  void _maybeCopyBeforeWrite() {
    if (!_copyBeforeWrite) return;
    _copyBeforeWrite = false;
    _set =
        _setFactory != null ? (_setFactory!()..addAll(_set)) : Set<E>.of(_set);
  }
}

/// Iterator wrapper on the [_wrapper._set.iterator].
///
/// Throws concurrent modification if a copy-on-write
/// copy was made (assuming that a write was also made).
class _CopyOnWriteSetIterator<E> implements Iterator<E> {
  final Iterator<E> _source;
  final CopyOnWriteSet<Object?> _wrapper;
  _CopyOnWriteSetIterator(this._wrapper, this._source);
  @override
  bool moveNext() {
    if (_wrapper._copyBeforeWrite) {
      return _source.moveNext();
    }
    throw ConcurrentModificationError(_wrapper);
  }

  @override
  E get current => _source.current;
}
