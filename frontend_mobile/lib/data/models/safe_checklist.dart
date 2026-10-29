class SafeChecklistItem {
  const SafeChecklistItem({
    required this.id,
    required this.text,
    required this.helpText,
  });

  final String id;
  final String text;
  final String helpText;
}

class SafeWarning {
  const SafeWarning({
    required this.title,
    required this.description,
    required this.iconKey,
  });

  final String title;
  final String description;
  final String iconKey;
}
