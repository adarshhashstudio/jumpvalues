class SignupCategory {
  SignupCategory({
    required this.id,
    required this.name,
    this.isSelected = false,
  });
  final int id;
  final String name;
  bool isSelected;
}
