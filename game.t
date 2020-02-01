%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                %%
%% PROGRAM BY LUCA BRUNI                          %%
%% GRADE 11 CULMINATING TASK, COMPUTER ENGINEERING%%
%% Date: 1/30/2017                                %%
%% Bit-WarZ                                       %%
%%                                                %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Enable any GUI if used
import GUI

%Set screen size and get rid of buttons on the side
View.Set ("offscreenonly")
setscreen ("graphics:800;600,nobuttonbar")

%Elapse time from game start
var start : int
var elapsed : int

%Control speed of game
const fps : int := 15

%Player model arrays for four sides
var p : array 1 .. 4 of int
var p2 : array 1 .. 4 of int

%Variables for each primary bullet in a burst fire (there may be 3 on the screen at once)
var bulletx : array 1 .. 3 of int
var bullety : array 1 .. 3 of int
var p2bulletx : array 1 .. 3 of int
var p2bullety : array 1 .. 3 of int

%Variables for actually displaying the primary bullet
var bulletDraw : array 1 .. 3 of boolean
var p2bulletDraw : array 1 .. 3 of boolean

%Constant speed for primary bullet travel
var bulletSpeed : int := 8
var p2bulletSpeed : int := 8

%Pictures used in the code, including the tanks, bullets, background and startup IMG
var bullet := Pic.FileNew ("bullet.bmp")
var bullet2 := Pic.FileNew ("bullet2.bmp")
var tank1 := Pic.FileNew ("tank1.bmp")
var tank2 := Pic.FileNew ("tank2.bmp")
var bg := Pic.FileNew ("trench.bmp")
var lobbyp := Pic.FileNew ("lobbyp.bmp")

%Also pictures, with rotation for Player 2
var bulletp2 := Pic.Rotate (bullet, 180, -1, -1)
var bullet2p2 := Pic.Rotate (bullet2, 180, -1, -1)

%Constant speed for moving the character
const moveSpeed : int := 4

%Variable created to check if a key is pressed
var chars : array char of boolean

%Boolean for if a button is held or not. This helps with cooldowns
var held : boolean := false
var heldp2 : boolean := false

%Boolean variable if p1wins. We only need one because we can use 'Else' for player 2's win
var p1win : boolean

%How much time has passed since a primary bullet has been fired
var bulletElapsed : int
var p2bulletElapsed : int

%Variable to give a player certain amount of hitpoints
var health : int
var healthp2 : int

%Creating fonts for throughout the game
var font1 : int
var font2 : int
var font3 : int
var font4 : int

%Declaration of those fonts
font1 := Font.New ("serif:12")
font2 := Font.New ("serif:42")
font3 := Font.New ("serif:15")
font4 := Font.New ("serif:72")

%Gives values to the x, y locations of the mouse and if a button is clicked
var x, y, button : int

%How much time has passed since a secondary bullet has been fired
var berthaElapsed : int := 0
var p2berthaElapsed : int := 0

%Variables for actually displaying the secondary bullet
var berthaDraw : boolean := false
var p2berthaDraw : boolean := false

%Variables for each seconday bullet (x and y locations)
var berthax : int := 0
var p2berthax : int := 0
var berthay : int := 0
var p2berthay : int := 0

%Constant speed for secondary bullet travel
var berthaSpeed : int := 4

%Blast radius values for the secondary bullet when it explodes
var radxp1 : real
var radxp2 : real
var radyp1 : real
var radyp2 : real

%Decides whether or not to decrease each health bar
var p1hit : int := 0
var p2hit : int := 0

%Upon start-up, these values are always maintained each time even after a game
procedure initialize
    bulletDraw (1) := false
    bulletDraw (2) := false
    bulletDraw (3) := false

    p2bulletDraw (1) := false
    p2bulletDraw (2) := false
    p2bulletDraw (3) := false

    bulletElapsed := 0
    p2bulletElapsed := 0

    health := 20
    healthp2 := 20

    p (1) := 10 %x1
    p (2) := 50 %x2
    p (3) := 10 %y1
    p (4) := 50 %y2

    p2 (1) := 750 %x1
    p2 (2) := 790 %x2
    p2 (3) := 550 %y1
    p2 (4) := 590 %y2
end initialize

%Procedure that moves Player 1 depending on if a key is pressed
proc movingp1
    %Checks if a key is pressed
    Input.KeyDown (chars)

    if chars ('w') then
	p (3) := p (3) + moveSpeed
	p (4) := p (4) + moveSpeed
    end if
    if chars ('a') then
	p (1) := p (1) - moveSpeed
	p (2) := p (2) - moveSpeed
    end if
    if chars ('s') then
	p (3) := p (3) - moveSpeed
	p (4) := p (4) - moveSpeed
    end if
    if chars ('d') then
	p (1) := p (1) + moveSpeed
	p (2) := p (2) + moveSpeed
    end if
    %Draws player 1 tank image
    Pic.Draw (tank1, p (1) + 5, p (3), picMerge)
end movingp1

%Procedure that moves Player 2 depending on if a key is pressed
proc movingp2
    %Checks if a key is pressed
    Input.KeyDown (chars)

    if chars (KEY_UP_ARROW) then
	p2 (3) := p2 (3) + moveSpeed
	p2 (4) := p2 (4) + moveSpeed
    end if
    if chars (KEY_LEFT_ARROW) then
	p2 (1) := p2 (1) - moveSpeed
	p2 (2) := p2 (2) - moveSpeed
    end if
    if chars (KEY_DOWN_ARROW) then
	p2 (3) := p2 (3) - moveSpeed
	p2 (4) := p2 (4) - moveSpeed
    end if
    if chars (KEY_RIGHT_ARROW) then
	p2 (1) := p2 (1) + moveSpeed
	p2 (2) := p2 (2) + moveSpeed
    end if
    %Draws player 2 tank image
    Pic.Draw (tank2, p2 (1) + 5, p2 (3), picMerge)
end movingp2

%Checks if Player 1 is in the correct boundary
proc boundsp1
    if p (1) <= 0 and p (2) <= 406 then
	p (1) := 1
	p (2) := 41
    end if
    if p (2) >= maxx and p (2) >= 760 then
	p (2) := 799
	p (1) := 759
    end if
    if p (3) <= 0 and p (4) <= 40 then
	p (3) := 1
	p (4) := 41
    end if
    if p (4) >= 160 and p (3) >= 120 then
	p (4) := 159
	p (3) := 119
    end if
end boundsp1

%Checks if Player 2 is in the correct boundary
proc boundsp2
    if p2 (1) <= 0 and p2 (2) <= 406 then
	p2 (1) := 1
	p2 (2) := 41
    end if
    if p2 (2) >= maxx and p2 (2) >= 760 then
	p2 (2) := 799
	p2 (1) := 759
    end if
    if p2 (4) >= maxy and p2 (3) >= 560 then
	p2 (4) := 599
	p2 (3) := 559
    end if
    if p2 (3) <= 440 and p2 (4) <= 480 then
	p2 (4) := 481
	p2 (3) := 441
    end if
end boundsp2

%Bullet moves accordingly by adding the constant of bulletSpeed to it's 'y' position
%Boundaries for the bullet are set
%Player 1's bullet moving [UP]
proc bulletmovep1
    if bulletDraw (1) = true then
	Pic.Draw (bullet, bulletx (1), bullety (1), picMerge)
	bullety (1) := bullety (1) + bulletSpeed

	if bullety (1) >= 589 then
	    bulletDraw (1) := false
	end if
    end if

    if bulletDraw (2) = true then
	Pic.Draw (bullet, bulletx (2), bullety (2), picMerge)
	bullety (2) := bullety (2) + bulletSpeed

	if bullety (2) >= 589 then
	    bulletDraw (2) := false
	end if
    end if

    if bulletDraw (3) = true then
	Pic.Draw (bullet, bulletx (3), bullety (3), picMerge)
	bullety (3) := bullety (3) + bulletSpeed

	if bullety (3) >= 589 then
	    bulletDraw (3) := false
	end if
    end if
end bulletmovep1

%Bullet moves accordingly by adding the constant of bulletSpeed to it's 'y' position
%Boundaries for the bullet are set
%Player 2's bullet moving [DOWN]
proc bulletmovep2
    if p2bulletDraw (1) = true then
	Pic.Draw (bulletp2, p2bulletx (1), p2bullety (1), picMerge)
	p2bullety (1) := p2bullety (1) - p2bulletSpeed

	if p2bullety (1) <= 11 then
	    p2bulletDraw (1) := false
	end if
    end if

    if p2bulletDraw (2) = true then
	Pic.Draw (bulletp2, p2bulletx (2), p2bullety (2), picMerge)
	p2bullety (2) := p2bullety (2) - p2bulletSpeed

	if p2bullety (2) <= 11 then
	    p2bulletDraw (2) := false
	end if
    end if

    if p2bulletDraw (3) = true then
	Pic.Draw (bulletp2, p2bulletx (3), p2bullety (3), picMerge)
	p2bullety (3) := p2bullety (3) - p2bulletSpeed

	if p2bullety (3) <= 11 then
	    p2bulletDraw (3) := false
	end if
    end if
end bulletmovep2

%Checks if Player 1 shoot button is pressed
proc shootp1
    if chars (' ') then
	if (Time.Elapsed - bulletElapsed) > 250 & held = false then
	    if bulletDraw (1) = false then
		bulletDraw (1) := true
		bulletx (1) := p (2) - 21
		bullety (1) := p (4) + 5
		bulletElapsed := Time.Elapsed
	    elsif bulletDraw (2) = false then
		bulletDraw (2) := true
		bulletx (2) := p (2) - 21
		bullety (2) := p (4) + 5
		bulletElapsed := Time.Elapsed
	    elsif bulletDraw (3) = false then
		bulletDraw (3) := true
		bulletx (3) := p (2) - 21
		bullety (3) := p (4) + 5
		bulletElapsed := Time.Elapsed
		held := true
	    end if
	end if
    elsif held = true then
	held := false
    end if
    bulletmovep1
end shootp1

%Checks if Player 2 shoot button is pressed
proc shootp2
    if chars (KEY_CTRL) then
	if (Time.Elapsed - p2bulletElapsed) > 250 & heldp2 = false then
	    if p2bulletDraw (1) = false then
		p2bulletDraw (1) := true
		p2bulletx (1) := p2 (2) - 21
		p2bullety (1) := p2 (3) - 20
		p2bulletElapsed := Time.Elapsed
	    elsif p2bulletDraw (2) = false then
		p2bulletDraw (2) := true
		p2bulletx (2) := p2 (2) - 21
		p2bullety (2) := p2 (3) - 20
		p2bulletElapsed := Time.Elapsed
	    elsif p2bulletDraw (3) = false then
		p2bulletDraw (3) := true
		p2bulletx (3) := p2 (2) - 21
		p2bullety (3) := p2 (3) - 20
		p2bulletElapsed := Time.Elapsed
		heldp2 := true
	    end if
	end if
    elsif heldp2 = true then
	heldp2 := false
    end if
    bulletmovep2
end shootp2

%Checks if a bullet collides with Player 1; if so, health is taken away and that bullet disappears
proc hp
    for i : 1 .. 3
	if p2bulletDraw (i) = true then
	    if p2bullety (i) <= p (4) and p2bullety (i) >= p (3) then
		if p2bulletx (i) + 7 >= p (1) and p2bulletx (i) + 7 <= p (2) then
		    health := health - 1
		    p2bulletDraw (i) := false
		end if
	    end if
	end if
    end for
    drawfillbox (5, 250, 25, 250 + 5 * health, blue)
    drawbox (4, 249, 26, 351, black)
end hp

%Checks if a bullet collides with Player 2; if so, health is taken away and that bullet disappears
proc hpp2
    for i : 1 .. 3
	if bulletDraw (i) = true then
	    if bullety (i) + 15 <= p2 (4) and bullety (i) + 15 >= p2 (3) then
		if bulletx (i) + 7 >= p2 (1) and bulletx (i) + 7 <= p2 (2) then
		    healthp2 := healthp2 - 1
		    bulletDraw (i) := false
		end if
	    end if
	end if
    end for
    drawfillbox (775, 350 - 5 * healthp2, 795, 350, red)
    drawbox (774, 249, 796, 351, black)
end hpp2

%Blast radius created by the secondary bullet ***onto Player 2***
procedure explosionp1
    p2hit := Time.Elapsed
    for i : 0 .. 359
	var degree : real := i
	degree := degree * 3.141592 / 180
	radxp1 := berthax + 40 * cos (degree)
	radyp1 := berthay + 40 * sin (degree)
	if radyp1 <= p2 (4) and radyp1 >= p2 (3) then
	    if radxp1 >= p2 (1) and radxp1 <= p2 (2) then
		healthp2 := healthp2 - 5
		exit
	    end if
	end if
    end for
end explosionp1

%Blast radius created by the secondary bullet ***onto Player 1***
procedure explosionp2
    p1hit := Time.Elapsed
    for i : 0 .. 359
	var degree : real := i
	degree := degree * 3.141592 / 180
	radxp2 := p2berthax + 40 * cos (degree)
	radyp2 := p2berthay + 40 * sin (degree)

	if radyp2 <= p (4) and radyp2 >= p (3) then
	    if radxp2 >= p (1) and radxp2 <= p (2) then
		health := health - 5
		exit
	    end if
	end if
    end for
end explosionp2

%Procedure that draws and moves the secondary bullet for player 1
proc berthamovep1
    if berthaDraw = true then
	Pic.Draw (bullet2, berthax, berthay, picMerge)
	berthay := berthay + berthaSpeed

	if berthay >= 549 then
	    explosionp1
	    berthaDraw := false
	end if
	if berthay >= p2 (3) and berthay <= p2 (4) then
	    if berthax >= p2 (1) and berthax <= p2 (2) then
		explosionp1
		berthaDraw := false
	    end if
	end if
    end if
end berthamovep1

%Procedure that draws and moves the secondary bullet player 2
proc berthamovep2
    if p2berthaDraw = true then
	Pic.Draw (bullet2p2, p2berthax, p2berthay, picMerge)
	p2berthay := p2berthay - berthaSpeed

	if p2berthay <= 51 then
	    explosionp2
	    p2berthaDraw := false
	end if
	if p2berthay >= p (3) and p2berthay <= p (4) then
	    if p2berthax >= p (1) and p2berthax <= p (2) then
		explosionp2
		p2berthaDraw := false
	    end if
	end if

    end if
end berthamovep2

%Checks if the secondary shoot button for Player 1 is pressed
procedure berthap1
    if chars ('e') then
	if (Time.Elapsed - berthaElapsed) > 250 then
	    if berthaDraw = false then
		berthaDraw := true
		berthax := p (2) - 21
		berthay := p (4) + 5
		berthaElapsed := Time.Elapsed
	    end if
	end if
    end if
    berthamovep1
end berthap1

%Checks if the secondary shoot button for Player 2 is pressed
procedure berthap2
    if chars (KEY_SHIFT) then
	if (Time.Elapsed - p2berthaElapsed) > 250 then
	    if p2berthaDraw = false then
		p2berthaDraw := true
		p2berthax := p2 (2) - 21
		p2berthay := p2 (3) - 20
		p2berthaElapsed := Time.Elapsed
	    end if
	end if
    end if
    berthamovep2
end berthap2

%Procedure using elapsed time. This makes it so that if a bullet is fired, there is a cooldown that appears graphically
procedure cooldown
    drawfillbox (35, 250, 55, 270, grey)
    if Time.Elapsed - bulletElapsed < 250 then
	drawfillbox (35, 250, 55, 270, darkgrey)
    end if
    drawbox (34, 249, 56, 271, black)
    Pic.Draw (bullet, 43, 252, picMerge)

    drawfillbox (745, 250, 765, 270, grey)
    if Time.Elapsed - p2bulletElapsed < 2050 then
	drawfillbox (745, 250, 765, 270, darkgrey)
    end if
    drawbox (744, 249, 766, 271, black)
    Pic.Draw (bullet, 753, 252, picMerge)

    drawfillbox (35, 280, 55, 300, grey)
    if berthaDraw = true then
	drawfillbox (35, 280, 55, 300, darkgrey)
    end if
    drawbox (34, 279, 56, 301, black)
    Pic.Draw (bullet2, 42, 282, picMerge)

    drawfillbox (745, 280, 765, 300, grey)
    if p2berthaDraw = true then
	drawfillbox (745, 280, 765, 300, darkgrey)
    end if
    drawbox (744, 279, 766, 301, black)
    Pic.Draw (bullet2, 752, 282, picMerge)
end cooldown



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%****************MAIN GAME LOOP, ALL PROCEDURES AND MAIN FUNTIONS GO HERE:****************%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
procedure gameloop
    loop
	cls
	start := Time.Elapsed

	%Draws background
	Pic.Draw (bg, 0, 0, picMerge)

	%All procedures to run the game:
	boundsp1
	boundsp2
	movingp1
	movingp2
	shootp1
	shootp2
	berthap1
	berthap2
	cooldown
	hp
	hpp2

	%Actual circle and it's blast radius drawn after the explosion from each player's secondary weapon
	if Time.Elapsed - p1hit < 250 then
	    drawfilloval (p2berthax, p2berthay, 40, 40, red)
	end if

	if Time.Elapsed - p2hit < 250 then
	    drawfilloval (berthax, berthay, 40, 40, red)
	end if

	View.Update

	%Winning the game and exiting the main game loop if so:
	if health <= 0 then
	    health := 0
	    p1win := false
	    exit
	end if
	if healthp2 <= 0 then
	    healthp2 := 0
	    p1win := true
	    exit
	end if

	%Determines a speed for the game using an if condition with an elapsed time to create a master delay as opposed to using global delays
	elapsed := Time.Elapsed - start
	if elapsed < fps then
	    delay (fps - elapsed)
	end if
    end loop

    %If any player wins, a message is displayed
    if p1win = true then
	Font.Draw ("P1... WIN!", 270, 300, font2, white)
    else
	Font.Draw ("P2... WIN!", 270, 300, font2, white)
    end if
    View.Update
    delay (2500)
end gameloop

%Beginning procedure for the start-up menu
procedure lobby
    loop
	%Colours a background with a colour-ID
	colourback (142)
	cls
	mousewhere (x, y, button)

	Pic.Draw (lobbyp, 20, 200, picMerge)
	Font.Draw ("Bit-WarZ", 350, 80, font4, black)

	drawfillbox (35, 50, 85, 75, black)
	drawfillbox (32, 53, 88, 72, black)
	Font.Draw ("Start", 47, 59, font1, white)
	drawfillbox (110, 50, 160, 75, black)
	drawfillbox (107, 53, 163, 72, black)
	Font.Draw ("Instr.", 120, 59, font1, white)
	drawfillbox (185, 50, 235, 75, black)
	drawfillbox (182, 53, 238, 72, black)
	Font.Draw ("Contr.", 192, 59, font1, white)
	Font.Draw ("Welcome to Bit-WarZ!", 62, 130, font1, black)
	Font.Draw ("Re-make by Luca Bruni.", 62, 100, font1, black)

	%If conditions that perform a task if a button is pressed
	if x > 35 and x < 85 and y > 50 and y < 75 and button = 1 then
	    initialize
	    gameloop
	elsif x > 35 and x < 85 and y > 50 and y < 75 then
	    drawfillbox (35, 50, 85, 75, white)
	    Font.Draw ("Start", 47, 59, font1, black)
	end if

	if x > 110 and x < 160 and y > 50 and y < 75 and button = 1 then
	    put "Welcome to the Instructions page!"
	    put "To play this game, you need 2 players, one for each tank."
	    put "In order to win, you must demolish your opponent using weapons."
	    put "To view the controls for this game, simply click the 'Contr.' button."
	elsif x > 110 and x < 160 and y > 50 and y < 75 then
	    drawfillbox (110, 50, 160, 75, white)
	    Font.Draw ("Instr.", 120, 59, font1, black)
	end if

	if x > 185 and x < 235 and y > 50 and y < 75 and button = 1 then
	    put "PLAYER 1:"
	    put "W - Up | S - Down | A - Left | D - Right"
	    put "Press SPACEBAR to shoot primary weapon."
	    put "Press E to shoot secondary weapon."
	    put "PLAYER 2:"
	    put "UP ARROW - Up | DOWN ARROW - Down | LEFT ARROW - Left | RIGHT ARROW - Right"
	    put "Press CTRL to shoot primary weapon."
	    put "Press SHIFT to shoot secondary weapon."
	elsif x > 185 and x < 235 and y > 50 and y < 75 then
	    drawfillbox (185, 50, 235, 75, white)
	    Font.Draw ("Contr.", 195, 59, font1, black)
	end if

	View.Update
	cls
    end loop
end lobby

%Initially runs the 'lobby' procedure, effectively beginning the whole program.
lobby
