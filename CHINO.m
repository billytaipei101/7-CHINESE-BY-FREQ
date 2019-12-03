function [] = CHINO(y,x)
    % chino - Two-Character Chinese words Study Script
    %  This is a script to study two-character chinese words, the used xlsx
    %  file is organized by difficulty according to the natural log of the
    %  frequency per million.
    %   Detailed explanation goes here
    %   y = Number of two-character Chinese words to be presented 
    %   x = Level of difficulty according to a seven levels scale, being 1
    %       the easiest and 7 the hardest. The levels were defined according
    %       to the natural log of the frequency per million.
    %
    % Frequent errors|warnings:
    %  - Categories 3 ?from 10 row? ~ 7 have not been revised nor extended
    %  - Frequent errors include not finding the font for drawing the text;
    %    in that case run d=listfonts in MAC for list of available fonts 
    %% Step 1 Retrieve list of Two-Character Chinese words
    [num,txt,~] = xlsread('two.xlsx',x);
    limit = size(num,1);
    if y > limit
        y = limit;
    end
    dice    = (1:1:limit);
    level   = Shuffle(dice);
    levelqq = level(1:y);
    sti2    = txt(levelqq,2:3);   % C1 & C2 pinyin
    meaning = txt(levelqq,1);     % definition
    mean    = char(meaning(:,:));
    c       = zeros(size(mean,1),1);
    for i   = 1:y
        bub =char(meaning(i,:));
        cc  = size(bub,2)/2;
        c(i)=round(cc/2);         % optionally divided in two
    end
    % color options from 1st up to 5th tone
    % colours = [255 255 0;238 0 0;145 44 238;24 116 205;100 100 100];
    colours = [253 185 40;235 43 73;93 78 163;24 116 205;100 100 100];
    tone    = zeros(y,4);
    for i = 1:y
        for j = 1:4
            tone(i,j)=num(levelqq(i),j);
        end
    end
    %% Step 2 Function Settings
    %  Must try Background colors a) color0 , b) color1
    %color0 = [255,255,255]; % White
    color1 = [108,196,154];  % Green Pastel
    color2 = [75 ,62 ,154]; % Purple Pastel
    %color3 = [235,79 ,132]; % Pink
    %color4 = [252,187,129]; % Light Orange
    Screen('Preference', 'SkipSyncTests',1);
    [w,rect] = Screen('OpenWindow', 1, color1); % Change to windows 0 default, 1 or 2
                                                % in case different
                                                % screens
    cs       = rect(3:4)/2;
    Screen('Preference', 'TextRenderer', 2);
    Screen('Preference', 'TextAntiAliasing', 1);
    Screen('Preference', 'TextAlphaBlending', 0);
    Screen('Preference', 'SuppressAllWarnings', 1);
    Screen('Preference', 'VisualDebugLevel', 1);
    %HideCursor(w)
    Screen('TextStyle',w, 0);
    charsz  = 220;
    fontchi = ('Songti SC'); 
    pinyin  = 40;
    alphasz = 40;
    fontalph= ('Euphemia UCAS');
    bb=[cs(1)-(charsz),cs(2)-charsz/2,cs(1),cs(2)+160, ((cs(1)-(charsz))+(pinyin*1.5)), (cs(2)-(charsz/2))-pinyin, cs(1)+(pinyin*1.5),(cs(2)-charsz/2)-pinyin];
    
    for i = 1:y
        for j = 1:5
            if tone(i,1)==j
                rectx1 = colours(j,:);
            end
            if tone(i,2)==j
                rectx2 = colours(j,:);
            end
        end
        str = char(tone(i,3:4));
        Screen('TextSize',w, charsz);
        Screen('TextFont',w, fontchi);
        Screen('DrawText',w, double(str(1)), bb(1),bb(2), rectx1);
        Screen('DrawText',w, double(str(2)), bb(3),bb(2), rectx2);
        
        % meaning
        Screen('TextSize',w, alphasz);
        Screen('TextFont',w, fontalph);
        Screen('DrawText',w, double(mean(i,:)), cs(1)-charsz,bb(4)+30, color2);
        
        % using pinyin
        Screen('TextSize',w, pinyin);
        Screen('TextFont',w, fontalph);
        Screen('DrawText', w, char(sti2(i,1)) , bb(5),bb(6)+30, color2);
        Screen('DrawText', w, char(sti2(i,2)) , bb(7),bb(8)+30, color2);
        
        Screen('Flip',w);
        feature('DefaultCharacterSet', 'UTF-8');
        feature('DefaultCharacterSet', 'UTF-8');
        system( sprintf('say -v Mei -r 180 %s', str) );
        feature('DefaultCharacterSet', 'Big-5');
        feature('DefaultCharacterSet', 'Big-5');
        
        WaitSecs(0.1);
        
        keys=zeros(10,256);
        for k = 1:5
            [~,tic,~]=KbWait;
            keys(k,:)=tic;
            while keys(k,44)~=1
                if keys(k,21)==1
                    feature('DefaultCharacterSet', 'UTF-8');
                    feature('DefaultCharacterSet', 'UTF-8');
                    system( sprintf('say -v Mei -r 180 %s', str) );
                    feature('DefaultCharacterSet', 'Big-5');
                    feature('DefaultCharacterSet', 'Big-5');
                elseif keys(k,8)==1
                    feature('DefaultCharacterSet', 'UTF-8');
                    feature('DefaultCharacterSet', 'UTF-8');
                    stralp = char(mean(i,:));
                    system( sprintf('say -v Alex -r 180 %s', stralp) );
                    %feature('DefaultCharacterSet', 'Big-5');
                    %feature('DefaultCharacterSet', 'Big-5');
                end
                break
            end
        end
    end
    Screen('Flip',w);
    Screen('CloseAll');
end