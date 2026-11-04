class OnboardingData {
  final String? fitnessGoal;
  final String? fitnessLevel;
  final int? age;
  final double? height;
  final double? weight;
  final String? biologicalSex;
  final List<String> availableDays;
  final String? preferredTime;
  final String? equipment;
  final List<String> restrictions;
  final List<String> equipmentItems;
  final String? otherEquipment;

  const OnboardingData({
    this.fitnessGoal,
    this.fitnessLevel,
    this.age,
    this.height,
    this.weight,
    this.biologicalSex,
    this.availableDays = const [],
    this.preferredTime,
    this.equipment,
    this.restrictions = const [],
    this.equipmentItems = const [],
    this.otherEquipment
  });

  OnboardingData copyWith({
    String? fitnessGoal,
    String? fitnessLevel,
    int? age,
    double? height,
    double? weight,
    String? biologicalSex,
    List<String>? availableDays,
    String? preferredTime,
    String? equipment,
    List<String>? restrictions,
  }) {
    return OnboardingData(
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      biologicalSex: biologicalSex ?? this.biologicalSex,
      availableDays: availableDays ?? this.availableDays,
      preferredTime: preferredTime ?? this.preferredTime,
      equipment: equipment ?? this.equipment,
      restrictions: restrictions ?? this.restrictions,
    );
  }
}