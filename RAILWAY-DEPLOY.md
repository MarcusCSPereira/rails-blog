# Guia de Deploy no Railway

Este guia contém todas as instruções necessárias para fazer o deploy desta aplicação Rails no Railway.

## Pré-requisitos

1. Conta no [Railway](https://railway.app)
2. Aplicação configurada no GitHub/GitLab (recomendado) ou repositório Git
3. Arquivo `config/master.key` local (você precisará do valor para configurar a variável de ambiente)

## Passo a Passo

### 1. Obter a RAILS_MASTER_KEY

No seu ambiente local, execute:

```bash
cat config/master.key
```

Copie o valor exibido. Você precisará dele na etapa 4.

### 2. Criar um Novo Projeto no Railway

1. Acesse [railway.app](https://railway.app) e faça login
2. Clique em "New Project"
3. Selecione "Deploy from GitHub repo" (recomendado) ou "Empty Project"
4. Se escolher GitHub, selecione o repositório `rails-blog`

### 3. Adicionar Banco de Dados PostgreSQL

1. No dashboard do projeto, clique em "+ New"
2. Selecione "Database" → "Add PostgreSQL"
3. O Railway criará automaticamente um banco PostgreSQL e configurará a variável `DATABASE_URL`

### 4. Configurar Variáveis de Ambiente

No dashboard do projeto, vá em "Variables" e adicione as seguintes variáveis:

#### Variáveis Obrigatórias:

- **RAILS_MASTER_KEY**: Cole o valor obtido no passo 1
- **RAILS_ENV**: `production`
- **RAILS_LOG_LEVEL**: `info` (ou `debug` para mais detalhes)

#### Variáveis Opcionais (mas recomendadas):

- **RAILS_HOST**: O domínio da sua aplicação (ex: `seu-app.railway.app`)
- **RAILS_MAX_THREADS**: `5` (ajuste conforme necessário)
- **SOLID_QUEUE_IN_PUMA**: `true` (para processar jobs no mesmo processo)

#### Variáveis para Bancos Secundários (Cache, Queue, Cable):

Se você quiser usar bancos separados para cache, queue e cable (recomendado para produção):

- **CACHE_DATABASE_URL**: URL do banco para cache (pode ser o mesmo DATABASE_URL)
- **QUEUE_DATABASE_URL**: URL do banco para queue
- **CABLE_DATABASE_URL**: URL do banco para cable

**Nota**: Por padrão, a aplicação usará o mesmo `DATABASE_URL` para todos os bancos, criando databases separados automaticamente.

### 5. Configurar o Deploy

1. No dashboard, vá em "Settings"
2. Em "Build Command", deixe vazio (o Dockerfile já faz o build)
3. Em "Start Command", deixe vazio (o Dockerfile já define o CMD)
4. Em "Root Directory", deixe vazio (raiz do projeto)

### 6. Fazer o Deploy

Se você conectou o repositório GitHub:
- O Railway fará deploy automaticamente a cada push na branch principal
- Ou você pode fazer deploy manual clicando em "Deploy"

Se você criou um projeto vazio:
1. Clique em "+ New" → "GitHub Repo"
2. Selecione seu repositório
3. O deploy começará automaticamente

### 7. Executar Migrações

Após o primeiro deploy, você precisa executar as migrações:

1. No dashboard, vá em "Deployments"
2. Clique no deployment mais recente
3. Vá na aba "Logs"
4. Ou use o Railway CLI:

```bash
# Instalar Railway CLI (se ainda não tiver)
npm i -g @railway/cli

# Fazer login
railway login

# Conectar ao projeto
railway link

# Executar migrações
railway run rails db:migrate

# Se necessário, criar os bancos secundários
railway run rails db:create:cache
railway run rails db:create:queue
railway run rails db:create:cable

# Executar migrações dos bancos secundários
railway run rails db:migrate:cache
railway run rails db:migrate:queue
railway run rails db:migrate:cable
```

### 8. Configurar Domínio Personalizado (Opcional)

1. No dashboard, vá em "Settings" → "Networking"
2. Clique em "Generate Domain" para obter um domínio `.railway.app`
3. Ou adicione um domínio personalizado em "Custom Domain"

### 9. Verificar o Deploy

1. Acesse o domínio fornecido pelo Railway
2. Verifique os logs em "Deployments" → selecione o deployment → "Logs"
3. Teste a aplicação

## Troubleshooting

### Erro: "RAILS_MASTER_KEY não encontrado"

- Verifique se a variável `RAILS_MASTER_KEY` está configurada corretamente
- O valor deve ser exatamente o conteúdo do arquivo `config/master.key`

### Erro: "Database connection failed"

- Verifique se o serviço PostgreSQL está rodando
- Confirme que a variável `DATABASE_URL` está configurada automaticamente
- Verifique os logs do serviço PostgreSQL

### Erro: "Port already in use"

- O Railway define `PORT` automaticamente, não é necessário configurar manualmente
- O Dockerfile já está configurado para usar `PORT` dinamicamente

### Migrações não executadas

- Execute manualmente: `railway run rails db:migrate`
- Verifique se o banco de dados está acessível

### Assets não carregando

- Os assets são pré-compilados durante o build do Docker
- Verifique se o build completou com sucesso
- Verifique os logs do build

## Estrutura de Arquivos Configurados

Os seguintes arquivos foram configurados para o Railway:

- `Dockerfile`: Configurado para usar PORT dinâmico e Puma
- `Procfile`: Define o comando de start (opcional, Railway usa Dockerfile)
- `config/database.yml`: Configurado para usar `DATABASE_URL` do Railway
- `config/environments/production.rb`: Configurado com SSL e host dinâmico
- `.railwayignore`: Arquivos ignorados no deploy

## Monitoramento

- **Logs**: Acesse "Deployments" → selecione deployment → "Logs"
- **Métricas**: Railway fornece métricas básicas no dashboard
- **Health Check**: A aplicação expõe `/up` como endpoint de health check

## Próximos Passos

1. Configure um domínio personalizado
2. Configure backups do banco de dados
3. Configure monitoramento e alertas
4. Configure CI/CD para deploy automático
5. Configure variáveis de ambiente para diferentes ambientes (staging, production)

## Suporte

- [Documentação do Railway](https://docs.railway.app)
- [Documentação do Rails](https://guides.rubyonrails.org)
- [Railway Discord](https://discord.gg/railway)

