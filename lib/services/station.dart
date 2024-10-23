class Station {
  String? id;
  double? relevance;
  double? score;
  num? weight;
  String? type;
  String? name;

  Station({
    this.id,
    this.relevance,
    this.score,
    this.weight,
    this.type,
    this.name,
  });

  Station.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    relevance = json['relevance'];
    score = json['score'];
    weight = json['weight'];
    type = json['type'];
    name = json['name'];
  }
}