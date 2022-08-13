class Dpto {
  String? idDepto;
  String? descricao;

  Dpto({this.idDepto, this.descricao});

  Dpto.fromJson(Map<String, dynamic> json) {
    idDepto = json['id_depto'];
    descricao = json['descricao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_depto'] = this.idDepto;
    data['descricao'] = this.descricao;
    return data;
  }
}
