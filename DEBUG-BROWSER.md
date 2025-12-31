# Debug de Imagens - Guia Rápido no Browser

## 🔍 Como Debugar Diretamente no Browser (Mais Rápido)

### Passo 1: Inspecionar a Imagem

1. Abra a página do artigo no Railway
2. Clique com botão direito na imagem que não aparece (ou no espaço onde deveria estar)
3. Selecione "Inspecionar elemento" ou "Inspect"
4. Procure pela tag `<img>`

### Passo 2: Verificar o Atributo `src`

Na tag `<img>`, você verá algo como:
```html
<img src="/rails/active_storage/representations/.../variants/.../medium/..." alt="...">
```

**O que verificar:**
- ✅ Se o `src` está presente e tem uma URL
- ❌ Se o `src` está vazio ou quebrado
- ❌ Se há um erro 404 ou 500 ao acessar a URL

### Passo 3: Testar a URL Diretamente

1. Copie a URL completa do atributo `src`
2. Cole no navegador (adicione o domínio do Railway se necessário)
3. Veja o que acontece:
   - **200 OK**: Imagem carrega → Problema pode ser CSS ou tamanho
   - **404 Not Found**: Variante não foi processada ou arquivo não existe
   - **500 Internal Server Error**: Erro no processamento (ImageMagick)

### Passo 4: Verificar Console do Browser

1. Abra DevTools (F12)
2. Vá na aba **Console**
3. Procure por erros relacionados a:
   - `Failed to load resource`
   - `404` ou `500` errors
   - Erros de CORS

### Passo 5: Verificar Network Tab

1. Abra DevTools (F12)
2. Vá na aba **Network**
3. Recarregue a página (F5)
4. Filtre por "Img" (imagens)
5. Procure pela requisição da imagem
6. Clique nela e veja:
   - **Status**: 200, 404, 500?
   - **Headers**: O que retorna?
   - **Preview**: A imagem aparece?

## 🐛 Problemas Comuns e Soluções

### Problema 1: URL retorna 404

**Causa**: Variante não foi processada ou arquivo não existe

**Solução**:
- Verificar se a imagem original existe
- Verificar logs do Railway para erros de processamento
- Fazer upload da imagem novamente

### Problema 2: URL retorna 500

**Causa**: Erro ao processar variante (ImageMagick)

**Solução**:
- Verificar se ImageMagick está instalado no Railway
- Verificar logs do Railway para erros específicos
- Verificar permissões do diretório storage

### Problema 3: Imagem aparece muito pequena ou muito grande

**Causa**: CSS ou tamanho da variante incorreto

**Solução**:
- Verificar CSS da classe `.post-detail-image`
- Verificar se a variante `:medium` está com tamanho correto (850x650)
- Ajustar CSS se necessário

### Problema 4: Imagem não aparece mas não há erro

**Causa**: CSS escondendo a imagem ou problema de layout

**Solução**:
- Verificar se a tag `<img>` está presente no HTML
- Verificar CSS: `display: none?`, `visibility: hidden?`, `opacity: 0?`
- Verificar se há `width: 0` ou `height: 0`

## 📋 Checklist Rápido

- [ ] Tag `<img>` está presente no HTML?
- [ ] Atributo `src` tem uma URL válida?
- [ ] URL acessível diretamente no browser?
- [ ] Status code da requisição é 200?
- [ ] Console do browser mostra erros?
- [ ] Network tab mostra a requisição?
- [ ] CSS não está escondendo a imagem?

## 🔧 Teste Rápido no Console do Browser

Abra o console (F12) e execute:

```javascript
// Encontrar todas as imagens na página
document.querySelectorAll('img').forEach((img, index) => {
  console.log(`Imagem ${index}:`, {
    src: img.src,
    complete: img.complete,
    naturalWidth: img.naturalWidth,
    naturalHeight: img.naturalHeight,
    width: img.width,
    height: img.height
  });
});

// Verificar se há imagens quebradas
document.querySelectorAll('img').forEach(img => {
  img.onerror = function() {
    console.error('Imagem quebrada:', this.src);
  };
});
```

## 🚀 Teste no Railway Console

Se você tiver acesso ao Railway console:

```bash
railway run rails console
```

No console:
```ruby
# Encontrar um artigo
article = Article.first

# Verificar se tem imagem
article.cover_image.attached?

# Testar variante medium
if article.cover_image.attached?
  variant = article.cover_image.variant(:medium)
  puts "URL: #{variant.url}"
  puts "Processada: #{variant.processed?}"
end
```

## 📸 Captura de Tela do Problema

Para ajudar no debug, capture:
1. Screenshot da página (onde a imagem deveria estar)
2. Screenshot do DevTools mostrando a tag `<img>`
3. Screenshot do Network tab mostrando a requisição
4. Screenshot do Console com erros (se houver)

