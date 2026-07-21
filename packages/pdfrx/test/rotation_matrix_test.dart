import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfrx/pdfrx.dart';

void main() {
  test('rotated matrices preserve scale and viewport coordinates', () {
    final matrix = Matrix4.identity()
      ..translateByDouble(120, 80, 0, 1)
      ..rotateZ(math.pi / 2)
      ..scaleByDouble(2, 2, 2, 1);
    const viewSize = Size(300, 500);

    expect(matrix.zoom, moreOrLessEquals(2));
    expect(matrix.transformOffset(matrix.calcPosition(viewSize)), offsetMoreOrLessEquals(viewSize.center(Offset.zero)));

    final visible = matrix.calcVisibleRect(viewSize);
    expect(visible.width, moreOrLessEquals(250));
    expect(visible.height, moreOrLessEquals(150));
  });

  test('rotated matrices round-trip document and viewport points', () {
    final matrix = Matrix4.identity()
      ..translateByDouble(300, 240, 0, 1)
      ..rotateZ(math.pi / 3)
      ..scaleByDouble(4, 4, 4, 1);
    const documentPoint = Offset(70, 110);

    final viewportPoint = matrix.transformOffset(documentPoint);
    final roundTrip = Matrix4.inverted(matrix).transformOffset(viewportPoint);

    expect(roundTrip, offsetMoreOrLessEquals(documentPoint));
  });
}
