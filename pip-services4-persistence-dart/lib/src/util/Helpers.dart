import "./LineRange.dart";

String? getFileExtension(String filename) {
  final fileExtensionRegex = RegExp(r'/(?:\.([^.]+))?$/');
  final fileExtension = fileExtensionRegex.firstMatch(filename)?[0];
  return fileExtension;
}

int getLinesUpToIndex(String file, int? index) {
  if (index == null) return 0;

  final fileUpToIndex = file.substring(0, index);
  return fileUpToIndex.split('\n').length - 1;
}

/// Given a file and a string, find the line number of the string in the file.
///
/// - [file]    The file that we're searching in.
/// - [searchingText]            The text to search for.
/// - [position]              The position in the file to start searching from.
/// Return      A LineRange object.
LineRange getLineRange(String file, String searchingText, [int postition = 0]) {
  final charAtStart = file.indexOf(searchingText, postition);
  final fileUpToStart = file.substring(0, charAtStart);

  final fileUpToEnd = file.substring(0, charAtStart + searchingText.length);
  return LineRange(
      fileUpToStart.split('\n').length - 1, fileUpToEnd.split('\n').length - 1);
}
