// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

part of built_collection.set_multimap;

/// The Built Collection builder for [BuiltSetMultimap].
///
/// It implements the mutating part of the [SetMultimap] interface.
///
/// See the
/// [Built Collection library documentation](#built_collection/built_collection)
/// for the general properties of Built Collections.
class SetMultimapBuilder<K, V> {
  // BuiltSets copied from another instance so they can be reused directly for
  // keys without changes.
  Map<K, BuiltSet<V>> _builtMap;
  // Instance that _builtMap belongs to. If present, _builtMap must not be
  // mutated.
  BuiltSetMultimap<K, V> _builtMapOwner;
  // SetBuilders for keys that are being changed.
  Map<K, SetBuilder<V>> _builderMap;

  /// Instantiates with elements from a [Map], [SetMultimap] or
  /// [BuiltSetMultimap].
  ///
  /// Must be called with a generic type parameter.
  ///
  /// Wrong: `new SetMultimapBuilder({1: ['1'], 2: ['2'], 3: ['3']})`.
  ///
  /// Right: `new SetMultimapBuilder<int, String>({1: ['1'], 2: ['2'], 3: ['3']})`,
  ///
  /// Rejects nulls. Rejects keys and values of the wrong type.
  factory SetMultimapBuilder([multimap = const {}]) {
    return new SetMultimapBuilder<K, V>._uninitialized()..replace(multimap);
  }

  /// Converts to a [BuiltSetMultimap].
  ///
  /// The `SetMultimapBuilder` can be modified again and used to create any number
  /// of `BuiltSetMultimap`s.
  BuiltSetMultimap<K, V> build() {
    if (_builtMapOwner == null) {
      for (final key in _builderMap.keys) {
        final builtSet = _builderMap[key].build();
        if (builtSet.isEmpty) {
          _builtMap.remove(key);
        } else {
          _builtMap[key] = builtSet;
        }
      }

      _builtMapOwner = new BuiltSetMultimap<K, V>._withSafeMap(_builtMap);
    }
    return _builtMapOwner;
  }

  /// Applies a function to `this`.
  void update(updates(SetMultimapBuilder<K, V> builder)) {
    updates(this);
  }

  /// Replaces all elements with elements from a [Map], [SetMultimap] or
  /// [BuiltSetMultimap].
  void replace(multimap) {
    if (multimap is BuiltSetMultimap<K, V>) {
      _setOwner(multimap);
    } else if (multimap is Map ||
        multimap is SetMultimap ||
        multimap is BuiltSetMultimap) {
      _setWithCopyAndCheck(multimap.keys, (k) => multimap[k]);
    } else {
      throw new ArgumentError(
          'expected Map, SetMultimap or BuiltSetMultimap, got ${multimap.runtimeType}');
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

  // Based on SetMultimap.

  /// As [SetMultimap.add].
  void add(K key, V value) {
    _makeWriteableCopy();
    _checkKey(key);
    _checkValue(value);
    _getValuesBuilder(key).add(value);
  }

  /// As [SetMultimap.addValues].
  void addValues(K key, Iterable<V> values) {
    // _disown is called in add.
    values.forEach((value) {
      add(key, value);
    });
  }

  /// As [SetMultimap.addAll].
  void addAll(SetMultimap<K, V> other) {
    // _disown is called in add.
    other.forEach((key, value) {
      add(key, value);
    });
  }

  /// As [SetMultimap.remove] but returns nothing.
  void remove(Object key, V value) {
    _makeWriteableCopy();
    _getValuesBuilder(key).remove(value);
  }

  /// As [SetMultimap.removeAll] but returns nothing.
  void removeAll(Object key) {
    _makeWriteableCopy();

    _builtMap = _builtMap;
    _builderMap[key] = new SetBuilder<V>();
  }

  /// As [SetMultimap.clear].
  void clear() {
    _makeWriteableCopy();

    _builtMap.clear();
    _builderMap.clear();
  }

  // Internal.

  SetBuilder<V> _getValuesBuilder(K key) {
    var result = _builderMap[key];
    if (result == null) {
      final builtValues = _builtMap[key];
      if (builtValues == null) {
        result = new SetBuilder<V>();
      } else {
        result = builtValues.toBuilder();
      }
      _builderMap[key] = result;
    }
    return result;
  }

  void _makeWriteableCopy() {
    if (_builtMapOwner != null) {
      _builtMap = new Map<K, BuiltSet<V>>.from(_builtMap);
      _builtMapOwner = null;
    }
  }

  SetMultimapBuilder._uninitialized() {
    _checkGenericTypeParameter();
  }

  void _setOwner(BuiltSetMultimap<K, V> builtSetMultimap) {
    _builtMapOwner = builtSetMultimap;
    _builtMap = builtSetMultimap._map;
    _builderMap = new Map<K, SetBuilder<V>>();
  }

  void _setWithCopyAndCheck(Iterable keys, Function lookup) {
    _builtMapOwner = null;
    _builtMap = new Map<K, BuiltSet<V>>();
    _builderMap = new Map<K, SetBuilder<V>>();

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
          'explicit key type required, for example "new SetMultimapBuilder<int, int>"');
    }
    if (null is V && V != Object) {
      throw new UnsupportedError('explicit value type required,'
          ' for example "new SetMultimapBuilder<int, int>"');
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
