import 'package:notifyme/utilities/helpers/stringsplitter.dart';
import 'package:test/test.dart';

void main() {
  group('String Split Func', () {
    test('Should give out [M,W,F]]', () {
      var stringSplitFunc = stringSplit("MWF");
      print(stringSplitFunc);
      expect(stringSplitFunc, ['M', 'W', 'F']);
    });

    test('Should give out [M,W]]', () {
      var stringSplitFunc = stringSplit("MW");
      print(stringSplitFunc);
      expect(stringSplitFunc, ['M', 'W']);
    });

    test('Should give out [Tu,Th]]', () {
      var stringSplitFunc = stringSplit("TuTh");
      print(stringSplitFunc);
      expect(stringSplitFunc, ['Tu', 'Th']);
    });

    test('Should give out [M,Tu]]', () {
      var stringSplitFunc = stringSplit("MTu");
      print(stringSplitFunc);
      expect(stringSplitFunc, ['M', 'Tu']);
    });
  });
}
