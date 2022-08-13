class Produtos {
  String? iDPRODUTO;
  String? dESCRICAO;
  String? cODIGOBARRA;
  String? lOCAL;

  Produtos({this.iDPRODUTO, this.dESCRICAO, this.cODIGOBARRA, this.lOCAL});

  Produtos.fromJson(Map<String, dynamic> json) {
    iDPRODUTO = json['ID_PRODUTO'];
    dESCRICAO = json['DESCRICAO'];
    cODIGOBARRA = json['CODIGO_BARRA'];
    lOCAL = json['LOCAL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID_PRODUTO'] = this.iDPRODUTO;
    data['DESCRICAO'] = this.dESCRICAO;
    data['CODIGO_BARRA'] = this.cODIGOBARRA;
    data['LOCAL'] = this.lOCAL;
    return data;
  }
}
