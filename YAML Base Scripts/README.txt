
Para inserir:
yq -i '.campo_novo = "valor"' arquivo.yaml
yq -i '.objeto.campo_novo = "valor"' arquivo.yaml
yq -i '.minha_lista += "novo_item"' arquivo.yaml
yq -i '.usuarios += {"nome": "Carlos", "idade": 30}' arquivo.yaml
yq -i '.campo1 = "valor1" | .campo2 = "valor2"' arquivo.yaml

Para pegar:
yq '.usuario' arquivo.yaml
yq '.dados.email' arquivo.yaml
yq '.minha_lista[]' arquivo.yaml
yq '.usuarios[] | select(.nome == "Carlos")' arquivo.yaml
yq '.usuarios[] | select(.nome == "Carlos") | .idade' arquivo.yaml

Para apagar:
yq -i 'del(.campo)' arquivo.yaml
yq -i 'del(.objeto.campo)' arquivo.yaml
yq -i 'del(.minha_lista[1])' arquivo.yaml
yq -i 'del(.token) | del(.produtos)' arquivo.yaml

Buscas:
yq '.. | select(has("usuario")) | .usuario' arquivo.yaml

Mover um campo:
yq -i '.novo_objeto = .antigo_objeto | del(.antigo_objeto)' arquivo.yaml

Ordenar listas:
yq -i '.minha_lista |= sort' arquivo.yaml

Renomear:
yq -i '.novo_nome = .antigo_nome | del(.antigo_nome)' arquivo.yaml

Unir arquivos yaml:
yq '. as $item ireduce ({}; . * $item)' arquivo1.yaml arquivo2.yaml

Filtrar complexo:
yq '.usuarios[] | select(.idade > 30 and .status == "ativo")' arquivo.yaml

Validar o arquivo se está correto:
yq eval '.' arquivo.yaml

Compactar: (in line = json)
yq -c '.' arquivo.yaml

Refazer e corrigir o documento:
yq -P . arquivo.yaml -i
