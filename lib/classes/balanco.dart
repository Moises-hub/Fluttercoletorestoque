class Balanco{
  String? id;
  String? data_hora;
  String? id_usuario;
  String? depto;
  String? tipo;
  String? status;

  Balanco({this.id,this.data_hora,this.id_usuario,this.tipo,this.status,this.depto});



  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['id'] = id;
    map['data_hora'] = data_hora;
    map['id_usuario'] = id_usuario;
    map['depto'] = depto;
    map['tipo'] = tipo;
    map['status'] = status;
    return map;
  }
  Balanco.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.data_hora = map['data_hora'];
    this.id_usuario = map['id_usuario'];
    this.depto = map['depto'];
    this.status = map['status'];
    this.tipo = map['tipo'];

  }
}


/*  String colIdBalanco = 'idBalanco';
  String colIdItem = 'idItem';
  String colIdProduto = 'id_produto';
  String colCodigo_barra = 'codigo_barra';
  String colDescricao = 'descricao';
  String colQnt = 'qnt';
  String colLocal = 'local';*/

class Balanco_itens{
  String? idBalanco;
  int? iditem;
  String? idProduto;
  String? descricao;
  String? codBarras;
  double? qnt;
  String? local;

  Balanco_itens({this.idBalanco,this.iditem,this.idProduto,this.descricao,this.codBarras,this.qnt,this.local});



  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['idBalanco'] = idBalanco;
    if (iditem != null) {
      map['idItem'] = iditem;
    }
    map['id_produto'] = idProduto;
    map['descricao'] = descricao;
    map['codigo_barra'] = codBarras;
    map['qnt'] = qnt;
    map['local'] = local;
    return map;
  }
  Balanco_itens.fromMapObject(Map<String, dynamic> map) {
    this.idBalanco = map['idBalanco'];
    this.iditem = map['idItem'];
    this.idProduto = map['id_produto'];
    this.descricao = map['descricao'];
    this.codBarras = map['codigo_barra'];
    this.qnt = map['qnt'];
    this.local = map['local'];
  }
}