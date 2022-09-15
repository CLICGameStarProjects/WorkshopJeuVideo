pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
-- connect 4 game --

-- the code runs as follows

-- _init()
-- initializes a global variable
-- for the board

-- _update()
-- 1. endgame check 
-- 2. player turn 'x'
-- 2.1 input check for column
--     selection
-- 2.2 input check to confirm
--     a move
-- 3. ai turn 'o' (random move)

-- _draw() 
-- draw board and
-- some other useful text


function _init()
 board=
 {
  -- game board composed of 
  -- two elements
  -- board.currentturn (x or o)
  -- board.tiles (8x8 array)
  currentturn="x",
  tiles={
   {".",".",".",".",".",".",".","."},
   {".",".",".",".",".",".",".","."},
   {".",".",".",".",".",".",".","."},
   {".",".",".",".",".",".",".","."},
   {".",".",".",".",".",".",".","."},
   {".",".",".",".",".",".",".","."},
   {".",".",".",".",".",".",".","."},
   {".",".",".",".",".",".",".","."}
  }
 }

 -- column index inbetween 1-8
 -- column currently selected
 -- by the player
 selectedcolumn=1

end


-- update loop which is called
-- at every frame (1/30 s)
function _update()

	-- endgame check 
	-- check if game is over
 if terminal(board) then
  -- if button is pressed, 
  -- start new game
  if btnp(🅾️) then
   _init()
  end
  return
 end

 -- player turn
	if board.currentturn=="x" then
	
		-- column selection
	 if btnp(⬅️) then
	  selectedcolumn-=1
	 end
	
	 if btnp(➡️) then
	  selectedcolumn+=1
	 end
	
	 if selectedcolumn<1 then
	  selectedcolumn=8
	 end
	
	 if selectedcolumn>8 then
	  selectedcolumn=1
	 end
	 
	 -- play in the chosen column
	 -- if it is not full and 
	 -- change the player to 'o'
  if btnp(🅾️) then
   if iscolumnfull(board,selectedcolumn) == false then
    modifyboard(board,selectedcolumn)
    changeturn(board)
   end
  end
 end
 
 -- ai turn (it plays randomly)
 if board.currentturn=="o" then
  rndcolumn = rnd(allpossiblemoves(board))
  modifyboard(board,rndcolumn)
  changeturn(board)
 end

end

-- draw loop which is called
-- at every frame (1/30 s)
function _draw()
 cls()

 -- instructions
 -- todo: sequence!
 -- afficher les instructions
 -- de comment jouer sur
 -- l'ecran


 -- draw board starting at
 -- point (32,32)
 -- each sprite we use is 8x8
 for i=1,8 do
  for j=1,8 do
   local x=32+j*8
   local y=32+i*8

   if board.tiles[i][j]=="x" then
    spr(3,x,y)
   elseif board.tiles[i][j]=="o" then
    spr(4,x,y)
   else
    spr(2,x,y)
   end
  end
 end



 -- print hand above columns
 local x=32+selectedcolumn*8
 local y=16
 spr(1,x,y)


	-- if the game is over,
	-- print some info
 if terminal(board) then
  if winner(board)=="x" then
   print("blue wins!",52,110,12)
  else
   print("red wins!",52,110,8)
  end

  print("z/🅾️ to play again",52,116)
 end


end


-- this function changes the
-- board 'currentturn' from
-- 'x' to 'o' and conversely
function changeturn(board)
 if board.currentturn=="x" then
  board.currentturn="o"
 else
  board.currentturn="x"
 end
end



-- returns true if the column, 
-- whose index is 1 <= col <= 8, 
-- is full
function iscolumnfull(board,col)
 -- todo: loop!
 -- il faut verifier si la col
 -- est pleine, et dire vrai,
 -- sinon faux
 return true
end


-- returns column indices where 
-- it is still possible to play
function allpossiblemoves(board)
 local moves={}
 for i=1,8 do
  if iscolumnfull(board,i) == false then
   add(moves,i)
  end
 end
 return moves
end

-- this function modifies the
-- board when a player plays
-- in the column with index 'col'
function modifyboard(board,col)
 for i=8,1,-1 do
  if board.tiles[i][col] == "." then
   board.tiles[i][col] = board.currentturn
   return
  end
 end
end

function winner(board)
 local tiles=board.tiles

 for i=1,8 do
  for j=1,8 do
   if tiles[i][j]!="." then

    -- horizontal
    if j<6
    and tiles[i][j]==tiles[i][j+1]
    and tiles[i][j]==tiles[i][j+2]
    and tiles[i][j]==tiles[i][j+3] then
     return tiles[i][j]
    end

    -- vertical
    if i<6
    and tiles[i][j]==tiles[i+1][j]
    and tiles[i][j]==tiles[i+2][j]
    and tiles[i][j]==tiles[i+3][j] then
     return tiles[i][j]
    end

    -- diagonal \
    if j<6 and i<6
    and tiles[i][j]==tiles[i+1][j+1]
    and tiles[i][j]==tiles[i+2][j+2]
    and tiles[i][j]==tiles[i+3][j+3] then
     return tiles[i][j]
    end

    -- diagonal /
    -- todo: if!
    -- sur la base du code pour
    -- la verification de ligne
    -- horizontale, verticale
    -- et diagonale de la
    -- forme /, faire \
   end
  end
 end
 return nil 
end


-- returns true if game is over
function terminal(board)
	
 if winner(board) then
  return true
 end

 if count(allpossiblemoves(board))==0 then
  return true
 end

 return false
end

__gfx__
00000000000000000099990000999900009999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ddd000900009009cccc90098888900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000d776d0900000099cccccc9988888890000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000d7777d0900000099cccccc9988888890000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000777d0900000099cccccc9988888890000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000007dd00900000099cccccc9988888890000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000007d0000900009009cccc90098888900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000d00000099990000999900009999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
