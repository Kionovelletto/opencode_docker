# 🐳 OpenCode Docker

![Banner OpenCode Docker](branding/opencode-docker-banner.png)

> **OpenCode** — o agente de IA para o seu terminal — empacotado em uma imagem
> **Docker** pronta para uso, com instalação automática do binário, persistência
> de configuração e sessão interativa via `docker compose`.

**OpenCode Docker** é uma imagem Ubuntu 22.04 que instala a CLI do OpenCode
durante o *build* e a disponibiliza com um ambiente de trabalho predefinido
(`/workspace`). Basta subir o container e usar o agente de IA direto do
terminal — sem instalar nada na sua máquina.

---

## ✨ Funcionalidades

- **Instalação automática** da CLI do OpenCode durante o build (via
  [`install.sh`](install.sh), o mesmo instalador oficial).
- **Sessão interativa**: `stdin_open` + `tty` habilitados, para a CLI rodar
  com terminal completo (cores, prompts e navegação).
- **Persistência de configuração**: volume `opencode_data` mantém suas chaves,
  sessões e configurações em `/root/.config/opencode` entre execuções.
- **Seu código na mão**: diretório de trabalho `/workspace`, montado a partir
  da sua máquina.
- **`TERM=xterm-256color`** para suporte completo de cores.
- **Git pré-instalado** na imagem, útil para tarefas do agente.
- **Base Ubuntu 22.04** com apenas o necessário (`curl`, `tar`, `gzip`,
  `ca-certificates`, `git`) — imagem leve e reproduzível.

---

## 🚀 Como executar

Requisitos: **Docker Engine** e **Docker Compose** (plugin) instalados.

### Subir com Docker Compose

```bash
docker compose up
```

O container inicia com a CLI do OpenCode já aberta e interativa. Para sair,
use `Ctrl+D` ou `Ctrl+C`.

### Build e run manual

```bash
# Build
docker build -t opencode .

# Executar a CLI
docker run -it --rm \
  -v "$PWD:/workspace" \
  -v opencode_data:/root/.config/opencode \
  -e TERM=xterm-256color \
  opencode
```

### Comandos não interativos

Para rodar um comando pontual sem abrir a sessão interativa:

```bash
docker compose run --rm opencode --version
```

---

## 📦 Persistência de dados

| Volume / montagem | Contêiner | Finalidade |
|---|---|---|
| `opencode_data` (volume) | `/root/.config/opencode` | Configuração, chaves de API e sessões do OpenCode |
| Diretório do host | `/workspace` | Seu projeto/código, visto pelo agente |

> **Importante:** o caminho `/_dev_` no `docker-compose.yml` é um exemplo.
> Altere-o para o diretório do seu projeto:

```yaml
volumes:
  - /caminho/do/seu/projeto:/workspace
  - opencode_data:/root/.config/opencode
```

---

## 🔧 Como a instalação funciona

Durante o build, o `Dockerfile` faz o seguinte:

1. Instala as dependências do sistema (`curl`, `tar`, `gzip`, `ca-certificates`,
   `git`);
2. Copia e executa o [`install.sh`](install.sh), que baixa o binário mais
   recente do OpenCode dos *releases* e o instala em `/root/.opencode/bin`;
3. Remove o instalador e adiciona `/root/.opencode/bin` ao `PATH`;
4. Define `/workspace` como diretório de trabalho e `opencode` como comando
   padrão.

Para fixar uma versão específica, ajuste a chamada do instalador no
[`Dockerfile`](Dockerfile):

```dockerfile
RUN chmod +x /tmp/install.sh && \
    /tmp/install.sh --version 1.0.180 && \
    rm /tmp/install.sh
```

---

## 📂 Estrutura do projeto

```
opencode_container/
├── Dockerfile           # Definição da imagem (Ubuntu 22.04 + OpenCode)
├── docker-compose.yml   # Orquestração: TTY, volumes e TERM configurados
├── install.sh           # Instalador oficial da CLI do OpenCode
├── branding/            # Logo e banner Docker do projeto
│   ├── opencode-docker-banner.svg / .png
│   └── opencode-docker-icon.svg / .png
└── README.md            # Este documento
```

---

## 🛠️ Referência rápida da CLI

| Comando | Descrição |
|---|---|
| `opencode` | Inicia a sessão interativa no diretório atual |
| `opencode --version` | Mostra a versão instalada |
| `opencode --help` | Lista todos os comandos disponíveis |

Documentação completa: [https://opencode.ai/docs](https://opencode.ai/docs)

---

## 📝 Licença

Uso livre para fins de estudo e aprendizado. **OpenCode** é um projeto de
código aberto — consulte os repositórios oficiais para termos e licenças.
