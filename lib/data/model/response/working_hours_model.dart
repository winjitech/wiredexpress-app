class WorkingHoursModel {
  bool enabled;
  List<WorkingHourRangeModel> hours;

  WorkingHoursModel({
    required this.enabled,
    required this.hours,
  });

  factory WorkingHoursModel.fromJson(Map<String, dynamic> json) {
    return WorkingHoursModel(
      enabled: json['enabled'] ?? false,
      hours: json['hours'] != null
          ? (json['hours'] as List)
          .map((e) => WorkingHourRangeModel.fromJson(e))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'hours': hours.map((e) => e.toJson()).toList(),
    };
  }
}

class WorkingHourRangeModel {
  String start;
  String end;

  WorkingHourRangeModel({
    required this.start,
    required this.end,
  });

  factory WorkingHourRangeModel.fromJson(Map<String, dynamic> json) {
    return WorkingHourRangeModel(
      start: json['start'],
      end: json['end'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
    };
  }
}