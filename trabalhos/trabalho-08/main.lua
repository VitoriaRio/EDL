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

	listaFrutas = {[1] = abacaxi,[2] =  uva,[3] =  morango}

	--inicia os objetos (agora closures)
	obj = newObjAleatorio(0,0)
	fruta = new(0,0)
    inicio()

    setFruta()
end

function love.update(dt)

	contador = contador + dt
	if not(morreu) then
		--retorna para a coroutine
		coroutine.resume(obj.co, dt)

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
				local x, y = fruta.get()
				if pontosCobra[1].x == x and pontosCobra[1].y == y then
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

	local ox,oy = obj.get()
   love.graphics.rectangle('fill', (ox)*tamPixel, (oy)*tamPixel, 15,15)

	desenhaFruta()

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

function desenhaFruta()

	if trocaFruta then

		index = love.math.random(1, 3)
		frutaAtual = listaFrutas[index]
	end
	x, y = fruta.get()
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
    if (key == 'right' or key == 'd') and direcao ~='esquerda' then
        direcao = 'direita'

    elseif (key == 'left' or key == 'a') and direcao ~='direita' then
        direcao = 'esquerda'

	elseif (key == 'down' or key == 's') and direcao ~='cima' then
        direcao =  'baixo'

    elseif (key == 'up' or key == 'w') and direcao ~='baixo' then
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
	--atualiza posicao da fruta
	fruta.move(frutaX,frutaY)
end

--clousure para coordenar o movimento da fruta
function new (x,y)
    local me = {
        move = function (dx,dy)
            x = dx
            y = dy
            return x, y
        end,
        get = function ()
            return x, y
        end,
    }
    return me
end

--Inicia um objeto aleatorio que ira ficar circulando na borda da janela
--coroutine coordena o movimento do quadrado
function newObjAleatorio(x,y, v)
    local me;
	  	me= {
        move = function (dx,dy)
            x = x+dx
            y = y+dy
            return x, y
        end,
        get = function ()
            return x, y
        end,

		  co = coroutine.create(function (dt)
            while true do
					local ox, oy = me.get()
					--me.move(tamPixel*dt, 0)
					if ox <19 and oy <=0 then
                	me.move(tamPixel*dt, 0)
					elseif ox >=19 and oy <14 then
						me.move(0, tamPixel*dt)
					elseif oy >= 14 and ox>0 then
						me.move(-tamPixel*dt, 0)
					elseif oy>0 then
						me.move(0, -tamPixel*dt)
					end
						--retorna para a funcao principal
                dt = coroutine.yield()
            end
        end),
    }
    return me
end
