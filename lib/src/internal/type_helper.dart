// Copyright (c) 2025, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

/// Only used to test if a type parameter [T] is a subtype of some other type.
///
/// The only language-level operation for that is `is` which requires an
/// object.
class TypeHelper<T> {}

class TypeHelper2<K, V> {}
