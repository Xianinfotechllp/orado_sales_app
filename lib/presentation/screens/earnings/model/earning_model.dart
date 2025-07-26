class EarningModel {
  String? date;
  int? totalEarnings;

  EarningModel({this.date, this.totalEarnings});

  EarningModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    totalEarnings = json['total_earnings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['total_earnings'] = totalEarnings;
    return data;
  }
}
