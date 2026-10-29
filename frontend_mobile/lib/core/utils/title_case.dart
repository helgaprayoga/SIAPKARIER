const _titleCaseConjunctions = {
  'dan',
  'dari',
  'di',
  'ke',
  'dengan',
  'untuk',
  'yang',
  'atau',
  'pada',
  'dalam',
  'oleh',
  'saat',
  'agar',
  'serta',
};

String toTitleCase(String value) {
  if (value.trim().isEmpty) return value;
  final words = value.trim().split(RegExp(r'\s+'));
  return words.asMap().entries.map((entry) {
    final word = entry.value;
    final lower = word.toLowerCase();
    if (entry.key > 0 && _titleCaseConjunctions.contains(lower)) {
      return lower;
    }
    if (word.length > 1 && word == word.toUpperCase()) return word;
    return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
  }).join(' ');
}
