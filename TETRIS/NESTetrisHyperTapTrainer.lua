local frame_rate = 60; --nes NTSC framerate 50 for PAL.

local frame = 1;
local tap_buffer = {}; --fill with press / no press to framerate


local tetris = {};
tetris.gamePhase = 0x0048;
--ABsSUDLR
tetris.controllerBitFlags = 0x00B5;
tetris.controllerStates = 0x00B6;
tetris.screen = 0x00C0;

local screens = {};
screens.copyrightScreen = 0x0;
screens.titleScreen = 0x1;
screens.gameTypeSelect = 0x2;
--atype and btype
screens.LvSelect = 0x3; 
screens.playfield = 0x4;
screens.demo = 0x5;

local tap_hz = 0;
local best_tap_hz = 0;


function draw_hypertap_stats(controller_bit_flags)  

  if(frame > frame_rate) then
    frame = 1;
  end;

  if(controller_bit_flags == 1 or controller_bit_flags == 2) then
    tap_buffer[frame] = 1;
  else
    tap_buffer[frame] = 0;
  end;

  tap_hz = 0;
  for _, v in ipairs(tap_buffer) do
    tap_hz = tap_hz + v;
  end;

  if(best_tap_hz < tap_hz) then
    best_tap_hz = tap_hz;
  end;

  -- don't care about other flags or combinations as only tapping left/right

  gui.drawbox(10,21,85,47,"clear","black");
  gui.drawbox(11,22,84,46,"clear","gray");
  gui.drawbox(12,23,83,45,"#9CFCF0");
  gui.drawbox(13,24,82,44,"black");
  gui.text(17,30,"Hz:"..tap_hz.." Max:"..best_tap_hz, "white", "clear");
end;

local in_game = false;

while (true) do
  if (memory.readbyte(tetris.screen) == screens.playfield) then
    if (not in_game) then
      in_game = true;
    end;
  else
    in_game = false;
  end;
  if (in_game) then
    draw_hypertap_stats(memory.readbyte(tetris.controllerBitFlags));
  end;
  frame = frame + 1;
  FCEU.frameadvance();
end;
