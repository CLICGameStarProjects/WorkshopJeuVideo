pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
-- the snake
-- by parein jean-philippe

function _init()
	 
 --snake head
	head ={
	x=64,--x coordinate
	y=64,--y coordinate
	prevx,--previous x positon
	prevy,--previous y position
	sp=5, --head speed
	dx=8, --delta-x coord (for movment)
	dy=0, --delta-y coordinate (for movment)
	spd=5 --body speed
	}
	
	--snake body
	snake={}
 snake[1]=head	

	--generate pos grid multiple 8
	mult8 = {}
	for i=0,120,8 do
		mult8[#mult8+1]=i
	end
		
	--apple
	apple={
	x=mult8[flr(rnd(#mult8)+1)],
 y=mult8[flr(rnd(#mult8)+1)]}
 	
	f=0 --frame
	
	game_over=false --end of game
	
	score=0 --apples count
end

------------------------------
--an update function to track 
--game progress
function _update()
 
	f-=1
 
 if game_over then	
 
 	for i=#snake,1,-1 do
 		if f<0 then
 		make_particles(
 			snake[i].x,
 			snake[i].y)
 			del(snake,snake[i])
 			sfx(3) 			
 			f=2
 		end
 	end 	
 	
 	-- if the ❎ button is pressed,
 	-- we initialize the game (restart) 
 	if btnp(❎) then _init() end
 	
 	return 
 
 end
 
	if f<0 then 
	
		f=head.spd --limit speed	
		
		--move snake
		head.prevx=head.x
		head.prevy=head.y		
		--snake grow
		for i=#snake,2,-1 do 
		  snake[i].x=snake[i-1].x
		  snake[i].y=snake[i-1].y
		end
		
		--moving the head of the snake
		head.x+=head.dx
		head.y+=head.dy	
	
	end	
	
	--the followig "if" loops help
	--move the snake within the grid limits
		if btn(⬅️) and head.dx!=8 then
			head.dx=-8
			head.dy=0
			head.sp=4
		elseif btn(➡️) and head.dx!=-8 then
			head.dx=8
			head.dy=0
			head.sp=5
		elseif btn(⬆️) and head.dy!=8 then
			head.dx=0
			head.dy=-8
			head.sp=2
		elseif btn(⬇️) and head.dy!=-8 then
			head.dx=0
			head.dy=8
			head.sp=3
		end	
		
		--collision with apple
		if(head.x==apple.x and
			head.y==apple.y) then
				
				--change the apple's position (randomly)
				apple={
				x=mult8[flr(rnd(#mult8)+1)],
	 		y=mult8[flr(rnd(#mult8)+1)]}
	 		
	 		--snake grow
	 		score+=1
	 		sfx(0)	 		
	 		body={
	 		x=head.prevx,y=head.prevy}
	 		add(snake,body)
	 		
	 		--speed up
	 		if #snake-1==10 then 
		 		head.spd=4
		 		sfx(2)
	 		elseif #snake-1==20 then 
		 		head.spd=3
		 		sfx(2)
	 		elseif #snake-1==30 then 
		 		head.spd=2
		 		sfx(2)
	 		elseif #snake-1==50 then 
		 		sfx(2)
		 		head.spd=1	 		
	 		end
	 		
 	end	
 	
 	--snake out of screen
 	if head.x<0 or head.x>120 or head.y<0 or head.y>120 then
 		game_over=true
 	end
 			
 	--collision with snake
 	for i=2,#snake do
 		if snake[i].x==head.x and snake[i].y==head.y then
 			game_over=true
 		end
 	end
 	
end
------------------------------
function _draw()
	
		cls(1)	
		--game over
		if game_over then
			print("press ❎ to restart", 28,60)
		end -- printing a text to allow player to restart
		
		--draw apple
	 spr(1, apple.x, apple.y)
	 
	 --draw bodies
	 for s in all (snake) do	 
	 	spr(6,s.x, s.y)
	 end
	 
		--draw snake	head
		if not game_over then
	 spr(head.sp,head.x, head.y)
		end 
		 
		--draw score
		print("score "..score,1,1,7)
		
		--draw particles (an animation shown at the end)
		col=3
 	for p in all (parts) do
 		pset(p.x,p.y,col)
 		p.x+=(rnd(2)-1)*10
 		p.y+=(rnd(2)-1)*10
 		p.lt-=1
 		col=flr(rnd(15))
 		if(p.lt==0) then del(parts,p) end
 	end
 	 
end

--particles (if the snake
--exits the screen/the player loses)

parts={}

function make_particles(xx,yy)
	
	for i=1,10 do
		p = {x=xx,y=yy,lt=15}
		add(parts,p)
	end

end
__gfx__
00000000000005500058850000555500005335000053350000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000005885000533335005333350053333500533335000533500000000000000000000000000000000000000000000000000000000000000000000000000
00000000058888505373373533333333537533355333573505333350000000000000000000000000000000000000000000000000000000000000000000000000
00000000088878803353353333333333833333355333333803333330000000000000000000000000000000000000000000000000000000000000000000000000
00000000088888803333333333533533833333355333333803333330000000000000000000000000000000000000000000000000000000000000000000000000
00000000058888505333333553733735537533355333573505333350000000000000000000000000000000000000000000000000000000000000000000000000
00000000005885000533335005333350053333500533335000533500000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000055550000588500005335000053350000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
480100000974624756307663276631756247461973612726007060070600706007060070600706007060070600706007060070600706007060070600706007060070600706007060070600706007060070600706
900100001305200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002
200200003905739057390573a00739007360073200738057380573805729007240071b0071b0073705737057370571b0071b0071b007390073900739007270072c00736007380073a00736007340072e00725007
480100003662233632326423264229642226521a65211652066520060200602006020060200602006020060200602006020060200602006020060200602006020060200602006020060200602006020060200602
