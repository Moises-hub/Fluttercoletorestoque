class LoginList {
  String? idUser;
  String? nome;
  String? senha;

  LoginList({this.idUser, this.nome, this.senha});

  LoginList.fromJson(Map<String, dynamic> json) {
    idUser = json['id_user'];
    nome = json['nome'];
    senha = json['senha'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_user'] = this.idUser;
    data['nome'] = this.nome;
    data['senha'] = this.senha;
    return data;
  }
}
