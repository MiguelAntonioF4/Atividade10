// screens/cadastro_screen.dart
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../validators/form_validators.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  // ─── Chave global do formulário ─────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();

  // ─── Controllers ────────────────────────────────────────────────────────────
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _dataNascController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  // ─── FocusNodes ─────────────────────────────────────────────────────────────
  final _nomeFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _cpfFocus = FocusNode();
  final _telefoneFocus = FocusNode();
  final _dataNascFocus = FocusNode();
  final _senhaFocus = FocusNode();
  final _confirmarSenhaFocus = FocusNode();

  // ─── Máscaras (Bônus) ───────────────────────────────────────────────────────
  final _cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp(r'[0-9]')},
  );
  final _telefoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {'#': RegExp(r'[0-9]')},
  );
  final _dataMask = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  // ─── Estados ────────────────────────────────────────────────────────────────
  bool _aceitouTermos = false;
  bool _termoErro = false;
  bool _enviando = false;
  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;

  // Bônus: validação assíncrona de email
  bool _verificandoEmail = false;
  String? _emailErroAsync;

  @override
  void initState() {
    super.initState();
    // Listener para validação assíncrona ao sair do campo de email
    _emailFocus.addListener(_onEmailFocusChange);
  }

  // ─── Validação assíncrona de email (Bônus) ──────────────────────────────────
  void _onEmailFocusChange() {
    if (!_emailFocus.hasFocus) {
      _verificarEmailAsync();
    }
  }

  Future<void> _verificarEmailAsync() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) return;

    setState(() {
      _verificandoEmail = true;
      _emailErroAsync = null;
    });

    final jaCadastrado = await FormValidators.emailJaCadastrado(email);

    if (mounted) {
      setState(() {
        _verificandoEmail = false;
        if (jaCadastrado) {
          _emailErroAsync = 'Este e-mail já está cadastrado no sistema';
        }
      });
    }
  }

  // ─── Envio do formulário ────────────────────────────────────────────────────
  Future<void> _enviarFormulario() async {
    // Valida termos manualmente (checkbox não faz parte do Form)
    setState(() => _termoErro = !_aceitouTermos);

    final formValido = _formKey.currentState!.validate();
    final termosValidos = _aceitouTermos;
    final emailSemErroAsync = _emailErroAsync == null;

    if (!formValido || !termosValidos || !emailSemErroAsync) {
      _mostrarSnackBar(
        'Por favor, corrija os erros antes de continuar.',
        Colors.red.shade700,
        Icons.error_outline,
      );
      return;
    }

    // Inicia loading
    setState(() => _enviando = true);

    // Simula envio para API
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _enviando = false);

      _mostrarSnackBar(
        'Cadastro realizado com sucesso! 🎉',
        Colors.green.shade700,
        Icons.check_circle_outline,
      );

      // Bônus: exibe dialog de confirmação
      await Future.delayed(const Duration(milliseconds: 400));
      if (mounted) _mostrarDialogConfirmacao();
    }
  }

  void _mostrarSnackBar(String mensagem, Color cor, IconData icone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icone, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(mensagem)),
          ],
        ),
        backgroundColor: cor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ─── Dialog de confirmação (Bônus) ──────────────────────────────────────────
  void _mostrarDialogConfirmacao() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Cadastro Confirmado'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Confira seus dados cadastrados:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Divider(),
              _itemDialog('Nome', _nomeController.text),
              _itemDialog('E-mail', _emailController.text),
              _itemDialog('CPF', _cpfController.text),
              _itemDialog('Telefone', _telefoneController.text),
              _itemDialog('Nascimento', _dataNascController.text),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Editar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              _limparFormulario();
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  Widget _itemDialog(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ',
              style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(valor)),
        ],
      ),
    );
  }

  void _limparFormulario() {
    _formKey.currentState?.reset();
    _nomeController.clear();
    _emailController.clear();
    _cpfController.clear();
    _telefoneController.clear();
    _dataNascController.clear();
    _senhaController.clear();
    _confirmarSenhaController.clear();
    _cpfMask.clear();
    _telefoneMask.clear();
    _dataMask.clear();
    setState(() {
      _aceitouTermos = false;
      _termoErro = false;
      _emailErroAsync = null;
    });
  }

  // ─── Dispose (evitar vazamento de memória) ──────────────────────────────────
  @override
  void dispose() {
    // Controllers
    _nomeController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    _dataNascController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();

    // FocusNodes
    _emailFocus.removeListener(_onEmailFocusChange);
    _nomeFocus.dispose();
    _emailFocus.dispose();
    _cpfFocus.dispose();
    _telefoneFocus.dispose();
    _dataNascFocus.dispose();
    _senhaFocus.dispose();
    _confirmarSenhaFocus.dispose();

    super.dispose();
  }

  // ─── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final cor = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Criar Conta',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Cabeçalho
              const SizedBox(height: 8),
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0xFF6C63FF).withOpacity(0.15),
                  child: const Icon(Icons.person_add,
                      size: 44, color: Color(0xFF6C63FF)),
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Preencha seus dados para se cadastrar',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 24),

              // ── Seção: Dados Pessoais ──────────────────────────────────────
              _secaoTitulo('Dados Pessoais', Icons.person_outline),
              const SizedBox(height: 12),

              // Campo: Nome completo
              TextFormField(
                controller: _nomeController,
                focusNode: _nomeFocus,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nome completo *',
                  hintText: 'Ex: João da Silva',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_emailFocus),
                validator: FormValidators.validarNome,
              ),
              const SizedBox(height: 16),

              // Campo: Email (com validação assíncrona - Bônus)
              TextFormField(
                controller: _emailController,
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'E-mail *',
                  hintText: 'Ex: joao@email.com',
                  prefixIcon: const Icon(Icons.email_outlined),
                  errorText: _emailErroAsync,
                  suffixIcon: _verificandoEmail
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : (_emailErroAsync != null
                          ? const Icon(Icons.error, color: Colors.red)
                          : null),
                ),
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_cpfFocus),
                validator: FormValidators.validarEmail,
              ),
              const SizedBox(height: 16),

              // Campo: CPF (com máscara - Bônus)
              TextFormField(
                controller: _cpfController,
                focusNode: _cpfFocus,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [_cpfMask],
                decoration: const InputDecoration(
                  labelText: 'CPF *',
                  hintText: 'Ex: 000.000.000-00',
                  prefixIcon: Icon(Icons.fingerprint),
                ),
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_telefoneFocus),
                validator: FormValidators.validarCpf,
              ),
              const SizedBox(height: 16),

              // Campo: Telefone (com máscara - Bônus)
              TextFormField(
                controller: _telefoneController,
                focusNode: _telefoneFocus,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                inputFormatters: [_telefoneMask],
                decoration: const InputDecoration(
                  labelText: 'Telefone *',
                  hintText: 'Ex: (47) 99999-9999',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_dataNascFocus),
                validator: FormValidators.validarTelefone,
              ),
              const SizedBox(height: 16),

              // Campo: Data de nascimento (com máscara - Bônus)
              TextFormField(
                controller: _dataNascController,
                focusNode: _dataNascFocus,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [_dataMask],
                decoration: const InputDecoration(
                  labelText: 'Data de nascimento *',
                  hintText: 'Ex: 01/01/2000',
                  prefixIcon: Icon(Icons.cake_outlined),
                ),
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_senhaFocus),
                validator: FormValidators.validarDataNascimento,
              ),
              const SizedBox(height: 24),

              // ── Seção: Segurança ───────────────────────────────────────────
              _secaoTitulo('Segurança', Icons.lock_outline),
              const SizedBox(height: 12),

              // Campo: Senha
              TextFormField(
                controller: _senhaController,
                focusNode: _senhaFocus,
                obscureText: !_senhaVisivel,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Senha *',
                  hintText: 'Mínimo 6 caracteres',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _senhaVisivel
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => _senhaVisivel = !_senhaVisivel),
                  ),
                ),
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_confirmarSenhaFocus),
                validator: FormValidators.validarSenha,
              ),
              const SizedBox(height: 16),

              // Campo: Confirmar senha
              TextFormField(
                controller: _confirmarSenhaController,
                focusNode: _confirmarSenhaFocus,
                obscureText: !_confirmarSenhaVisivel,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'Confirmar senha *',
                  hintText: 'Repita a senha',
                  prefixIcon: const Icon(Icons.lock_reset_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _confirmarSenhaVisivel
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () => setState(
                        () => _confirmarSenhaVisivel = !_confirmarSenhaVisivel),
                  ),
                ),
                onFieldSubmitted: (_) => _enviarFormulario(),
                validator: (value) => FormValidators.validarConfirmarSenha(
                    value, _senhaController.text),
              ),
              const SizedBox(height: 24),

              // ── Seção: Termos de Uso ───────────────────────────────────────
              _secaoTitulo('Termos de Uso', Icons.gavel_outlined),
              const SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  color: _termoErro
                      ? Colors.red.shade50
                      : Colors.white,
                  border: Border.all(
                    color: _termoErro ? Colors.red : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CheckboxListTile(
                  value: _aceitouTermos,
                  onChanged: (val) => setState(() {
                    _aceitouTermos = val ?? false;
                    _termoErro = !_aceitouTermos;
                  }),
                  activeColor: const Color(0xFF6C63FF),
                  title: const Text(
                    'Li e aceito os Termos de Uso e a Política de Privacidade *',
                    style: TextStyle(fontSize: 14),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
              if (_termoErro)
                Padding(
                  padding:
                      const EdgeInsets.only(left: 12, top: 6),
                  child: Text(
                    'Você deve aceitar os termos de uso',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 32),

              // ── Botão de envio ─────────────────────────────────────────────
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _enviando ? null : _enviarFormulario,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _enviando
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Enviando...',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        )
                      : const Text(
                          'Criar Conta',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _secaoTitulo(String titulo, IconData icone) {
    return Row(
      children: [
        Icon(icone, color: const Color(0xFF6C63FF), size: 20),
        const SizedBox(width: 8),
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6C63FF),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Divider(color: const Color(0xFF6C63FF).withOpacity(0.3)),
        ),
      ],
    );
  }
}