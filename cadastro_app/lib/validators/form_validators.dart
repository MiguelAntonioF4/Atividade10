// validators/form_validators.dart
// Funções de validação reutilizáveis para o formulário de cadastro
 
class FormValidators {
  // Lista de emails já cadastrados (simulando banco de dados)
  static const List<String> emailsCadastrados = [
    'teste@teste.com',
    'admin@admin.com',
    'usuario@email.com',
    'joao@gmail.com',
  ];
 
  /// Valida nome completo: obrigatório, mínimo 3 caracteres
  static String? validarNome(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome completo é obrigatório';
    }
    if (value.trim().length < 3) {
      return 'Nome deve ter pelo menos 3 caracteres';
    }
    if (!value.trim().contains(' ')) {
      return 'Informe o nome completo (nome e sobrenome)';
    }
    return null;
  }
 
  /// Valida email: obrigatório, formato válido com @ e domínio
  static String? validarEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-mail é obrigatório';
    }
    final regexEmail = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    if (!regexEmail.hasMatch(value.trim())) {
      return 'Informe um e-mail válido (ex: nome@dominio.com)';
    }
    return null;
  }
 
  /// Valida CPF: obrigatório, 11 dígitos numéricos
  static String? validarCpf(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'CPF é obrigatório';
    }
    // Remove pontos e traço para contar apenas dígitos
    final apenasDigitos = value.replaceAll(RegExp(r'[^\d]'), '');
    if (apenasDigitos.length != 11) {
      return 'CPF deve conter 11 dígitos';
    }
    // Verifica se todos os dígitos são iguais (CPF inválido)
    if (RegExp(r'^(\d)\1{10}$').hasMatch(apenasDigitos)) {
      return 'CPF inválido';
    }
    return null;
  }
 
  /// Valida telefone: obrigatório, formato (XX) XXXXX-XXXX
  static String? validarTelefone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Telefone é obrigatório';
    }
    final apenasDigitos = value.replaceAll(RegExp(r'[^\d]'), '');
    if (apenasDigitos.length < 10 || apenasDigitos.length > 11) {
      return 'Informe um telefone válido com DDD';
    }
    return null;
  }
 
  /// Valida data de nascimento: obrigatório, formato DD/MM/AAAA
  static String? validarDataNascimento(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Data de nascimento é obrigatória';
    }
    final regexData = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!regexData.hasMatch(value.trim())) {
      return 'Informe a data no formato DD/MM/AAAA';
    }
    final partes = value.split('/');
    final dia = int.tryParse(partes[0]);
    final mes = int.tryParse(partes[1]);
    final ano = int.tryParse(partes[2]);
 
    if (dia == null || mes == null || ano == null) {
      return 'Data inválida';
    }
    if (dia < 1 || dia > 31) return 'Dia inválido';
    if (mes < 1 || mes > 12) return 'Mês inválido';
    if (ano < 1900 || ano > DateTime.now().year) return 'Ano inválido';
 
    final dataNasc = DateTime.tryParse('$ano-${partes[1]}-${partes[0]}');
    if (dataNasc == null) return 'Data inválida';
 
    final hoje = DateTime.now();
    final idade = hoje.year -
        dataNasc.year -
        (hoje.month < dataNasc.month ||
                (hoje.month == dataNasc.month && hoje.day < dataNasc.day)
            ? 1
            : 0);
    if (idade < 0) return 'Data de nascimento não pode ser no futuro';
    if (idade < 18) return 'Você deve ter pelo menos 18 anos';
 
    return null;
  }
 
  /// Valida senha: obrigatório, mínimo 6 caracteres
  static String? validarSenha(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Senha é obrigatória';
    }
    if (value.length < 6) {
      return 'Senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }
 
  /// Valida confirmação de senha: deve ser igual à senha
  static String? validarConfirmarSenha(String? value, String? senha) {
    if (value == null || value.trim().isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }
    if (value != senha) {
      return 'As senhas não coincidem';
    }
    return null;
  }
 
  /// Valida checkbox de termos de uso
  static String? validarTermos(bool? value) {
    if (value != true) {
      return 'Você deve aceitar os termos de uso';
    }
    return null;
  }
 
  /// Simula verificação assíncrona se email já existe (chamada API fake)
  static Future<bool> emailJaCadastrado(String email) async {
    await Future.delayed(const Duration(seconds: 1)); // Simula latência de API
    return emailsCadastrados
        .contains(email.trim().toLowerCase());
  }
}