import 'dart:ffi';

import 'package:dart_native/src/ios/runtime.dart';
import 'package:dart_native/src/ios/foundation/internal/native_type_box.dart';
import 'package:dart_native/src/ios/runtime/id.dart';
import 'package:dart_native/src/ios/runtime/nssubclass.dart';
import 'package:ffi/ffi.dart';
import 'package:dart_native_gen/dart_native_gen.dart';

@native
class NSArray extends NSSubclass<List> {
  NSArray(List value) : super(value, _new) {
    value = List.of(value, growable: false);
  }

  NSArray.fromPointer(Pointer<Void> ptr) : super.fromPointer(ptr) {
    int count = perform(SEL('count'));
    List temp = List(count);
    for (var i = 0; i < count; i++) {
      id e = objectAtIndex(i);
      temp[i] = unboxingElementForDartCollection(e);
    }
    value = temp;
  }

  static Pointer<Void> _new(dynamic value) {
    if (value is List) {
      List boxValues = value.map((e) {
        return boxingElementForNativeCollection(e);
      }).toList();
      Pointer<Pointer<Void>> listPtr = allocate(count: boxValues.length);
      for (var i = 0; i < boxValues.length; i++) {
        listPtr.elementAt(i).value = boxValues[i].pointer;
      }
      NSObject result = Class('NSArray').perform(SEL('arrayWithObjects:count:'),
          args: [listPtr, boxValues.length]);
      free(listPtr);
      return result.pointer;
    } else {
      throw 'Invalid param when initializing NSArray.';
    }
  }

  int get count => perform(SEL('count'));

  id objectAtIndex(int index) {
    return perform(SEL('objectAtIndex:'), args: [index]);
  }
}

extension ConvertToNSArray on List {
  NSArray toNSArray() => NSArray(this);
}
