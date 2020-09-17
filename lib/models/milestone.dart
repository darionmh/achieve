class Milestone {
  bool done;
  String milestone;

  Milestone({this.done, this.milestone});

  Map<String, dynamic> toJson() {
    return {'d': done, 'm': milestone};
  }

  Milestone.fromJson(Map<String, dynamic> json)
      : done = json['d'],
        milestone = json['m'];
}
