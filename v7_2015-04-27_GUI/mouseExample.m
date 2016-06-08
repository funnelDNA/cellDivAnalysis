function mouseExample()
    h = plot(rand(10,1), 'o-');
  %  set(h, 'ButtonDownFcn',@buttonDownCallback)
    set(gca, 'ButtonDownFcn',@buttonDownCallback)
    function buttonDownCallback(o,e)
        p = get(gca,'CurrentPoint');
        p = p(1,1:2);
        title( sprintf('(%g,%g)',p) )
        disp(p);
        o
        e
        
    end
end