--cada "pixel" do jogo corresponde a 15 pixels reais
--e o jogo possui 20 por 15 "pixels"
--cada objeto(seja fruta ou cobra) ocupa um "pixel"
--limitT é usado para definir a velocidade da cobra


janelaX = 20
janelaY = 15
tamPixel = 15
limitT = 0.10

	
function love.load()
	--muda o tamanho da janela
	love.window.setMode( janelaX*tamPixel, janelaY*tamPixel )
	
	--carrega as imagens
	cobraTriste = love.graphics.newImage('Imagens/gameover.png')
	abacaxi = love.graphics.newImage('Imagens/rsz_abacaxi.png')
	uva = love.graphics.newImage('Imagens/rsz_uva.png')
	morango = love.graphics.newImage('Imagens/rsz_morango.png')
	fundo = love.graphics.newImage('Imagens/matinho_2.jpg')
	corpo = love.graphics.newImage('Imagens/corpoCobra.png')
	
	listaFrutas = {abacaxi, uva, morango}

	--inicia a cobrinha
    inicio()
	
	--poe a fruta no jogo
    setFruta()
end

function love.update(dt)
--contador é utilizado para ter controle da velocidade da cobrinha
contador = contador + dt
	if not(morreu) then
		--se o intervalo de tempo for menor que o limite definido
		--entao a cobra nao deve se mover
		if contador >= limitT then
			--zera o contador para comecar uma nova contagem de tempo
			contador = 0

			--pega a posicao da cabeca como referencia para a proxima posicao
			cobraX = pontosCobra[1].x
			cobraY = pontosCobra[1].y
			
			--move a cobra de acordo com a direcao atual que ela esta andando
			if direcao == 'direita' then
				cobraX = cobraX + 1
				if cobraX > janelaX then
					cobraX = 1
				end
			elseif direcao == 'esquerda' then
				cobraX = cobraX - 1
				if cobraX < 1 then
					cobraX = janelaX
				end
			elseif direcao == 'cima' then
				cobraY = cobraY - 1
				if cobraY < 1 then
					cobraY = janelaY
				end
			elseif direcao == 'baixo' then
				cobraY = cobraY + 1
				if cobraY > janelaY then
					cobraY = 1
				end
			end
			
			--verifica se a cobra encostou nela mesma
			for i , coords in ipairs(pontosCobra) do
				if  i ~= 1 and i~=#pontosCobra and cobraX == coords.x and cobraY == coords.y then
					morreu = true
				end
			end

			
			if not(morreu) then
				table.insert(pontosCobra, 1, {x = cobraX, y = cobraY})
				--se a cobra comeu uma fruta entao nao retira a calda dela e adiciona a posicao atual
				--caso contrario retira a calda para que a cobra se mova
				if pontosCobra[1].x == posicaoFruta.x and pontosCobra[1].y == posicaoFruta.y then
					setFruta()
					trocaFruta = true
				else
					table.remove(pontosCobra)
				end
			end
				
		end
	
	--se a cobra morreu aguarda 3s para exibir a mensagem de game over na tela
	--apos isso o jogo reinicia com a configuracao inicial
	elseif contador >=3 then
		morreu = false
		inicio()
	end
    
end

function love.draw()
	desenhaFundo()
	for _, coords in ipairs(pontosCobra) do
		desenhaCobra(coords.x, coords.y)
		
	end
	
	desenhaFruta(posicaoFruta.x, posicaoFruta.y)
	--se a cobra morreu desenha a imagem de game over
	if morreu then
		desenhaGameOver()
	end
end

function desenhaFundo()
	love.graphics.draw(
        fundo,
       0,
       0
    )
end

function desenhaGameOver()
	love.graphics.draw(
       cobraTriste,
       0,
       0
    )


end

function desenhaFruta(x, y)
	--se a fruta acabou de ser setada a variavel estara true e 
	--podera escolher uma nova fruta
	if trocaFruta then
		--escolhe uma fruta entre a lista de frutas
		index = love.math.random(1, #listaFrutas)
		frutaAtual = listaFrutas[index]
	end
	--usa x-1 e y-1 porque a primeira posicao da janela montada é 1
	--a janela é dividida em 20 partes iguais na horizontal numeradas de 1 a 20
	--mas a contagem dos pixel comeca no 0
	love.graphics.draw(
        frutaAtual,
       (x - 1) * tamPixel,
       (y - 1) * tamPixel
    )
	--trocaFruta fica falso para que a fruta nao fique trocando sem ser comida
	trocaFruta = false
end

function desenhaCobra(x, y)
	love.graphics.draw(
        corpo,
       (x - 1) * tamPixel,
       (y - 1) * tamPixel
    )
end

function love.keypressed(key)
    if key == 'right' or key == 'd' and direcao ~='esquerda' then
        direcao = 'direita'

    elseif key == 'left' or key == 'a' and direcao ~='direita' then
        direcao = 'esquerda'
		
	elseif key == 'down' or key == 's' and direcao ~='cima' then
        direcao =  'baixo'

    elseif key == 'up' or key == 'w' and direcao ~='baixo' then
        direcao = 'cima'
    end
end

function inicio()
	pontosCobra = {
		{x = 10, y = 7},
		{x = 11, y = 7},
		{x = 12, y = 7},
	}
	direcao = 'esquerda'
	trocaFruta = true
	frutaAtual = uva
	contador = 0
	morreu = false
end

function setFruta()
	--pega uma posicao aleatoria na tela e verifica se a cobra nao ta la
	local posicaoInvalida = true 
	while posicaoInvalida do
		frutaX = love.math.random(1, janelaX)
		frutaY = love.math.random(1, janelaY)
		posicaoInvalida = false
		for _, coords in ipairs(pontosCobra) do
			if frutaX == coords.x and frutaY == coords.y then
				posicaoInvalida = true
			end
		end
	end
	posicaoFruta = {x= frutaX, y= frutaY}
end
