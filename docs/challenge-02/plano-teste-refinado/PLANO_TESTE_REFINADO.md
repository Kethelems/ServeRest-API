# Plano de Teste Refinado - ServeRest API Challenge 02

## 1. Análise do Planejamento Anterior

### O que funcionou bem:
- ✅ Identificação correta dos endpoints principais
- ✅ Cobertura adequada de cenários positivos e negativos
- ✅ Estruturação clara dos casos de teste

### Melhorias Implementadas:
- 🔄 **Priorização baseada em risco**: Foco em funcionalidades críticas
- 🔄 **Estratégia de automação**: Definição clara de candidatos à automação
- 🔄 **Integração com QALity**: Tags e rastreabilidade para Jira
- 🔄 **Dados de teste**: Geração dinâmica para evitar conflitos

## 2. Estratégia de Execução Atual

### Fase 1: Testes Manuais (Exploratórios)
- **Objetivo**: Validar comportamentos não documentados
- **Escopo**: Novos endpoints ou funcionalidades
- **Duração**: 2-3 dias por sprint

### Fase 2: Automação (Regressão)
- **Objetivo**: Acelerar execução de testes repetitivos
- **Escopo**: Funcionalidades estáveis e críticas
- **Frequência**: Diária (CI/CD)

## 3. Cobertura de Testes Refinada

### Módulo Usuários (Prioridade Alta)
| ID | Cenário | Tipo | Automação | Status |
|----|---------|------|-----------|--------|
| TC001 | Criar usuário válido | Positivo | ✅ | Automatizado |
| TC007 | Criar usuário admin | Positivo | ✅ | Automatizado |
| TC008 | Criar usuário comum | Positivo | ✅ | Automatizado |
| TC012 | Email duplicado | Negativo | ✅ | Automatizado |
| TC015 | Listar usuários | Positivo | ✅ | Automatizado |

### Módulo Login (Prioridade Alta)
| ID | Cenário | Tipo | Automação | Status |
|----|---------|------|-----------|--------|
| TC020 | Login válido | Positivo | 🔄 | Em desenvolvimento |
| TC021 | Login inválido | Negativo | 🔄 | Em desenvolvimento |

### Módulo Produtos (Prioridade Média)
| ID | Cenário | Tipo | Automação | Status |
|----|---------|------|-----------|--------|
| TC030 | Criar produto | Positivo | 📋 | Planejado |
| TC031 | Listar produtos | Positivo | 📋 | Planejado |

## 4. Critérios de Qualidade

### Definição de Pronto (DoD):
- [ ] Teste manual executado e documentado
- [ ] Automação implementada (quando aplicável)
- [ ] Evidências coletadas
- [ ] Bugs reportados no Jira
- [ ] Code review da automação

### Métricas de Sucesso:
- **Cobertura de Automação**: > 80% dos testes críticos
- **Tempo de Execução**: < 10 minutos para smoke tests
- **Taxa de Falsos Positivos**: < 5%

## 5. Cronograma de Execução

### Semana 1:
- ✅ Refinamento do plano de testes
- ✅ Setup da estrutura de automação
- ✅ Implementação dos testes de usuários

### Semana 2:
- 🔄 Implementação dos testes de login
- 🔄 Implementação dos testes de produtos
- 🔄 Integração com pipeline CI/CD

### Semana 3:
- 📋 Execução completa da suite
- 📋 Análise de resultados
- 📋 Documentação final