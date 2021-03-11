import 'package:html/dom.dart' as html;

Map<html.Element, double> _scoreChange(Map<html.Element, double> scoreMap) {
  final scoreDiff = <html.Element, double>{};
  for (final entry in scoreMap.entries) {
    if (entry.key.parent != null) {
      scoreDiff[entry.key] = entry.value - scoreMap[entry.key.parent!]!;
    } else {
      scoreDiff[entry.key] = entry.value;
    }
  }
  return scoreDiff;
}

/// Maps html.Node.*_NODE integer constants to a string name;
const Map<int, String> htmlNodeTypeName = {
  html.Node.ATTRIBUTE_NODE: 'ATTRIBUTTE_NODE',
  html.Node.CDATA_SECTION_NODE: 'CDATA_SECTION_NODE',
  html.Node.COMMENT_NODE: 'COMMENT_NODE',
  html.Node.DOCUMENT_FRAGMENT_NODE: 'DOCUMENT_FRAGMENT_NODE',
  html.Node.DOCUMENT_NODE: 'DOCUMENT_NODE',
  html.Node.DOCUMENT_TYPE_NODE: 'DOCUMENT_TYPE_NODE',
  html.Node.ELEMENT_NODE: 'ELEMENT_NODE',
  html.Node.ENTITY_NODE: 'ENTITY_NODE',
  html.Node.ENTITY_REFERENCE_NODE: 'ENTITY_REFERENCE_NODE',
  html.Node.NOTATION_NODE: 'NOTATION_NODE',
  html.Node.PROCESSING_INSTRUCTION_NODE: 'PROCESSING_INSTRUCTION_NODE',
  html.Node.TEXT_NODE: 'TEXT_NODE',
};

/// Returns the html.Element with the highest score from scoreMap
html.Element highestScoringElement(Map<html.Element, double> scoreMap) {
  return scoreMap.entries
      .reduce((val, elem) => val.value > elem.value ? val : elem)
      .key;
}
