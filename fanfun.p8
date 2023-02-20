pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
--name
--by author

function _init()
	t=0
	state="game"

	p_x=10
	p_y=96
	p_dx=0
	p_vy=0
	p_ay=0
	p_flip=false
	p_onground=true
	p_jumping=false
	p_jump=false
	jbuffer=0
	p_flying=false
	j_pressed=false
	
	gravity=0.2
	initial_acc=-2.6994
	alpha=2.251
	
	fans={}
	--addfan(20,90)
	addfan(40,40)
	--addfan(82,90)
	debug=""	
end

function _update60()
	update()
end

function _draw()
	cls()
	
	print(debug,0,100,7)
	draw()
end
-->8
--update

function update()
	if state=="title" then
		if btnp(5) then
			state="game"
		end
	
	elseif state=="game" then
		if btnp(5) then
			state="over"
		end
		p_move()
		fly()
		
	elseif state=="over" then
		if btnp(5) then
			state="title"
		end
	end
end
-->8
--draw

function draw()
	t+=1
	
	--title screen
	if state=="title" then
		title()
	
	--game screen
	elseif state=="game" then
		game()
		
	--game over screen
	elseif state=="over" then
		over()
	end
	
end

--title screen
function title()
	cprint("title",10,7)
	if t%26<18 then
		cprint("press ❎ to start",63,7)
	end
end

--game screen
function game()
	--cprint("playing",10,11)
	map()
	
	--for fan in all(fans) do
	--	draw_fan(fan)
	--end
	
	spr(1,p_x,p_y,1,1,p_flip)
	--cprint("press ❎ to game over",122,7)
end

--gameover screen
function over()
	cprint("gameover",10,8)
	cprint("press ❎ to exit",63,8)
end
-->8
--player

function p_move()
	
	if btn(0) then
		p_dx=max(p_dx-0.2,-1.5)
		p_flip=true
	elseif btn(1) then
		p_dx=min(p_dx+0.2,1.5)
		p_flip=false
	else
		p_dx=p_dx-p_dx*0.1
		
		if abs(p_dx)<0.4 then
			p_dx=0
		end
	end
	
	
	
	--local lastpx=p_x
	p_x+=p_dx
	
	
	p_ay=gravity
	if hit(p_x+p_dx,p_y,7,7) then
  if p_dx<0 then
  	p_x=(flr((p_x+p_dx)/8)+1)*8
  else
  	p_x=(flr((p_x+p_dx)/8))*8
  end
  p_dx=0
 end


	local jump=btn(4) and not p_jump
	p_jump=btn(4)
	if (jump) and p_onground then
 	jbuffer=4
 elseif jbuffer>0 then
 	jbuffer-=1
 end
 
 
 if p_flying then
			p_ay=0
			p_vy=-1
	end
 
 -- jump
 if jbuffer>0 then
  jbuffer=0
  p_vy=-3
  p_onground=false
 end
	
	p_vy+=p_ay
	p_y+=p_vy
		
	if hit(p_x,p_y+p_vy,7,7) then
 	if p_vy>0 then
 		p_onground=true
  	p_ay=0
  	p_y=flr((p_y+p_vy)/8)*8
  else
  	p_y=(flr((p_y+p_vy)/8)+1)*8
  end
  p_vy=0
	end

	
	
end


function fly()
	
	for fan in all(fans) do
		if p_x>fan.x-5 and 
			p_x<fan.x+5 and
			p_y<fan.y and
			not p_onground then
			
			p_onground=false
			p_flying=true
			break
		
		else
			p_flying=false			
		end
	end
end
-->8
--fans

function addfan(_x,_y)
	
	for i=0,15 do
		for j=0,15 do
			if (fget(mget(i,j),2)) then
				local _f={}
				_f.x=i*8
				_f.y=j*8
				
				add(fans,_f)
			end
		end
	end
end


function draw_fan(fan)
	local _r=8
	circfill(fan.x,fan.y,_r,7)
	rectfill(fan.x-_r,fan.y-_r,fan.x+_r,fan.y,13)

	line(
		fan.x+3*sin(t/25),
		fan.y-t%25,
		fan.x+3*sin(t/25),
		fan.y-t%25,
		12
	)
end
-->8
--t5
-->8
--helpers

--centered text
function cprint(s,y,c)
		print(s,64-#s*2,y,c)
end

function hit(x,y,w,h)
  collide=false
  for i=x,x+w,w do
    if (fget(mget(i/8,y/8))>0) or
         (fget(mget(i/8,(y+h)/8))>0) then
          collide=true
    end
  end
  
  for i=y,y+h,h do
    if (fget(mget(x/8,i/8))>0) or
         (fget(mget((x+w)/8,i/8))>0) then
          collide=true
    end
  end
  
  return collide
end
__gfx__
00000000007777000000000000000000000000000000000000000000000000000000000000000000000000000000000007700000000000000000000000000000
00000000007777770000000000000000000000000000000000000000000000000000000000000000000000000000000007700070707070707070700000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007700707070707070707070000000000
00077000077070700000000000000000000000000000000000000000000000000000000000000000000000000000000007700777777777777777707000000000
00077000007777700000000000000000000000000000000000000000000000000000000000000000000000000000000007700707070707070707770000000000
00700700007770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000707000000000
00000000077777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000777777777777707770000000000
00000000007070000000000000000000000000000000000000000000000000000000000000000000000000000000000007700000000000000700707000000000
00077000000000000007700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000707770000000000
00770700000700700070077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700707000000000
00777700007777700077770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000707770000000000
00077000007707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700707000000000
07777700077777700077770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000707770000000000
00777770077777700077770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700707000000000
00777770077777700007700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000707770000000000
00707000000000000070070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700707000000000
00000000000000000000000000000000000000000000000000000000007777700000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000070707000000000000000000000000000000000000000000000000007007777700000000
00000000000000000000000000000000000000000000000000000000077070700000000000000000000000000000000000000000000000007007777700000000
00000000000000000000000000000000000000000000000000000000070707000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000077070700000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000070707000000000000000000000000000000000000000000000000000700707000000000
00000000000000000000000000000000000000000000000000000000077070000000000000000000000000000000000000000000000000000707770000000000
00000000000000000000000000000000000000000000000000000000070707000000000000000000000000000000000000000000000000000700707000000000
00000000000000000000000000000000000000000000000000000000070707000000000000000000777770070707070000000000000000000000000000000000
00000000000000000070007000000000000000000000000000000000000000000000000000000000707070077777770000000000000000000000000000000000
77777777000000007777777700000000000000000000000000000000077777000000000000000000070700000000000000000000000000000000000000000000
77777707000000000000700000000000000000000000000000000000707070000000000000000000707070077777770000000000000000000000000000000000
77777077000000000000000000000000000000000000000000000000770707000000000000000000070700077070700000000000000000000000000000000000
77770707000000000777770700000000000000000000000000000000707070700000000000000000000000070707070000000000000000000000000000000000
07707070000000000007000000000000000000000000000000000000770707000000000000000000707070000000000000000000000000000000000000000000
00777700000000000000000000000000000000000000000000000000000000000000000000000000000000060707070000000000000000000000000000000000
__gff__
0000000000000000000000000202020100000000000000000000000000000202000000000000000200000000020202020400000000000002000001010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000d0d0d0c0d0d0d0e0000000000002700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000001e0000000000003700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000001e0000000000002700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000001e0000000000003700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002e0000000000002700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000001e0000000000003700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1d1d1c1d00000000000000000000002700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000003700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000036000000002700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000d0d0c0d0e00000000000000003700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000001e00000000000000002700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000003600002e00000000003000003700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000003000000000003000000000002700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3a3b3a3b3a3b3a3b3a3b3a3b3a3b3a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
