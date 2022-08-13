class Local{
  int? id;
  String? data_hora;
  String? idProduto;
  String? descricao;
  String? codBarras;
  String? local;
  String? depto;
  String? status;
  Local({this.id,this.data_hora,this.idProduto,this.descricao,this.codBarras,this.local,this.depto,this.status});



  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = id;
    }
    map['data_hora'] = data_hora;
    map['id_produto'] = idProduto;
    map['descricao'] = descricao;
    map['codigo_barra'] = codBarras;
    map['local'] = local;
    map['depto'] = depto;
    map['status'] = status;
    return map;
  }
  Local.fromMapObject(Map<String, dynamic> map) {
    this.id =map['id'];
    this.data_hora =  map['data_hora'];
    this.idProduto = map['id_produto'];
    this.descricao = map['descricao'];
    this.codBarras = map['codigo_barra'];
    this.local = map['local'];
    this.depto = map['depto'];
    this.status = map['status'];
  }
}






