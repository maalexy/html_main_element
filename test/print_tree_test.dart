import 'package:html_main_element/src/print_tree.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:test/test.dart';

Map<Element, int> _hashTree(Element x) {
  final map = <Element, int>{};
  for (final child in x.children) {
    map.addAll(_hashTree(child));
  }
  map[x] = x.outerHtml.hashCode;
  return map;
}

Map<Element, String> _textTree(Element x) {
  final map = <Element, String>{};
  for (final child in x.children) {
    map.addAll(_textTree(child));
  }
  map[x] = x.text;
  return map;
}

void main() {
  group('Typetests', () {
    const htmlText = '''
    <html>
      <head>
        <title>Very best car story.</title>
      </head>
      <body>
        <h1>The story of my car</h1>
        <div>
          <p>I once <b>had</b> a car.</p>
          <p>I bought it from a car store.</p>
          <p>But then <i>I sold it.</i></p>
          <p>Now I don't have a car.</p>
        </div>
      </body>
    </html>
    ''';

    final document = parse(htmlText);

    setUp(() {});

    test('Print hashes', () {
      final hashes = _hashTree(document.documentElement!);
      final hashTreeString = buildTreeString(hashes, document.documentElement!);
      expect(
          hashTreeString,
          '<html html>: 106303632\n'
          ' <html head>: 231538776\n'
          '  <html title>: 935009207\n'
          ' <html body>: 5890739\n'
          '  <html h1>: 177406581\n'
          '  <html div>: 1038066922\n'
          '   <html p>: 251805602\n'
          '    <html b>: 1012741316\n'
          '   <html p>: 972134644\n'
          '   <html p>: 175085301\n'
          '    <html i>: 346194556\n'
          '   <html p>: 82410424\n'
          '');
    });
    test('Print texts', () {
      final texts = _textTree(document.documentElement!);
      final textTreeString = buildTreeString(texts, document.documentElement!);
      expect(
          textTreeString,
          '<html html>: \n'
          '        Very best car story.\n'
          '      \n'
          '      \n'
          '        The story of my car\n'
          '        \n'
          '          I once had a car.\n'
          '          I bought it from a car store.\n'
          '          But then I sold it.\n'
          '          Now I don\'t have a car.\n'
          '        \n'
          '      \n'
          '    \n'
          '    \n'
          ' <html head>: \n'
          '        Very best car story.\n'
          '      \n'
          '  <html title>: Very best car story.\n'
          ' <html body>: \n'
          '        The story of my car\n'
          '        \n'
          '          I once had a car.\n'
          '          I bought it from a car store.\n'
          '          But then I sold it.\n'
          '          Now I don\'t have a car.\n'
          '        \n'
          '      \n'
          '    \n'
          '    \n'
          '  <html h1>: The story of my car\n'
          '  <html div>: \n'
          '          I once had a car.\n'
          '          I bought it from a car store.\n'
          '          But then I sold it.\n'
          '          Now I don\'t have a car.\n'
          '        \n'
          '   <html p>: I once had a car.\n'
          '    <html b>: had\n'
          '   <html p>: I bought it from a car store.\n'
          '   <html p>: But then I sold it.\n'
          '    <html i>: I sold it.\n'
          '   <html p>: Now I don\'t have a car.\n'
          '');
    });
  });
}
