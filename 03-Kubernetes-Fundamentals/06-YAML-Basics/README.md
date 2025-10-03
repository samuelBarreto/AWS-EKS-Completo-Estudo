
# Fundamentos de YAML

## Passo-01: Comentários & Pares Chave-Valor
- O espaço após os dois pontos é obrigatório para diferenciar chave e valor
```yml
# Definindo pares chave-valor simples
nome: samuel
idade: 23
cidade: barueri
```

## Passo-02: Dicionário / Mapa
- Conjunto de propriedades agrupadas após um item
- Mesma quantidade de espaço em branco é exigida para todos os itens dentro de um dicionário
```yml
pessoa:
  nome: samuel
  idade: 23
  cidade: barueri
```

## Passo-03: Array / Listas
- O traço indica um elemento de uma lista
```yml
pessoa: # Dicionário
  nome: samuel
  idade: 23
  cidade: barueri
  hobbies: # Lista  
    - ciclismo
    - culinária
  hobbies: [ciclismo, culinária]   # Lista com outra notação  
```  

## Passo-04: Múltiplas Listas
- O traço indica um elemento de uma lista
```yml
pessoa: # Dicionário
  nome: samuel
  idade: 23
  cidade: barueri
  hobbies: # Lista  
    - ciclismo
    - culinária
  hobbies: [ciclismo, culinária]   # Lista com outra notação  
  amigos: # 
    - nome: amigo1
      idade: 22
    - nome: amigo2
      idade: 25            
```  

## Passo-05: Exemplo de Pod Template para referência
```yml
apiVersion: v1 # String
kind: Pod  # String
metadata: # Dicionário
  name: myapp-pod
  labels: # Dicionário 
    app: myapp         
spec:
  containers: # Lista
    - name: myapp
      image: aula/kubenginx:1.0.0
      ports:
        - containerPort: 80
          protocol: "TCP"
        - containerPort: 81
          protocol: "TCP"
```




