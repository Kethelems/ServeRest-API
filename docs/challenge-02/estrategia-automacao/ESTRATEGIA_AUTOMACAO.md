# Estratégia de Automação - ServeRest API

## 1. Refinamento dos Testes Candidatos à Automação

### Critérios de Seleção para Automação:
- **Alta Prioridade**: Testes críticos de negócio (criação de usuários, login)
- **Repetitividade**: Testes executados frequentemente
- **Estabilidade**: Funcionalidades com baixa taxa de mudança
- **Cobertura de Regressão**: Testes que validam funcionalidades core

### Testes Selecionados para Automação:

#### Módulo Usuários (Alta Prioridade)
- ✅ TC001 - Criar usuário válido com todos os campos
- ✅ TC007 - Criar usuário administrador  
- ✅ TC008 - Criar usuário não-administrador
- ✅ TC012 - Criar usuário com email já existente
- ✅ TC015 - Listar todos os usuários

#### Módulo Login (Alta Prioridade)
- 🔄 TC020 - Login com credenciais válidas
- 🔄 TC021 - Login com credenciais inválidas

#### Módulo Produtos (Média Prioridade)
- 🔄 TC030 - Criar produto válido
- 🔄 TC031 - Listar produtos

## 2. Arquitetura de Automação

### Tecnologias Utilizadas:
- **Robot Framework**: Framework principal de automação
- **RequestsLibrary**: Para requisições HTTP/REST
- **Python**: Linguagem base

### Estrutura do Projeto:
```
tests/robot/
├── keywords/           # Keywords customizadas por módulo
├── resources/          # Recursos compartilhados
├── variables/          # Variáveis e configurações
├── results/           # Relatórios de execução
└── test_*.robot       # Arquivos de teste
```

## 3. Estratégia de Execução

### Ambientes de Teste:
- **Desenvolvimento**: https://serverest.dev (ambiente público)

### Tipos de Execução:
- **Smoke Tests**: Testes críticos executados a cada build
- **Regression Tests**: Suite completa executada diariamente
- **On-Demand**: Execução manual conforme necessário

### Tags de Organização:
- `smoke`: Testes críticos
- `positivo/negativo`: Cenários válidos/inválidos
- `high/medium/low`: Prioridade dos testes

## 4. Melhorias Implementadas

### Baseado no Feedback dos Instrutores:
1. **Modularização**: Keywords organizadas por funcionalidade
2. **Reutilização**: Funções comuns centralizadas
3. **Manutenibilidade**: Separação clara de responsabilidades
4. **Documentação**: Cada teste documentado com propósito claro
5. **Cleanup**: Limpeza automática de dados de teste

### Integração com QALity/Jira:
- Tags estruturadas para rastreabilidade
- Relatórios em formato compatível
- Identificação clara de casos de teste