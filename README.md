# ServeRest API - Testes Automatizados

Este repositório contém testes automatizados para a API ServeRest usando Robot Framework, além de documentação completa de testes e collections Postman.

## 🚀 Sobre o Projeto

ServeRest é uma API REST que simula uma loja virtual, utilizada para estudos e testes de API. Este projeto implementa uma suíte completa de testes automatizados cobrindo todos os endpoints principais.

## 📋 Pré-requisitos

- **Python 3.8+**
- **Robot Framework 6.0+**
- **RequestsLibrary**

## 🔧 Instalação

1. Clone o repositório:
```bash
git clone <url-do-repositorio>
cd ServeRest-API
```

2. Instale as dependências:
```bash
pip install robotframework
pip install robotframework-requests
```

## ▶️ Como Executar os Testes

### Executar todos os testes:
```bash
# Suíte completa
robot --outputdir results tests/robot/suites/
```

### Executar testes específicos:
```bash
# Apenas usuários
robot --outputdir results tests/robot/suites/test_usuarios.robot

# Apenas login
robot --outputdir results tests/robot/suites/test_login.robot

# Apenas produtos
robot --outputdir results tests/robot/suites/test_produtos.robot

# Apenas carrinhos
robot --outputdir results tests/robot/suites/test_carrinhos.robot
```

### Executar por tags:
```bash
# Apenas testes críticos
robot --include high --outputdir results tests/robot/suites/

# Apenas testes de smoke
robot --include smoke --outputdir results tests/robot/suites/

# Apenas testes positivos
robot --include positivo --outputdir results tests/robot/suites/

# Apenas métodos POST
robot --include post --outputdir results tests/robot/suites/

# Apenas testes de admin
robot --include admin --outputdir results tests/robot/suites/

# Excluir bugs conhecidos
robot --exclude bug_known --outputdir results tests/robot/suites/

# Combinar tags (smoke E positivo)
robot --include smokeANDpositivo --outputdir results tests/robot/suites/

# Testes de validação
robot --include validation --outputdir results tests/robot/suites/
```

## 📊 Relatórios

Após a execução, os relatórios estarão disponíveis em:
- **`results/report.html`** - Relatório resumido
- **`results/log.html`** - Log detalhado da execução
- **`results/output.xml`** - Dados em XML para integração

## 🌐 Configuração de Ambientes

### Ambientes Disponíveis:
- **Público:** `https://serverest.dev` (padrão)
- **Local:** `http://localhost:3000`
- **EC2:** `http://SEU-IP-EC2:3000`

### Para trocar ambiente:
1. Edite `config/environments.robot`
2. Altere a variável `${BASE_URL}` para o ambiente desejado
3. Execute os testes normalmente

## 🏗️ Estrutura do Projeto

```
ServeRest-API/
├── docs/                   # Documentação de testes
│   ├── original/
│   ├── corrigido/
│   └── challenge-02/
├── collections/
│   └── postman/           # Collections Postman
├── config/
│   └── environments.robot # Configurações de ambiente
├── scripts/
│   ├── setup_ec2.sh      # Setup ServeRest na EC2
│   └── setup_tests_ec2.sh # Setup testes na EC2
├── tests/
│   └── robot/             # Testes Robot Framework
│       ├── keywords/      # Keywords customizadas
│       ├── resources/     # Recursos compartilhados
│       ├── suites/        # Suítes de teste
│       │   ├── test_usuarios.robot
│       │   ├── test_login.robot
│       │   ├── test_produtos.robot
│       │   └── test_carrinhos.robot
│       └── variables/     # Configurações
├── results/               # Relatórios (ignorado no git)
├── .gitignore
└── README.md
```

## 🧪 Cobertura de Testes

### ✅ Implementados (40 cenários)

**Usuários (15 testes):**
- TC001 - Criar usuário válido
- TC002 - Listar usuários
- TC003 - Buscar usuário por ID
- TC004 - Atualizar usuário
- TC006 - Deletar usuário
- TC007 - Criar usuário administrador
- TC008 - Criar usuário não-administrador
- TC009 - Validar campos obrigatórios
- TC010 - Validar estrutura JSON
- TC011 - Email duplicado
- TC014 - Email domínio inválido
- TC020 - Buscar usuário inexistente
- TC023 - Nome com caracteres especiais
- TC024 - Nome com emojis
- TC025 - Senha limite (bug conhecido)

**Login (8 testes):**
- TC026 - Login válido
- TC027 - Estrutura do token
- TC028 - Expiração do token
- TC029 - Login administrador
- TC030 - Email inexistente
- TC031 - Senha incorreta
- TC032 - Email em branco
- TC033 - Password em branco

**Produtos (10 testes):**
- TC038 - Listar produtos
- TC039 - Criar produto com token
- TC040 - Query parameters
- TC041 - Buscar produto por ID
- TC042 - Atualizar produto
- TC043 - Criar via PUT
- TC044 - Deletar produto
- TC045 - Estrutura resposta
- TC046 - Criar sem token
- TC049 - Nome duplicado

**Carrinhos (7 testes):**
- TC058 - Listar carrinhos
- TC059 - Criar carrinho
- TC060 - Buscar por ID
- TC061 - Excluir carrinho
- TC062 - Retornar estoque
- TC076 - Concluir compra
- TC077 - Cancelar compra

## 🛠️ Tecnologias Utilizadas

- **[Robot Framework](https://robotframework.org/)** - Framework de automação
- **[RequestsLibrary](https://github.com/MarketSquare/robotframework-requests)** - Biblioteca para requisições HTTP
- **[Collections](https://docs.python.org/3/library/collections.html)** - Manipulação de estruturas de dados
- **[String](https://robotframework.org/robotframework/latest/libraries/String.html)** - Manipulação de strings
- **[DateTime](https://robotframework.org/robotframework/latest/libraries/DateTime.html)** - Manipulação de datas

## ☁️ Setup EC2 (Tarefa Extra)

### EC2 #1 - ServeRest API:
```bash
# Conectar na EC2 e executar:
chmod +x scripts/setup_ec2.sh
./scripts/setup_ec2.sh
```

### EC2 #2 - Testes Robot Framework:
```bash
# Conectar na EC2 e executar:
chmod +x scripts/setup_tests_ec2.sh
./scripts/setup_tests_ec2.sh

# Clonar este projeto:
git clone <URL-DO-SEU-REPO>
cd ServeRest-API

# Configurar IP da EC2 do ServeRest em config/environments.robot
# Executar testes:
robot --outputdir results tests/robot/suites/
```

### Configuração de Security Groups:
- **EC2 ServeRest:** Porta 3000 liberada
- **EC2 Testes:** Apenas SSH (porta 22)

## 🎯 API Testada

- **Base URL:** Configurável (público/local/EC2)
- **Documentação:** https://serverest.dev/
- **Endpoints cobertos:**
  - `/usuarios` - Gerenciamento de usuários
  - `/login` - Autenticação
  - `/produtos` - Gerenciamento de produtos
  - `/carrinhos` - Gerenciamento de carrinhos

## 📝 Estratégia de Testes

- **Testes de Regressão:** Cenários estáveis para execução contínua
- **Documentação de Bugs:** Cenários com bugs conhecidos marcados com tag `bug_known`
- **Cobertura Funcional:** Testes positivos e negativos
- **Validações:** Status codes, estrutura JSON, mensagens de erro
- **Cleanup:** Limpeza automática de dados criados nos testes

### 🏷️ Padrão de Tags

**Recurso:** `usuarios`, `login`, `produtos`, `carrinhos`

**Método HTTP:** `post`, `get`, `put`, `delete`

**Resultado:** `positivo`, `negativo`, `error`

**Validação:** `validation`, `json`, `token`, `boundary`

**Criticidade:** `high`, `medium`, `low`

**Escopo:** `smoke`, `regression`, `admin`, `user`

**Outros:** `bug_known`, `security`, `performance`

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT.