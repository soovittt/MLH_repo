import 'package:notifyme/utilities/helpers/sortDays.dart';
import 'package:test/test.dart';

void main() {
  group('Sort Days Test', () {
    test('Should give out [M,W,F]', () {
      var lis = sortDays(['M', 'F', 'Tu']);
      print(lis);
      expect(lis, ['M', 'Tu', 'F']);
    });
  });
}
