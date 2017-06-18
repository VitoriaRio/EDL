# Go - Artigo

## História
  <p>Go é uma linguagem de código aberto anunciada pela Google em 10 de novembro de 2009. Começou a ser pensada em 2007 por Robert Griesemer, Rob Pike e Ken Thompson diante a insatisfação da Google com as linguagens já existentes e a falta de uma padronização na empresa. Na empresa se utilizava muito linguagens como C++, Java e Python porém começou-se a necessidade de juntar em uma única linguagem as características positivas dessas tres tais como: a facilidade de uma linguagem dinâmica em se escrever e ler o código mas também com a segurança e eficiência de uma linguagem estática. </p>



## Origens e Influências
  <p>Go foi projetada para ser uma linguagem moderna, segura e de rápida escrita. Tem fortes influências de C no que diz respeito a sintaxe porém com uma legibilidade maior. Além disso possui influências de Pascal/Modula/Oberon em relação a declaração e importação de pacotes. Go também foi desenhada para possuir concorrência nativa com uso de coroutines que teve influências de New Squeak e Limbo.</p>


## Características
  * **Tipagem:**
  <p>Go possui uma tipagem estática pois é compilada e forte pois tem muitas regras de checagem de tipo.</p>
  
  
  * **Writeability, Readability e Expressividade:**
  <p>A sintaxe Go, como dito anteriormente, se baseia em C porem com algumas facilidades. A seguir vemos um mesmo programa em C e Go:</p>
  GO:
  
              package main
              import (
                "fmt"
              )

              func main() {
                i := 0
                for ;i<10;i++{
                  if i%2==0{
                    fmt.Printf("%d é par\n", i)
                  }else{
                    fmt.Printf("%d é impar\n", i)
                  }
                }
              }
              
              
C:
              
              
              #include <stdio.h>
              int main() {
                int i =0;
                for (i=0;i<1;i++){
                  if (i%2==0){
                    printf("%d e par\n", i);
                  }else{
                    printf("%d e impar\n", i);
                  }
                }
              }


<p>Em Go, não é permitido o uso de parênteses em blocos condicionais ou loops e nem o uso do ponto e vírgula no final de um comando. Na declaração de variáveis não é necessário dizer o tipo, embora seja permitido, com o comando ”:=” Go já infere o tipo da variável com base no valor passado, se assemelhando a linguagens como Python. Podemos dizer portanto que Go tem maior poder de facilidade de escrita que C além de possuir maior facilidade na leitura por possuir um codigo mais limpo.</p>
<p>Abaixo outro exemplo em C e GO:</p>

GO:


              package main

              import (
                "fmt"
              )

              func main() {
                ad, sub := multiplosRetornos(5,3)
                fmt.Printf("%d %d", ad, sub)
              }

              func multiplosRetornos(par1, par2 int)(int, int){
                var ret1, ret2 int
                ret1 = par1+par2
                ret2= par1-par2
                return ret1, ret2
              }
              
              
C:


                #include <stdio.h>
                
                int subtracao(int par1, int par2);
                int adicao(int par1, int par2);

                int main() {
                  int ad = adicao(5,3);
                  int sub = subtracao(5,3);
                  printf("%d %d", ad, sub);
                }

                int adicao(int par1, int par2){
                    int ret1 = par1+par2;
                    return ret1;
                }

                int subtracao(int par1, int par2){
                    int ret2 = par1-par2;
                    return ret2;
                }
     
<p>Go permite múltiplos retornos de uma função o que não é possível em C. Para se ter o mesmo programa em C, haveria a necessidade de se retornar um array ou fazer duas funções(como mostrado acima). Se os retornos fossem de tipos diferentes, em C seria muito custoso de se fazer praticamente impossível em alguns casos. Portanto podemos dizer que Go tem maior expressividade que C.
</p>


* **Classificacao da linguagem:**
  <p>Apesar de Go possuir algumas características de linguagem funcional (como funções lambda - anônimas) e de linguagens orientadas a objetos(como explicado abaixo), Go é uma linguagem imperativa como C. Tais caracteristicas citadas sao poucas para classifica-la daquelas maneiras.</p>
  
  * Orientação a Objetos:
    <p> Go não pode ser considerada uma linguagem orientada a objetos como Java embora possamos “simular” isso com structs e ponteiros. O “objeto” de Go é o que chamamos de estrutura, ou struct. Através das structs podemos implementar métodos, herança, interface.
</p>


              package main

              import (
                "fmt"
              )

              func main() {
                pessoa1 := homem{pessoa{idade: 10, nome: "joao"}}
                pessoa2 := mulher{pessoa{idade: 20, nome:"maria"}}
                fmt.Printf("%s é maior de 18? %s\n", pessoa1.nome, pessoa1.maiorde18())
                fmt.Printf("%s é maior de 18? %s", pessoa2.nome, pessoa2.maiorde18())
              }

              type homem struct {
                pessoa

              }

              type mulher struct {
                pessoa
              }

              type pessoa struct {
                idade int
                nome string
              }


              func(p *pessoa) maiorde18() string{
                if p.idade > 18{
                  return "sim"
                }else{
                  return "nao"
                }
              }
              
              
 <p>No código a acima a função maiorde18 está associado a struct pessoa. “homem” e “mulher” herdam de pessoa e portanto podemos chamar o método maiorde18 a partir destes bem como os atributos de pessoa(idade, nome).
</p>


## Pontos Extras
* **Concorrencia:**
<p> Um dos pontos fortes de Go é a concorrência: go possui coroutines nativas da linguagem(chamadas goroutines). Programar concorrentemente em Go é uma tarefa bem fácil e rápida. A linguagem ainda conta com channels o que torna a comunicação entre processos mais rápida. Abaixo um exemplo de concorrência em Go.</p>
                
                package main

                import "fmt"

                func print(s []int, c chan int) {
                  sum := 0
                  for _, v := range s {
                    sum += v
                  }
                  c <- sum 
                }

                func main() {
                  s := []int{7, 2, 8, -9, 4, 0}

                  c := make(chan int)
                  go sum(s[:len(s)/2], c)
                  go sum(s[len(s)/2:], c)
                  x, y := <-c, <-c 

                  fmt.Println(x, y, x+y)
                }
<p>Acima vemos um uso de coroutines em Go. O comando “go” inicia uma coroutine. No programa as duas coroutines executam concorrentemente, cada uma calcula a soma de uma parte do array e depois coloca o seu resultado no channel “c”. No comando “x, y := <-c, <-c” o programa fica travado esperando dois resultados do channel. Go utiliza bastante coroutines no contexto de servers: para cada conexão Go abre uma coroutine para tratá-la.</p>

* **Regras de escrita:**
 <p>Go possui uma preocupação muito grande com a performance do programa portanto ele simplesmente nao compila se o programador importar pacotes que não utiliza ou declarar variaveis que nunca sao utilizadas. O código abaixo, por exemplo não compila.
</p>

                package main

                import (
                "fmt"
                "io/ioutil"
                )

                func main() {
                  var variavelSemUtilidade int
                  fmt.Println("Hello World")
                }
        
  <p> Erro gerado:</p>
  
                tmp/sandbox152132264/main.go:5: imported and not used: "io/ioutil"
                tmp/sandbox299278104/main.go:9: variavelSemUtilidade declared and not used

## Conclusão
<p>Go é uma linguagem muito nova com menos de 10 anos mas que em pouco tempo ja ganhou muitos adeptos. Podemos ver grandes empresas como Google, Netflix, Cloudflare, Paypal entre outras. Isso se da justamente porque Go, alem de se mostrar extremamente eficiente em cenários de comunicação client-server conseguiu unir pontos positivos de linguagens estaticas e dinamicas o que até então não se via. Diante deste cenário pode-se dizer que as espectativas em relação ao seu uso e melhorias da linguagem são boas e só tendem a crescer</p>


## Bibliografia
[Golang FAQ oficial](https://golang.org/doc/faq)
[Wikipedia GO - Programming Language](https://en.wikipedia.org/wiki/Go_(programming_language))
[Explicação sobre tipagem](http://www.josephspurrier.com/strong-weak-dynamic-and-static-typed-programming-languages/)
