import 'dart:io';

String fixture(String name) {
  return File('test/fixtures/$name').readAsStringSync();
}
