import 'package:html/dom.dart';

/// Prints html dom with indention based on tree level
void printTreeString(Map<Element, dynamic> tree, Element root) {
  print(buildTreeString(tree, root));
}

String buildTreeString(Map<Element, dynamic> tree, Element elem,
    [int depth = 0]) {
  var par = '';
  for (var i = 0; i < depth; ++i) {
    par += ' '; // indent character
  }
  par += '$elem: ${tree[elem]}\n';
  for (final child in elem.children) {
    par += buildTreeString(tree, child, depth + 1);
  }
  return par;
}
