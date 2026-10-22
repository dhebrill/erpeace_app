import 'package:erpeace_app/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators.required', () {
    test('rejects empty and blank values', () {
      expect(Validators.required(null), isNotNull);
      expect(Validators.required('   '), isNotNull);
    });

    test('accepts a filled value', () {
      expect(Validators.required('Produk A'), isNull);
    });
  });

  group('Validators.email', () {
    test('rejects invalid addresses', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email('bukan-email'), isNotNull);
      expect(Validators.email('user@'), isNotNull);
    });

    test('accepts valid addresses', () {
      expect(Validators.email('admin@erpeace.id'), isNull);
    });
  });

  group('Validators.password', () {
    test('enforces a minimum length', () {
      expect(Validators.password('123'), isNotNull);
      expect(Validators.password(null), isNotNull);
    });

    test('accepts a long enough password', () {
      expect(Validators.password('rahasia123'), isNull);
    });
  });

  group('Validators.fullName', () {
    test('enforces a minimum length', () {
      expect(Validators.fullName('Ab'), isNotNull);
      expect(Validators.fullName('Andi'), isNull);
    });
  });

  group('Validators numbers', () {
    test('positiveNumber accepts positive values only', () {
      expect(Validators.positiveNumber('10'), isNull);
      expect(Validators.positiveNumber('0'), isNotNull);
      expect(Validators.positiveNumber('-2'), isNotNull);
      expect(Validators.positiveNumber('abc'), isNotNull);
    });

    test('nonNegativeNumber accepts zero', () {
      expect(Validators.nonNegativeNumber('0'), isNull);
      expect(Validators.nonNegativeNumber('-1'), isNotNull);
    });

    test('parses Indonesian formatted numbers', () {
      expect(Validators.positiveNumber('1.500'), isNull);
      expect(Validators.positiveNumber('1.500,5'), isNull);
    });
  });

  group('Validators.phone', () {
    test('allows empty values', () {
      expect(Validators.phone(''), isNull);
    });

    test('rejects invalid phone numbers', () {
      expect(Validators.phone('abc'), isNotNull);
    });

    test('accepts common phone formats', () {
      expect(Validators.phone('+62 812-3456-7890'), isNull);
    });
  });
}
