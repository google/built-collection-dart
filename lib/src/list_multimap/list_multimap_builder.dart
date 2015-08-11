// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of built_collection.list_multimap;

/// The Built Collection builder for [BuiltListMultimap].
///
/// It implements the mutating part of the [ListMultimap] interface.
///
/// See the
/// [Built Collection library documentation](#built_collection/built_collection)
/// for the general properties of Built Collections.
class ListMultimapBuilder<K, V> {
  // BuiltLists copied from another instance so they can be reused directly for
  // keys without changes.
  Map<K, BuiltList<V>> _builtMap;
  // Instance that _builtMap belongs to. If present, _builtMap must not be
  // mutated.
  BuiltListMultimap<K, V> _builtMapOwner;
  // ListBuilders for keys that are being changed.
  Map<K, ListBuilder<V>> _builderMap;

  /// Instantiates with elements from a [Map], [ListMultimap] or
  /// [BuiltListMultimap].
  ///
  /// Must be called with a generic type parameter.
  ///
  /// Wrong: `new ListMultimapBuilder({1: ['1'], 2: ['2'], 3: ['3']})`.
  ///
  /// Right: `new ListMultimapBuilder<int, String>({1: ['1'], 2: ['2'], 3: ['3']})`,
  ///
  /// Rejects nulls. Rejects keys and values of the wrong type.
  factory ListMultimapBuilder([multimap = const {}]) {
    return new ListMultimapBuilder<K, V>._uninitialized()..replace(multimap);
  }

  /// Converts to a [BuiltListMultimap].
  ///
  /// The `ListMultimapBuilder` can be modified again and used to create any number
  /// of `BuiltListMultimap`s.
  BuiltListMultimap<K, V> build() {
    if (_builtMapOwner == null) {
      for (final key in _builderMap.keys) {
        final builtList = _builderMap[key].build();
        if (builtList.isEmpty) {
          _builtMap.remove(key);
        } else {
          _builtMap[key] = builtList;
        }
      }

      _builtMapOwner = new BuiltListMultimap<K, V>._withSafeMap(_builtMap);
    }
    return _builtMapOwner;
  }

  /// Applies a function to `this`.
  void update(updates(ListMultimapBuilder<K, V> builder)) {
    updates(this);
  }

  /// Replaces all elements with elements from a [Map], [ListMultimap] or
  /// [BuiltListMultimap].
  void replace(multimap) {
    if (multimap is BuiltListMultimap<K, V>) {
      _setOwner(multimap);
    } else if (multimap is Map ||
        multimap is ListMultimap ||
        multimap is BuiltListMultimap) {
      _setWithCopyAndCheck(multimap.keys, (k) => multimap[k]);
    } else {
      throw new ArgumentError(
          'expected Map, ListMultimap or BuiltListMultimap, got ${multimap.runtimeType}');
    }
  }

  /// As [Map.fromIterable] but adds.
  ///
  /// Additionally, instead of specifying a [value] function that returns an
  /// element, you may specify a [values] function that returns an [Iterable]
  /// of elements.
  void addIterable(Iterable iterable,
      {K key(element), V value(element), Iterable<V> values(element)}) {
    if (value != null && values != null) {
      throw new ArgumentError(
          'only one of value and values may be specified, got both');
    }

    if (values != null) {
      for (final element in iterable) {
        addValues(key == null ? element : key(element), values(element));
      }
    } else {
      for (final element in iterable) {
        add(key == null ? element : key(element),
            value == null ? element : value(element));
      }
    }
  }

  // Based on ListMultimap.

  /// As [ListMultimap.add].
  void add(K key, V value) {
    _makeWriteableCopy();
    _checkKey(key);
    _checkValue(value);
    _getValuesBuilder(key).add(value);
  }

  /// As [ListMultimap.addValues].
  void addValues(K key, Iterable<V> values) {
    // _disown is called in add.
    values.forEach((value) {
      add(key, value);
    });
  }

  /// As [ListMultimap.addAll].
  void addAll(ListMultimap<K, V> other) {
    // _disown is called in add.
    other.forEach((key, value) {
      add(key, value);
    });
  }

  /// As [ListMultimap.remove] but returns nothing.
  void remove(Object key, V value) {
    _makeWriteableCopy();
    _getValuesBuilder(key).remove(value);
  }

  /// As [ListMultimap.removeAll] but returns nothing.
  void removeAll(Object key) {
    _makeWriteableCopy();

    _builtMap = _builtMap;
    _builderMap[key] = new ListBuilder<V>();
  }

  /// As [ListMultimap.clear].
  void clear() {
    _makeWriteableCopy();

    _builtMap.clear();
    _builderMap.clear();
  }

  // Internal.

  ListBuilder<V> _getValuesBuilder(K key) {
    var result = _builderMap[key];
    if (result == null) {
      final builtValues = _builtMap[key];
      if (builtValues == null) {
        result = new ListBuilder<V>();
      } else {
        result = builtValues.toBuilder();
      }
      _builderMap[key] = result;
    }
    return result;
  }

  void _makeWriteableCopy() {
    if (_builtMapOwner != null) {
      _builtMap = new Map<K, BuiltList<V>>.from(_builtMap);
      _builtMapOwner = null;
    }
  }

  ListMultimapBuilder._uninitialized() {
    _checkGenericTypeParameter();
  }

  void _setOwner(BuiltListMultimap<K, V> builtListMultimap) {
    _builtMapOwner = builtListMultimap;
    _builtMap = builtListMultimap._map;
    _builderMap = new Map<K, ListBuilder<V>>();
  }

  void _setWithCopyAndCheck(Iterable keys, Function lookup) {
    _builtMapOwner = null;
    _builtMap = new Map<K, BuiltList<V>>();
    _builderMap = new Map<K, ListBuilder<V>>();

    for (final key in keys) {
      if (key is! K) {
        throw new ArgumentError('map contained invalid key: ${key}');
      }

      for (final value in lookup(key)) {
        add(key, value);
      }
    }
  }

  void _checkGenericTypeParameter() {
    if (null is K && K != Object) {
      throw new UnsupportedError(
          'explicit key type required, for example "new ListMultimapBuilder<int, int>"');
    }
    if (null is V && V != Object) {
      throw new UnsupportedError('explicit value type required,'
          ' for example "new ListMultimapBuilder<int, int>"');
    }
  }

  void _checkKey(Object key) {
    if (key is! K) {
      throw new ArgumentError('invalid key: ${key}');
    }
  }

  void _checkValue(Object value) {
    if (value is! V) {
      throw new ArgumentError('invalid value: ${value}');
    }
  }
}
