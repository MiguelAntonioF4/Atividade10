# 📱 Cadastro App — Aula 10

Formulário de Cadastro Completo desenvolvido em Flutter para a disciplina de **Desenvolvimento para Dispositivos Móveis** — 5ª Fase ADS, Faculdade Senac Joinville (2026/1).

---

## ✅ Funcionalidades Implementadas

### Requisitos Obrigatórios
- [x] `Form` com `GlobalKey<FormState>` controlando todos os campos
- [x] `TextFormField` em todos os campos com `validate()` simultâneo
- [x] **8 campos com validação customizada:**
  - Nome completo (obrigatório, mín. 3 caracteres, nome e sobrenome)
  - E-mail (obrigatório, formato com `@` e domínio)
  - CPF (obrigatório, 11 dígitos, verifica dígitos iguais)
  - Telefone (obrigatório, formato `(XX) XXXXX-XXXX`)
  - Data de nascimento (obrigatório, `DD/MM/AAAA`, valida idade mínima 18 anos)
  - Senha (obrigatório, mínimo 6 caracteres)
  - Confirmar senha (deve ser igual à senha)
  - Checkbox aceitar termos de uso (obrigatório marcar)
- [x] `FocusNode` em cada campo com navegação automática via `requestFocus()`
- [x] `textInputAction: TextInputAction.next` em todos os campos
- [x] `dispose()` correto de todos os controllers e FocusNodes
- [x] `SnackBar` verde (sucesso) e vermelho (erro)
- [x] Loading state com `CircularProgressIndicator` no botão
- [x] Botão desabilitado durante envio (evita múltiplos cliques)
- [x] `SingleChildScrollView` para evitar overflow com teclado aberto

### 🌟 Bônus Implementados (+3.0 pontos)
- [x] **Validação assíncrona de e-mail** (+1.5): Simula chamada de API ao sair do campo; mostra `CircularProgressIndicator` no `suffixIcon`; lista hardcoded de e-mails já cadastrados
- [x] **Máscaras de entrada** (+1.0): CPF (`XXX.XXX.XXX-XX`) e Telefone (`(XX) XXXXX-XXXX`) usando `mask_text_input_formatter`; máscara de data (`DD/MM/AAAA`) como bônus extra
- [x] **Dialog de confirmação** (+0.5): Exibe dados cadastrados; botão "Editar" fecha o dialog; botão "Confirmar" limpa o formulário

---

## 🗂️ Estrutura do Projeto

```
lib/
├── main.dart                        # Ponto de entrada, configuração do tema
├── screens/
│   └── cadastro_screen.dart         # Tela principal com o formulário
└── validators/
    └── form_validators.dart         # Funções de validação reutilizáveis
```

---

## 📦 Dependências

```yaml
dependencies:
  flutter:
    sdk: flutter
  mask_text_input_formatter: ^2.4.0  # Máscaras de CPF, telefone e data
```

---

## ▶️ Como Executar

```bash
flutter pub get
flutter run
```

---

## 👥 Autores

- Miguel Antônio
- Natanael Beloqui
