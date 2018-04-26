function fourier_tform(arg)

persistent delta

if nargin<1
    arg = 'init';
end

option = 'ramp2flat';
option = 'square';
% option = 'triangle';
option = 'sawtooth';

switch option

    case 'sawtooth',
        theta0 = [0 0 0 0];
        r =  1./[1 2 3 4];
        w =     [1 2 3 4];

    case 'triangle',
        theta0 = [0 pi 0 pi];
        r =  1./[1 9 25 49];
        w =     [1 3 5 7];

    case 'square',
        theta0 = [0 0 0 0];
        r =  1./[1 3 5 7];
        w =     [1 3 5 7];

    case 'ramp2flat',
        theta0 = [-2.5754    3.1401   -2.9348    3.1385];
        r =     [1.0000    0.4218    0.2874    0.2109];
        w =     [1 2 3 4];

    case 'semicircle',
        theta0 = [1.5708    1.5708    1.5708    1.5708];
        r =     [1.0000    0.3731    0.2070    0.1358];
        w =     [1 2 3 4];

    case 'halfwave',
        theta0 = [pi/2 pi/2 pi/2 pi/2];
        r =  1./[1 5 35/3 21];
        w =     [1 2 3 4];

    case 'test'
        theta0 = [0 0 0 0];
        r =  1./[1 2 3 5];
        w =     [1 2 3 5];

end

switch arg
    case 'init'

        clf
        g = hgtransform;
        g(end+1) = hgtransform;
        g(end+1) = hgtransform;
        g(end+1) = hgtransform;
        hw1 = plotcircle(0,0,1,0);
        hw2 = plotcircle(0,0,1,0);
        hw3 = plotcircle(0,0,1,0);
        hw4 = plotcircle(0,0,1,0);
        tipPt = line(1,0,'Marker','.','Color','red','MarkerSize',21,'EraseMode','none');
        % tracePt = line(1,0,'Marker','.','Color',0.7*[1 1 1],'MarkerSize',6,'EraseMode','none');
        sidePt = line(1.5,0,'Marker','.','Color','red','MarkerSize',21);
        set(hw1,'Parent',g(1))
        set(hw2,'Parent',g(2))
        set(hw3,'Parent',g(3))
        set(hw4,'Parent',g(4))
        axis equal
        axis off
        axis([-2 9 -2 2])
        set(gcf,'Color','white')

        % Create the timer object
        callb = 'fourier_tform animate';
        % destroy time when figure is closed
        set(gcf,'DeleteFcn','t = getappdata(gcf,''timer'');stop(t);delete(t);')
        delta = 0;
        setappdata(gcf,'g',g);
        t=timer('TimerFcn',callb,'Period',0.01,'executionmode','fixedrate');
        setappdata(gcf,'timer',t);
        start(t);

    case 'animate'
        g = getappdata(gcf,'g');
        % Do a vectorized timestep integration of theta
        dt=(2*pi)/150;
        delta = delta + dt;
        theta = theta0 + w*delta;

        set(g(1),'Matrix', ...
            makehgtform( ...
            'ZRotate',theta(1)))

        x1 = r(1)*cos(theta(1));
        y1 = r(1)*sin(theta(1));
        set(g(2),'Matrix', ...
            makehgtform( ...
            'Translate',[x1 y1 0], ...
            'Scale',r(2), ...
            'ZRotate',theta(2)))

        x2 = x1 + r(2)*cos(theta(2));
        y2 = y1 + r(2)*sin(theta(2));
        set(g(3),'Matrix', ...
            makehgtform( ...
            'Translate',[x2 y2 0], ...
            'Scale',r(3), ...
            'ZRotate',theta(3)))

        x3 = x2 + r(3)*cos(theta(3));
        y3 = y2 + r(3)*sin(theta(3));
        set(g(4),'Matrix', ...
            makehgtform( ...
            'Translate',[x3 y3 0], ...
            'Scale',r(4), ...
            'ZRotate',theta(4)))

        x4 = x3 + r(4)*cos(theta(4));
        y4 = y3 + r(4)*sin(theta(4));
        % set(tracePt,'XData',x4,'YData',y4)
        %         set(tipPt,'XData',x4,'YData',y4)
        %         set(sidePt,'YData',y4)
        %         line(rem(delta,2*pi)+2,y4,'Marker','.','Color','red')
end
