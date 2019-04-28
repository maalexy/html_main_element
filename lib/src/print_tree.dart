import 'package:html/dom.dart';

/// Prints html dom with indention based on tree level
void printTree(Map<Element, dynamic> tree, Element root) {
  print(_stringChild(tree, root, 0));
}

String _stringChild(Map<Element, dynamic> tree, Element elem, int depth) {
  var par = '';
  for(var i = 0; i < depth; ++i) {
    par += '#'; // indent character
  }
  par += '$par$elem: ${tree[elem]}\n';
  for(final child in elem.children) {
    par += _stringChild(tree, child, depth + 1);
  }
  return par;
}