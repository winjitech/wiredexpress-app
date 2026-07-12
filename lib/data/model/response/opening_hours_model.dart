class OpeningHoursModel {
  String? _start;
  String? _end;

  OpeningHoursModel({String? start, String? end}) {
    this._start = start;
    this._end = end;
  }

  String? get start => _start;
  String? get end => _end;

  OpeningHoursModel.fromJson(Map<String?, dynamic> json) {
    _start = json['start'];
    _end = json['end'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = new Map<String?, dynamic>();
    data['start'] = this._start;
    data['end'] = this._end;

    return data;
  }
}
