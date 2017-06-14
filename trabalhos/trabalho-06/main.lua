janelaX = 20
janelaY = 15
tamPixel = 15
limitT = 0.10
	
function love.load()

	love.window.setMode( janelaX*tamPixel, janelaY*tamPixel )
	
	cobraTriste = love.graphics.newImage('Imagens/gameover.png')
	abacaxi = love.graphics.newImage('Imagens/rsz_abacaxi.png')
	uva = love.graphics.newImage('Imagens/rsz_uva.png')
	morango = love.graphics.newImage('Imagens/rsz_morango.png')
	fundo = love.graphics.newImage('Imagens/matinho_2.jpg')
	corpo = love.graphics.newImage('Imagens/corpoCobra.png')
	
	--O programa foi modificado neste ponto para conter um dicionario
	--para o trabalho 6
	--Dicionario: listaFrutas
	listaFrutas = {[1] = abacaxi,[2] =  uva,[3] =  morango}

    inicio()

    setFruta()
end

function love.update(dt)

	contador = contador + dt
	if not(morreu) then

		if contador >= limitT then

			contador = 0

			cobraX = pontosCobra[1].x
			cobraY = pontosCobra[1].y

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

			for i , coords in ipairs(pontosCobra) do
				if  i ~= 1 and i~=#pontosCobra and cobraX == coords.x and cobraY == coords.y then
					morreu = true
				end
			end

			
			if not(morreu) then
				table.insert(pontosCobra, 1, {x = cobraX, y = cobraY})
				
				if pontosCobra[1].x == posicaoFruta.x and pontosCobra[1].y == posicaoFruta.y then
					setFruta()
					trocaFruta = true
				else
					table.remove(pontosCobra)
				end
			end
				
		end

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

	if trocaFruta then

		index = love.math.random(1, 3)
		frutaAtual = listaFrutas[index]
	end

	love.graphics.draw(
        frutaAtual,
       (x - 1) * tamPixel,
       (y - 1) * tamPixel
    )

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
--Array: pontosCobra é um array
--Registro: pontosCobra é um array de registros
	pontosCobra = {
		{x = 10, y = 7},
		{x = 11, y = 7},
		{x = 12, y = 7},
	}
--Enum: direcao /em lua uma cadeia de caracter é um enum/
	direcao = 'esquerda'
	trocaFruta = true
	frutaAtual = uva
	contador = 0
	morreu = false
end

function setFruta()

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
